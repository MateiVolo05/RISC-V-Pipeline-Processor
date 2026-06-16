module DataPath(
    input clk, res,
    //WB
    input RegWrite, MemToReg,
    //M
    input Branch, MemRead, MemWrite, Jump,
    //EX
    input [1:0] ALUOp,
    input ALUSrc,
    output [6:0] opcode
);
    reg [31:0] PC;
    reg [63:0] IF_ID;
    reg [155:0] ID_EX;
    reg [139:0] EX_MEM;
    reg [103:0] MEM_WB;
    
    wire[31:0] IR;
    
    wire [1:0] PCSrc;
    wire Zero;
    wire [3:0] ALUSel;
    wire [31:0] newPC;
    wire [31:0] immOut;
    wire [31:0] aluOut;
    wire [31:0] ra;
    wire [31:0] rb;
    wire [31:0] readData;
    wire [1:0] forwardA;
    wire [1:0] forwardB;
    wire [31:0] mux_forward_rb = ((forwardB == 2'b00) ? ID_EX[72:41] : (forwardB == 2'b10) ? EX_MEM[68:37] : (MEM_WB[69] == 0)? MEM_WB[36:5] : MEM_WB[68:37]);
    wire IF_ID_Write;
    wire PCWrite;
    wire ID_EX_Sel;
    
    reg [1:0] PCSrc_calc;
    wire signA = (forwardA == 2'b00) ? ID_EX[104] : (forwardA == 2'b10) ? EX_MEM[68] : (MEM_WB[69] == 0)? MEM_WB[36] : MEM_WB[68];
    wire signB = (ID_EX[137] == 0) ? mux_forward_rb[31] : ID_EX[40];
    always @(*)
        if(ID_EX[155])
            PCSrc_calc = 2'b10;
        else if(ID_EX[7:5] == 3'b000 && ID_EX[142] & Zero) //beq
            PCSrc_calc = 2'b01;
        else if(ID_EX[7:5] == 3'b001 && ID_EX[142] & (!Zero)) //bne
            PCSrc_calc = 2'b01;
        else if(ID_EX[7:5] == 3'b100 && ID_EX[142] & ((signA == 1 && signB == 0) || (signA == signB && aluOut[31] == 1))) //blt
            PCSrc_calc = 2'b01;
         else if(ID_EX[7:5] == 3'b101 && ID_EX[142] & ((signA == 0 && signB == 1) || (signA == signB && aluOut[31] == 0 || Zero))) //bge
            PCSrc_calc = 2'b01;
        else
            PCSrc_calc = 2'b00;
    
    assign opcode = IF_ID[6:0];
    assign PCSrc = PCSrc_calc;
    assign newPC = (PCSrc == 2'b0)? (PC + 4) : (PCSrc == 2'b01 || (PCSrc == 2'b10 && ID_EX[137] == 0)) ? (ID_EX[136:105] + ID_EX[40:9]) : aluOut;
    
    always @(posedge clk)
    begin
        if(res)
        begin
            PC<=32'b0;
            IF_ID<=64'b0;
            ID_EX<=156'b0;
            EX_MEM<=140'b0;
            MEM_WB<=104'b0;
        end
        else
        begin
            if(PCWrite)
                PC<=newPC;
            if(PCSrc != 1'b0)
                IF_ID<=64'b0;
            else if(IF_ID_Write)
                IF_ID<={PC, IR};
            if(PCSrc != 1'b0)
                ID_EX<=156'b0;
            else if(ID_EX_Sel == 0)
                ID_EX<={Jump, IF_ID[19:15], IF_ID[24:20], RegWrite, MemToReg, Branch, MemRead, MemWrite, ALUOp, ALUSrc, IF_ID[63:32], ra, rb, immOut, IF_ID[30], IF_ID[14:12], IF_ID[11:7]};
            else
                ID_EX<={IF_ID[19:15], IF_ID[24:20], 8'b0, IF_ID[63:32], ra, rb, immOut, IF_ID[30], IF_ID[14:12], IF_ID[11:7]};
            EX_MEM<={ID_EX[155], ID_EX[136:105] + 4, ID_EX[144], ID_EX[143], ID_EX[142], ID_EX[141], ID_EX[140], ID_EX[136:105] + ID_EX[40:9], Zero, aluOut, mux_forward_rb, ID_EX[4:0]};
            MEM_WB<={EX_MEM[139], EX_MEM[138:107], EX_MEM[106], EX_MEM[105], readData, EX_MEM[68:37], EX_MEM[4:0]};
        end
    end
    
    //Level 1
    Memory InstructionMemory(
        .clk(clk),
        .wen(1'b0),
        .ren(1'b1),
        .addr(PC),
        .din(1'b0),
        .dout(IR)
    );
     
     //Level 2 + 5
    Registers RegistersInst(
        .clk(clk),
        .res(res),
        .wen(MEM_WB[70]),
        .ra(IF_ID[19:15]),
        .rb(IF_ID[24:20]),
        .rc(MEM_WB[4:0]),
        .da(ra),
        .db(rb),
        .dc((MEM_WB[103])? MEM_WB[102:71] : (MEM_WB[69] == 0)? MEM_WB[36:5] : MEM_WB[68:37])
    );
    
    ImmGen IMM(
        .IR(IF_ID[31:0]),
        .imm(immOut)
    );
    
    HazardDetectionUnit HazardDetectionUnitInst(
        .rs1(IF_ID[19:15]),
        .rs2(IF_ID[24:20]),
        .rd(ID_EX[4:0]),
        .ID_EX_MemRead(ID_EX[141]),
        .IF_ID_Write(IF_ID_Write),
        .PCWrite(PCWrite),
        .ID_EX_Sel(ID_EX_Sel)
    );
    
    //Level 3 + Data Hazard Handle
    ALUcontrol AlucontrolInst(
        .IR(ID_EX[8:5]),
        .ALUOp(ID_EX[139:138]),
        .op(ALUSel)
    );
    ALU ALUInst(
        .A((forwardA == 2'b00) ? ID_EX[104:73] : (forwardA == 2'b10) ? EX_MEM[68:37] : (MEM_WB[69] == 0)? MEM_WB[36:5] : MEM_WB[68:37]),
        .B((ID_EX[137] == 0) ? mux_forward_rb : ID_EX[40:9]),
        .op(ALUSel),
        .out(aluOut),
        .zero(Zero)
    );
    ForwardingUnit ForwardingUnitInst(
        .rs1(ID_EX[154:150]),
        .rs2(ID_EX[149:145]),
        .EX_MEMrd(EX_MEM[4:0]),
        .MEM_WBrd(MEM_WB[4:0]),
        .EX_MEM_RegWrite(EX_MEM[106]),
        .MEM_WB_RegWrite(MEM_WB[70]),
        .forwardA(forwardA), 
        .forwardB(forwardB)
    );
    
    //Level 4
    Memory DataMemory(
        .clk(clk),
        .wen(EX_MEM[102]),
        .ren(EX_MEM[103]),
        .addr(EX_MEM[68:37]),
        .din(EX_MEM[36:5]),
        .dout(readData)
    );
    
    //Debugging wires to see the pipeline  
    //level 1
    wire [31:0] db_IF_PC = PC;
    wire [31:0] db_IF_IR = IR;
    
    //level 2
    wire [31:0] db_ID_PC = IF_ID[63:32];
    wire [4:0] db_ID_rs1 = IF_ID[19:15];
    wire [4:0] db_ID_rs2 = IF_ID[24:20];
    wire [4:0] db_ID_rd  = IF_ID[11:7];
    wire [31:0] db_ID_imm = immOut;
    
    //level 3
    wire [31:0] db_EX_ra = ID_EX[104:73];
    wire [31:0] db_EX_rb = ID_EX[72:41];
    wire [31:0] db_EX_ALU_A = (forwardA == 2'b00) ? ID_EX[104:73] : (forwardA == 2'b10) ? EX_MEM[68:37] : (MEM_WB[69] == 0)? MEM_WB[36:5] : MEM_WB[68:37];
    wire [31:0] db_EX_ALU_B = (ID_EX[137] == 0) ? mux_forward_rb : ID_EX[40:9];
    wire [3:0] db_EX_ALU_op = ALUSel;
    wire [31:0] db_EX_aluOut = aluOut;
    wire db_EX_zero = Zero;
    wire [4:0] db_EX_rd = ID_EX[4:0];
    wire db_EX_Jump = ID_EX[155];
    
    //level 4
    wire [31:0] db_MEM_readData = readData;
    wire db_MEM_MemWrite = EX_MEM[102];
    wire [4:0] db_MEM_rd = EX_MEM[4:0];
     wire db_MEM_Jump = EX_MEM[139];
    
    //level 5
    wire [31:0] db_WB_writeData = (MEM_WB[103])? MEM_WB[102:71] : (MEM_WB[69] == 0)? MEM_WB[36:5] : MEM_WB[68:37];
    wire db_WB_RegWrite = MEM_WB[70];
    wire [4:0] db_WB_r = MEM_WB[4:0];
    wire db_WB_Jump = MEM_WB[103];
endmodule

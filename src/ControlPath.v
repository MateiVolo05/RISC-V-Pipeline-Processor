module ControlPath(
    input[6:0] opcode,
    //WB
    output reg RegWrite, MemToReg,
    //M
    output reg Branch, MemRead, MemWrite, Jump,
    //EX
    output reg [1:0] ALUOp,
    output reg ALUSrc
    );
    
    always @(*)
        case(opcode)
            //R-type
            7'b0110011: {ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg, Jump} = 9'b10_0_0_0_0_1_0_0;
            //LW
            7'b0000011: {ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg, Jump} = 9'b00_1_0_1_0_1_1_0;
            //SW
            7'b0100011: {ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg, Jump} = 9'b00_1_0_0_1_0_0_0;
            //BEQ
            7'b1100011: {ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg, Jump} = 9'b01_0_1_0_0_0_0_0;
            //JAL
            7'b1101111: {ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg, Jump} = 9'b00_0_1_0_0_1_0_1;
            //JALR
            7'b1100111: {ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg, Jump} = 9'b00_1_1_0_0_1_0_1;
            //I-type
            7'b0010011: {ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg, Jump} = 9'b11_1_0_0_0_1_0_0;
            default : {ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg, Jump} = 9'b00_0_0_0_0_0_0_0;
        endcase
endmodule

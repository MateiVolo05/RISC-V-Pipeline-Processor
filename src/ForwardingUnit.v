module ForwardingUnit(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] EX_MEMrd,
    input [4:0] MEM_WBrd,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    output reg[1:0] forwardA, 
    output reg[1:0] forwardB
    );
    always @(*)
    begin
        if(EX_MEM_RegWrite && EX_MEMrd && EX_MEMrd == rs1)
            forwardA = 2'b10;
        else
            if(MEM_WB_RegWrite && MEM_WBrd && MEM_WBrd == rs1)
                forwardA = 2'b01;
            else
                forwardA = 2'b00;
         if(EX_MEM_RegWrite && EX_MEMrd && EX_MEMrd == rs2)
            forwardB = 2'b10;
        else
            if(MEM_WB_RegWrite && MEM_WBrd && MEM_WBrd == rs2)
                forwardB = 2'b01;
            else
                forwardB = 2'b00;
    end
endmodule

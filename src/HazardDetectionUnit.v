module HazardDetectionUnit(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input ID_EX_MemRead,
    output reg IF_ID_Write,
    output reg PCWrite,
    output reg ID_EX_Sel
    );
    always @(*)
    begin
        if(ID_EX_MemRead && (rd == rs1 || rd == rs2))
        begin
            IF_ID_Write = 0;
            PCWrite = 0;
            ID_EX_Sel = 1;
        end
        else
        begin
            IF_ID_Write = 1;
            PCWrite = 1;
            ID_EX_Sel = 0;
        end
    end
endmodule

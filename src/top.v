module top(
    input clk, res
);
//WB
wire RegWrite, MemToReg;
//M
wire Branch, MemRead, MemWrite, Jump;
//EX
wire[1:0] ALUOp;
wire ALUSrc;

wire[6:0] opcode;

DataPath DataPathInst(
    .clk(clk), 
    .res(res),
    .RegWrite(RegWrite), 
    .MemToReg(MemToReg),
    .Branch(Branch), 
    .MemRead(MemRead), 
    .MemWrite(MemWrite),
    .Jump(Jump),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .opcode(opcode)
);

ControlPath ControlPathInst(
    .RegWrite(RegWrite), 
    .MemToReg(MemToReg),
    .Branch(Branch), 
    .MemRead(MemRead), 
    .MemWrite(MemWrite),
    .Jump(Jump),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .opcode(opcode)
);

endmodule

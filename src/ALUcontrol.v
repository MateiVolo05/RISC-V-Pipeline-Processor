module ALUcontrol(
    input[3:0] IR,
    input[1:0] ALUOp,
    output reg[3:0] op
    );
    
    always@(*)
        casex({ALUOp, IR})
            6'b00_XXXX: op=4'b0000; //lw, sw, jalr, jal => add
            6'b01_XXXX: op=4'b0001; //beq => sub
            6'b10_0_000, 6'b11_X_000: op=4'b0000; //add
            6'b10_1_000: op=4'b0001; //sub
            6'b10_0_111, 6'b11_X_111: op=4'b0010; //and
            6'b10_0_110, 6'b11_X_110: op=4'b0011; //or
            6'b10_0_100, 6'b11_X_100: op=4'b0100; //xor
            6'b10_0_010: op=4'b0101; //set if less then
            default: op=4'b1111; //unknown operation => 0
        endcase
endmodule

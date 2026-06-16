module ImmGen(
    input[31:0] IR,
    output reg[31:0] imm
    );
    always@(*)
        case(IR[6:0])
            7'b0000011, 7'b0010011, 7'b1100111, 7'b1110011: imm={{20{IR[31]}},IR[31:20]}; //I-Type
            7'b0100011: imm={{20{IR[31]}}, IR[31:25], IR[11:7]}; //S-Type
            7'b0010111, 7'b0110111: imm={IR[31:12], 12'b0}; //U-Type
            7'b1101111: imm={{12{IR[31]}}, IR[19:12], IR[20], IR[30:21], 1'b0}; //J-Type
            7'b1100011: imm={{20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0}; //B-Type
            default: imm=32'b0;
        endcase
endmodule

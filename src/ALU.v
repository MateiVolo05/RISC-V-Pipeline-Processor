module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] op,
    output reg [31:0] out,
    output reg zero
    );
    
    always @(*)
    begin
        case(op)
            4'b0000: out=A+B;
            4'b0001: out=A-B;
            4'b0010: out=A&B;
            4'b0011: out=A|B;
            4'b0100: out=A^B;
            4'b0101: out=(A<B)?1:0;
            default: out=31'b0;
        endcase
        zero=(out==0)?1:0;
    end
endmodule
module Registers(
    input   clk,
    input   res,
    input   wen,
    input   [4:0]  ra,
    input   [4:0]  rb,
    input   [4:0]  rc,

    output  [31:0]       da,
    output  [31:0]       db,
    
    input   [31:0]       dc
);

    reg [31:0] mem [0:31];

    // read operation behavior
    assign da = (ra!= 5'b00000) ? mem[ra] : 32'b0;
    assign db = (rb!= 5'b00000) ? mem[rb] : 32'b0;
    
    // write operation behavior
    always @(posedge clk) begin
        if (res == 1'b1) begin
            mem[0] <= 0; mem[1] <= 0; mem[2] <= 0; mem[3] <= 0; mem[4] <= 0; mem[5] <= 0; mem[6] <= 0; mem[7] <= 0; 
            mem[8] <= 0; mem[9] <= 0; mem[10] <= 0; mem[11] <= 0; mem[12] <= 0; mem[13] <= 0; mem[14] <= 0; mem[15] <= 0;
            mem[16] <= 0; mem[17] <= 0; mem[18] <= 0; mem[19] <= 0; mem[20] <= 0; mem[21] <= 0; mem[22] <= 0; mem[23] <= 0;
            mem[24] <= 0; mem[25] <= 0; mem[26] <= 0; mem[27] <= 0; mem[28] <= 0; mem[29] <= 0; mem[30] <= 0; mem[31] <= 0;
        end else begin 
            if (wen == 1'b1 && rc != 5'b0) begin
                mem[rc] <= dc;
            end
        end
    end

endmodule


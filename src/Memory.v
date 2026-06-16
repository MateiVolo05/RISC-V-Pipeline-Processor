module Memory(
    input   clk,
    input   wen,
    input   ren,
    input   [$clog2(MEM_SIZE)-1:0]  addr,
    input   [31:0]       din,
    output  [31:0]       dout
    );

    parameter 	DATA_LENGTH  = 8;
    parameter 	MEM_SIZE     = 1024;
    
    reg [DATA_LENGTH-1:0] mem [0:MEM_SIZE-1];

    // read operation behavior
    assign dout = (ren==1)?{mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]}:0;
    
    // write operation behavior
    always @(posedge clk) begin
        if (wen == 1) begin
            mem[addr] <= din[7:0];
            mem[addr+1] <= din[15:8];
            mem[addr+2] <= din[23:16];
            mem[addr+3] <= din[31:24];
        end
    end
    
    // memory content initialization from file
    initial begin
        $readmemb( "memory_data.mem", mem, 0, MEM_SIZE-1);
    end
    
endmodule


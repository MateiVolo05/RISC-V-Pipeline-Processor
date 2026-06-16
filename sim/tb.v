module tb(
);

reg clk, res;

top DUT(
    .clk(clk),
    .res(res)
);

initial
begin
    #0 clk=1'b0;res=1'b1;
    forever #5 clk=~clk;
end
initial
begin
    #15 res=1'b0;
    #2000 $finish;
end    


endmodule

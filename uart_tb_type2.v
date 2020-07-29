module uart_tb1(   );
reg clk,rst,wr;
reg [7:0]data_in;
wire tx;
wire [7:0]frame;
reg tx_in;
uart_tx1 dut11(clk,rst,wr,data_in,tx);
uart_rx1 dut12(clk,rst,wr,tx_in,frame);
initial
begin
clk=0;
forever #1 clk=~clk;
end
initial
begin rst=0;
wr=0;data_in=8'b10111010;
#5 rst=1;
#50 data_in=8'b1111_1111;
#400 data_in=8'b0000_0000;
#1000 $finish;
end
always@(*)
tx_in=tx;
endmodule

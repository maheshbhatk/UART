module uart_tx_tb(  );
reg clk;
reg reset;
reg [7:0]data;
wire tx_active;
wire tx;
wire tx_done;
wire [7:0]byte;
wire data_valid;
wire done;
reg serial;
uart_tx dut1(clk,reset,data,tx_active,tx,tx_done);
uart_rx dut2(clk,reset,serial,data_valid,byte,done);
initial
begin
clk=0;
forever #1 clk=~clk;
end
initial begin
reset=0;data<=8'b01010101;
#4 reset=1;
#50 data<=8'b10010011;
#500 data<=8'b11111111;
#1000 $finish;
end
always@(posedge tx or negedge tx)
serial<=tx;

endmodule

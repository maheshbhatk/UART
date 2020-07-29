module uart_rx1(input clk,rst,wr,tx,
                output [7:0]frame   );
reg rx_start;
reg [2:0]count;
reg buad_rate;
reg [10:0]d_frame=11'b1111_1111_111;
assign frame=(d_frame[10]==0 && d_frame[0]==1)? d_frame[9:2]:frame;
always@(posedge clk)
  begin
    if(rst==0)
      rx_start=0;
    else if(wr==0)
      rx_start=1;
    else
      rx_start=0;
  end                
always@(posedge clk)
    begin
      if(rst==0)
        count<=3'b0;
      else if(rx_start==1)
        count<=count+1;
      else
        count<=3'b0;
      end
always@(posedge clk)
    begin
      if(rst==0)
        buad_rate<=1'b0;
      else if(count==7'b111)
        buad_rate<=1'b1;
      else
        buad_rate<=1'b0;
    end
always@(posedge clk)
begin
     if(rst==0 || (d_frame[10]==0 && d_frame[0]==1))
        d_frame<=11'b1111_1111_111;
     else if(buad_rate==1)
                begin 
                      d_frame<={d_frame[9:0],tx};  end
end                      
endmodule

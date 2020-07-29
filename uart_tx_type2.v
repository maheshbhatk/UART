module uart_tx1(input clk, rst, wr, 
               input [7:0]Data_in, 
               output reg TX);
               
      reg tx_start;
      reg [2:0]count;
      reg buad_rate;
      reg [10:0] D_frame;
      
  
  always@(posedge clk)
  begin
    if(rst==0)
      tx_start=0;
    else if(wr==0)
      tx_start=1;
    else
      tx_start=0;
    end
    
    
    always@(posedge clk)
    begin
      if(rst==0)
        count<=3'b0;
      else if(tx_start==1)
        count<=count+1;
      else
        count<=3'b0;
      end
      
      
    always@(posedge clk)
    begin
      if(rst==0)
        buad_rate<=1'b0;
      else if(count==3'b111)
        buad_rate<=1'b1;
      else
        buad_rate<=1'b0;
    end
        
    always@(posedge clk)
    begin
      if(rst==0)
        D_frame<=11'b0;
      else if((D_frame==11'b0)&&(wr==0))
        D_frame<={1'b0, Data_in,^Data_in, 1'b1};
    end


  always@(negedge clk)
  begin
       if(rst==0)
            TX=1'b0;
       else  if(buad_rate==1)
                begin
             TX<=D_frame[10];
             D_frame<=D_frame<<1;
                 end
            else  
               begin
                 TX<=TX;
               end
end
endmodule 

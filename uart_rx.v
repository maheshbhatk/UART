module uart_rx(
    input clk,
    input reset,
    input serial,
    output reg data_valid,
    output [7:0]byte_out,
    output reg done
    );
   parameter s_idle=3'b000,
             s_start=3'b001,
             s_data=3'b011,
             s_parity=3'b010,
             s_stop=3'b110;
parameter countingtime=10;      //10,000,000 divide by 115200=87.....currently kept 10;
reg [10:0]count;     //used to set baud rate...9600bits per second
reg [2:0]state=0; 
reg data_in;
reg [2:0]bits;
reg parity_check;
reg [7:0]byte;
assign byte_out=byte;
always@(posedge clk)
case(state)
    s_idle: begin   
            count<=0;  
            bits<=0;
            data_in<=0;
            done<=0;
            data_valid<=0;
            if(reset==0)
                state<=s_idle;
            else
                state<=s_start;
            end
     s_start:begin
            if(count==((countingtime+2)/2))
                if(serial==0)
                    begin   count<=0;
                            state<=s_data;  end
                else
                    state<=s_idle;
             else begin
                    count<=count+1'b1;
                    state<=s_start;
                  end
             end
    s_data:begin
            if(count<(countingtime))
                begin   count<=count+1'b1;
                state<=s_data;  end
            else  begin
                count<=0;
                byte[bits]<=serial;
                if(bits<7)
                    begin
                    bits<=bits+1'b1;
                    state<=s_data;  end
                else begin
                        bits<=0;
                        state<= s_parity;  end
             end  end
    s_parity: begin
              if(count<(countingtime))
                begin   count<=count+1'b1;
                state<=s_parity;  end
              else  begin  
                    data_in=serial;      
                    parity_check= ^byte;       
                    if(parity_check==data_in)
                          begin  data_valid<=1;state<=s_stop; count<=0; end
                    else  begin  data_valid<=0;state<=s_idle; end
                  end
            end
     s_stop:begin
              if(count<(countingtime))
                begin   count<=count+1'b1;
                        state<=s_stop;  end  
              else 
                    begin
                        data_valid<=0;
                        done<=1;
                        state<=s_idle;            
                    end
              end
      default: begin state<=s_idle; end
endcase                
endmodule

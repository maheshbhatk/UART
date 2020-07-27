module uart_tx 
(   input clk,
    input reset,
    input [7:0]data,
    output reg tx_active,   //data is being received
    output reg tx,          //serial transmission
    output reg tx_done      //serial tx done
    );
parameter s_idle=3'b000,
          s_start=3'b001,
          s_data=3'b011,
          s_parity=3'b010,
          s_stop=3'b110;
parameter countingtime=10;      //10,000,000 divide by 115200=87.....currently kept 10;
reg [10:0]count;     //used to set baud rate...9600bits per second
reg [2:0]state=0;
reg [7:0]tx_data;
reg [2:0]bits;
always@(posedge clk)
case(state)
    s_idle:begin
            tx<=1;
            tx_done<=0;
            tx_active<=0;
            bits<=0;
            if(reset==0)
                state<=s_idle;
            else begin
                tx_active<=1;
                tx_data<=data;  //transfer data
                state<=s_start;
                count<=0;
                 end
            end
    s_start:begin
             tx_active<=0;
             tx<=0;             //start bit
             if(count<countingtime)      
                begin   count=count+1'b1;
                        state<=s_start;     end
             else begin
                    count<=0;
                    state<=s_data;     end
            end
    s_data:begin
            tx<=tx_data[bits];              //data from LSB
            if(count<countingtime) begin
                count<=count+1'b1;
                state<=s_data;   end
            else  begin
            count<=0;
            if(bits<7)  begin
                bits<=bits+1'b1;
                state<=s_data;  end
            else  begin
                bits<=0;
                state<=s_parity; end  end
            end
    s_parity: begin
                tx<= ^tx_data;             // parity bit
                if(count<countingtime)
                    begin   count<=count+1'b1;
                    state<=s_parity;  end
                else
                begin count<=0;
                      state<=s_stop;   end
              end
     s_stop: begin
                tx<=1;              //stop bit
                if(count<countingtime)
                begin  count<=count+1'b1;
                    state<=s_stop;  end 
                else                 
                begin count<=0;
                      tx_done<=1;
                      state<=s_idle;   end
              end 
     default: begin
                  tx<=1;
                  state<=s_idle;
              end         
             
endcase
endmodule

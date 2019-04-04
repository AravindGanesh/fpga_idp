//Program for blinking LED
module example(input wire clk,output reg A);

reg[26:0] delay;

always@(posedge clk) begin
delay = delay+1;
if(delay==27'b101111101011110000100000000)
begin
delay=27'b0;
A=!A;
end
end
endmodule

// refrence: https://gist.github.com/gibiansky/4247200
module fibo (
  input clk;
  input rst;
  input [5:0]n;
  output ready;
  output [31:0] out;
);
  reg [31:0] prev;
  reg [31:0] current;
  reg [5:0] counter;
  always@(posedge clk)begin
    if(reset)begin
      prev<=32'b0;
      current <=32'b1;
      counter <= 6'b0;
    end else begin
      counter <= counter +1;

      current <= current + prev;
      prev <= current;

      ready = counter==n;
    end
  end
  assign out = current;
endmodule

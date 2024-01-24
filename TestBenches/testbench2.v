//https://hdlbits.01xz.net/wiki/Tb/tb2
// put clk (periodic signal) in a seperate initial begin.
module top_module();
	reg clk;
    reg in;
    reg [2:0]s;
    reg out;
    initial begin
        in = 0;
        s = 3'd2;
        #10 s = 3'd6;
        #10 
        	s = 3'd2;
        	in = ~in;
        #10 
        	s = 3'd7;
        	in = ~in;
        #10 
        	in = ~in;
        	s = 3'd0;
        #30 in = ~in;
    end
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    q7 ins_q7 (.clk(clk),.in(in),.s(s),.out(out));
endmodule

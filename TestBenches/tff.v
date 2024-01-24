//https://hdlbits.01xz.net/wiki/Tb/tff
module top_module ();
    reg clk;
    reg reset;
    reg t;
    reg out;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        reset = 0;
        t = 0;
        #15 reset = 1'd1;
        #5 reset = 1'd0;
        #15 t = 1;
    end
    tff tff_ins (clk,reset,t,out);

endmodule

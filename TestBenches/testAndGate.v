// https://hdlbits.01xz.net/wiki/Tb/and
// debug note: can't assign out.
module top_module();
    reg [1:0]in;
    reg out;
    initial begin
        in [1:0] = 2'b0;
        #10 in[0] = ~in[0];
        #10 
        in[0] = ~in[0];
        in[1] = ~in[1];
        #10 in[0] = ~in[0];
    end
    andgate andgate_ins (.in(in),.out(out));
endmodule

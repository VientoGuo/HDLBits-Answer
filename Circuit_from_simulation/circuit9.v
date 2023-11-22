// https://hdlbits.01xz.net/wiki/Sim/circuit9
module top_module (
    input clk,
    input a,
    output [3:0] q );
    always@(posedge clk)begin
        if(a) q = 4;
        else q=q+1;
        if(q>6) q=0;
    end

endmodule

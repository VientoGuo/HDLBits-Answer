// https://hdlbits.01xz.net/wiki/Shift4
module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q); 
    always@(posedge clk or posedge areset)begin
        if(areset) q <= 0;
        else if (ena)begin
            if(load) q <= data;
            else q <= {1'b0,q[3:1]};
        end else if(load) begin
            q <= data;
        end else q <= q; 
    end
endmodule

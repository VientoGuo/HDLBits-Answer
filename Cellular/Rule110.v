// https://hdlbits.01xz.net/wiki/Rule110
// code: look at the table, just take it as truth table of a circuit with left = {1'b0,q[511:1]}
// right = {q[510:0],1'b0}, middle = q[511:0];
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 
    always@(posedge clk)begin
        if (load) q<=data;
        else begin
            q<=({1'b0,q[511:1]}&(q[511:0]^{q[510:0],1'b0}))|(~{1'b0,q[511:1]}&(q[511:0]|{q[510:0],1'b0}));
        end
    end
endmodule

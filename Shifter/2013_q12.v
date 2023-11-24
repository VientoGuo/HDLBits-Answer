// https://hdlbits.01xz.net/wiki/Exams/ece241_2013_q12
// code: {A,B,C} could be the index.
module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z ); 
    reg [7:0] Q;
    always@(posedge clk) if (enable) Q[0] <= S;
    always@(posedge clk) if (enable) Q[1]<=Q[0];
    always@(posedge clk) if (enable) Q[2]<=Q[1];
    always@(posedge clk) if (enable) Q[3]<=Q[2];
    always@(posedge clk) if (enable) Q[4]<=Q[3];
    always@(posedge clk) if (enable) Q[5]<=Q[4];
    always@(posedge clk) if (enable) Q[6]<=Q[5];
    always@(posedge clk) if (enable) Q[7]<=Q[6];
    assign Z = Q[{A,B,C}];
endmodule

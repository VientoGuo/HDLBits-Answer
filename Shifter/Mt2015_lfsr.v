module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q
    wire Q0,Q1,Q2;
    dff d1 (.clk(KEY[0]),.D(KEY[1]?SW[0]:Q2),.Q(Q0));
    dff d2 (.clk(KEY[0]),.D(KEY[1]?SW[1]:Q0),.Q(Q1));
    dff d3 (.clk(KEY[0]),.D(KEY[1]?SW[2]:(Q1^Q2)),.Q(Q2));
    assign LEDR = {Q2,Q1,Q0};
    

endmodule
module dff(
input clk,
input D,
output Q
);
    always@(posedge clk)begin
        Q<=D;
    end
endmodule

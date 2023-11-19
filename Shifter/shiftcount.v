// https://hdlbits.01xz.net/wiki/Exams/review2015_shiftcount
// debug code: 1. FSM is not necessary for simple state switching. 2. operator << can't used to switch in a value, should use{} to saaign.
module top_module (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);
    reg [3:0] shift_data;
    always@(posedge clk)begin
        if(shift_ena) shift_data = {shift_data[2:0],data};
        else if(count_ena) shift_data = shift_data -1;
        else shift_data[3:0] = shift_data[3:0];
    end
    assign q = shift_data[3:0] ;
endmodule

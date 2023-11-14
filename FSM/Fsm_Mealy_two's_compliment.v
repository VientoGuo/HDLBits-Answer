// https://hdlbits.01xz.net/wiki/Exams/ece241_2014_q5b
// debug code: two state: output the same state, output compliment state.
module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    parameter p0 = 1'b0, p1=1'b1;
    reg state, next_state;
    always@(posedge clk or posedge areset)begin
        if(areset)state = p0;
        else state = next_state;
    end
    always@(*)begin
        case(state)
            p0: next_state = x?p1:p0;
            p1: next_state = p1;
        endcase
    end
    always@(*)begin
        case(state)
            p0: z = x;
            p1: z = ~x;
        endcase
    end   

endmodule

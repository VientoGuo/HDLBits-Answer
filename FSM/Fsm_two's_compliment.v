//https://hdlbits.01xz.net/wiki/Exams/ece241_2014_q5a
//debug note: input from the lowest significant bit, the numbers before 1 remain the same, the numbers after 1 change to it's compliment.
module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    parameter q0=2'b00,q1=2'b01,q2=2'b10;
    reg [2:0]state,next_state;
    always@(posedge clk or posedge areset)begin
        if(areset)state = q0;
        else state = next_state;
    end
    always@(*)begin
        case(state)
            q0:next_state = x?q1:q0;
            q1:next_state = x?q2:q1;
            q2:next_state = x?q2:q1;
        endcase
    end
    always@(*)begin
        z = state==q1;
    end

endmodule

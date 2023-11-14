//https://hdlbits.01xz.net/wiki/Exams/ece241_2013_q8
//debug note: we can only have 3 state, for the success state it is decided by both state and input x.
module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    parameter S0=2'b00,S1=2'b01,S2=2'b10;
    reg [1:0] state,next_state;
    always@(posedge clk or negedge aresetn)begin
        if(!aresetn) state = S0;
        else state = next_state;
    end
    always@(*)begin
        case(state)
            S0:next_state = x?S1:S0;
            S1:next_state = x?S1:S2;
            S2:next_state = x?S1:S0;
        endcase
    end
    always@(*)begin
        z=(state==S2)&(x);
    end

endmodule

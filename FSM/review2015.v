//https://hdlbits.01xz.net/wiki/Exams/review2015_fsm

module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    parameter IDLE = 4'b0000, BIT1=4'b0001, BIT2=4'b0010, BIT3=4'b0011, SET_SHIFT1=4'b0100,SET_SHIFT2=4'b0101;
    parameter SET_SHIFT3 = 4'b0110,SET_SHIFT4=4'b0111,WAIT_COUNTER=4'b1000,ASSERT_DONE=4'b1001;
    reg [3:0]state, next_state;
    
    always@(posedge clk)begin
        if(reset) state = IDLE;
        else state = next_state;
    end
    
    always@(*)begin
        case(state)
            IDLE:begin
                if(data) next_state = BIT1;
                else next_state = IDLE;
            end
            BIT1:begin
                if(data) next_state = BIT2;
                else next_state = IDLE;
            end
            BIT2:begin
                if(!data) next_state = BIT3;
                else next_state = BIT2;
            end
            BIT3:begin
                if(data) next_state = SET_SHIFT1;
                else next_state = IDLE;
            end
            SET_SHIFT1:next_state = SET_SHIFT2;
            SET_SHIFT2:next_state = SET_SHIFT3;
            SET_SHIFT3:next_state = SET_SHIFT4;
            SET_SHIFT4: next_state = WAIT_COUNTER;
            WAIT_COUNTER:begin
                if(done_counting) next_state = ASSERT_DONE;
                else next_state = WAIT_COUNTER;
            end
            ASSERT_DONE:begin
                if(ack) next_state = IDLE;
                else next_state = ASSERT_DONE;
            end
        endcase   
    end
    
    always@(*)begin
        shift_ena = (state ==SET_SHIFT1)||(state ==SET_SHIFT2)||(state ==SET_SHIFT3)||(state ==SET_SHIFT4);
        counting = state == WAIT_COUNTER;
        done = state == ASSERT_DONE;
    end
endmodule

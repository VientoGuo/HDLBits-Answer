// https://hdlbits.01xz.net/wiki/Fsm_hdlc
// debug note: there is no IDLE, the program start from BIT1 by default.
module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    parameter START=4'b0001;
    parameter BIT1=4'b0010;
    parameter BIT2=4'b0011;
    parameter BIT3=4'b0100;
    parameter BIT4=4'b0101;
    parameter BIT5=4'b0110;
    parameter DISCARD=4'b0111;
    parameter BIT6=4'b1000;
    parameter FLAG=4'b1001;
    parameter ERROR=4'b1010;
    reg[3:0] state, next_state;
    
    always@(posedge clk)begin
        if(reset)state = START;
        else state = next_state;
    end
    
    always@(*)begin
        case(state)
            START:begin
                if(in)next_state = BIT1;
                else next_state = START;
            end
            BIT1:begin
                if(in)next_state = BIT2;
                else next_state = START;
            end
            BIT2:begin
                if(in)next_state = BIT3;
                else next_state = START;
            end
            BIT3:begin
                if(in)next_state = BIT4;
                else next_state = START;
            end
            BIT4:begin
                if(in)next_state = BIT5;
                else next_state = START;
            end
            BIT5:begin
                if(in)next_state = BIT6;
                else next_state = DISCARD;
            end
            DISCARD:begin
                if(~in)next_state = START;
                else next_state = BIT1;
                end
            BIT6:begin
                if(in)next_state = ERROR;
                else next_state = FLAG;
            end
            FLAG:begin
                if(~in)next_state = START;
                else next_state = BIT1;
            end
            ERROR:begin
                if(in)next_state = ERROR;
                else next_state = START;
            end
        endcase
    end

    always@(*)begin
        disc = state == DISCARD;
        flag = state == FLAG;
        err = state == ERROR;
    end
endmodule

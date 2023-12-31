//https://hdlbits.01xz.net/wiki/Fsm_serialdata
// debug code: bit1 -> outdatd[0];
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial
    parameter IDLE = 4'b0000;
    parameter START = 4'b0001;
    parameter BIT1 = 4'b0010;
    parameter BIT2 = 4'b0011;
    parameter BIT3 = 4'b0100;
    parameter BIT4 = 4'b0101;
    parameter BIT5 = 4'b0110;
    parameter BIT6 = 4'b0111;
    parameter BIT7 = 4'b1000;
    parameter BIT8 = 4'b1001;
    parameter STOP = 4'b1010;
    parameter WAIT = 4'b1011;
    reg[3:0] state, next_state;
    reg[7:0] in_byte;
    always@(posedge clk)begin
        if(reset)state = IDLE;
        else state = next_state;
    end
    
    always@(*)begin
        case(state)
            IDLE:begin
                if(in)next_state = IDLE;
                else next_state = START;
            end
            START:next_state = BIT1;
            BIT1:next_state = BIT2;
            BIT2:next_state = BIT3;
            BIT3:next_state = BIT4;
            BIT4:next_state = BIT5;
            BIT5:next_state = BIT6;
            BIT6:next_state = BIT7;
            BIT7:next_state = BIT8;
            BIT8:begin
                if(in)next_state = STOP;
                else next_state = WAIT;
            end
            WAIT:begin
                if(in)next_state = IDLE;
                else next_state = WAIT;
            end
            STOP:begin
                if(in)next_state = IDLE;
                else next_state = START;
            end
        endcase
    end
    always@(*)begin
        done = state==STOP;
        if(done)out_byte=in_byte;
        else out_byte = 0;
    end
    // New: Datapath to latch input bits.
    always@(posedge clk)begin
        case(next_state)
            BIT1:in_byte[0]=in;
            BIT2:in_byte[1]=in;
            BIT3:in_byte[2]=in;
            BIT4:in_byte[3]=in;
            BIT5:in_byte[4]=in;
            BIT6:in_byte[5]=in;
            BIT7:in_byte[6]=in;
            BIT8:in_byte[7]=in;
        endcase
    end

endmodule

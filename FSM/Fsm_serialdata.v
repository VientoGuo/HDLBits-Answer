//https://hdlbits.01xz.net/wiki/Fsm_serialdata
// debug code:
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //
	parameter IDLE = 4'b0000;
    parameter START = 4'b0001;
    parameter BYTE1 = 4'b0010;
    parameter BYTE2 = 4'b0011;
    parameter BYTE3 = 4'b0100;
    parameter BYTE4 = 4'b0101;
    parameter BYTE5 = 4'b0110;
    parameter BYTE6 = 4'b0111;
    parameter BYTE7 = 4'b1000;
    parameter BYTE8 = 4'b1001;
    parameter STOP = 4'b1010;
    parameter WAIT = 4'b1011;
    reg [3:0]state,next_state;
    reg [7:0]in_byte;
    // Use FSM from Fsm_serial
    always@(posedge clk)begin
        if(reset) state = IDLE;
        else state = next_state;
    end
    always@(*)begin
        case(state)
            IDLE:begin
                if(!in)next_state = START;
                else next_state = IDLE;
            end
            START:next_state = BYTE1;
            BYTE1:next_state = BYTE2;
            BYTE2:next_state = BYTE3;
            BYTE3:next_state = BYTE4;
            BYTE4:next_state = BYTE5;
            BYTE5:next_state = BYTE6;
            BYTE6:next_state = BYTE7;
            BYTE7:next_state = BYTE8;
            BYTE8:begin
                if(in)next_state = STOP;
                else next_state = WAIT;
            end
            WAIT:begin
                if(in)next_state = IDLE;
                else next_state = WAIT;
            end
            STOP:begin
                if(!in)next_state = START;
                else next_state = IDLE;
            end
        endcase
    end
    always@(*)begin
        if(next_state == BYTE1)in_byte[0] = in;
        if(next_state == BYTE2)in_byte[1] = in;
        if(next_state == BYTE3)in_byte[2] = in;
        if(next_state == BYTE4)in_byte[3] = in;
        if(next_state == BYTE5)in_byte[4] = in;
        if(next_state == BYTE6)in_byte[5] = in;
        if(next_state == BYTE7)in_byte[6] = in;
        if(next_state == BYTE8)in_byte[7] = in;
    end
    always@(*)begin
        done = state==STOP;
        if(done)out_byte = in_byte[7:0];
    end
    // New: Datapath to latch input bits.

endmodule


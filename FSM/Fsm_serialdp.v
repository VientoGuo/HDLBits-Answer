//https://hdlbits.01xz.net/wiki/Fsm_serialdp
//debug code: don only in STOP stage, odd shoube be 0(STOP bit included which is 1)
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
    parameter PARITY = 4'b1100;
    reg[3:0] state, next_state;
    reg[7:0] in_byte;
    reg odd;

    parity p (.clk(clk),.reset(reset||(next_state==START)),.in(in),.odd(odd));
    
    always@(posedge clk)begin
        if(reset)begin
            state = IDLE; 
        end
        else begin
            state = next_state;
        end
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
            BIT8:next_state = PARITY;
            PARITY:begin
                if(in)next_state = STOP;
                else next_state = WAIT;
            end
            WAIT:begin
                if(in)next_state = IDLE;
                else next_state = WAIT;
            end
            STOP:begin
                if(in)next_state = IDLE ;
                else next_state = START;
            end
            
        endcase
    end
    always@(*)begin
        done = (state==STOP)&&(~odd);
        if(done)begin
            out_byte=in_byte;
        end
        else out_byte = 0;
    end
    // New: Datapath to latch input bits.
    always@(*)begin
        if (next_state == BIT1) in_byte[0]=in;
        if (next_state == BIT2) in_byte[1]=in;
        if (next_state == BIT3) in_byte[2]=in;
        if (next_state == BIT4) in_byte[3]=in;
        if (next_state == BIT5) in_byte[4]=in;
        if (next_state == BIT6) in_byte[5]=in;
        if (next_state == BIT7) in_byte[6]=in;
        if (next_state == BIT8) in_byte[7]=in;
    end
    // Modify FSM and datapath from Fsm_serialdata

    // New: Add parity checking.

endmodule

module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    parameter IDLE=4'b0000;
    parameter START=4'b0001;
    parameter BYTE1=4'b0010;
    parameter BYTE2=4'b0011;
    parameter BYTE3=4'b0100;
    parameter BYTE4=4'b0101;
    parameter BYTE5=4'b0110;
    parameter DISCARD=4'b0111;
    parameter BYTE6=4'b1000;
    parameter FLAG=4'b1001;
    parameter ERROR=4'b1010;
    reg[3:0] state, next_state;
    
    always@(posedge clk)begin
        if(reset)state = START;
        else state = next_state;
    end
    
    always@(*)begin
        case(state)
            IDLE:begin
                if(!in)next_state = START;
                else next_state = IDLE;
            end
            START:begin
                if(in)next_state = BYTE1;
                else next_state = START;
            end
            BYTE1:begin
                if(in)next_state = BYTE2;
                else next_state = START;
            end
            BYTE2:begin
                if(in)next_state = BYTE3;
                else next_state = START;
            end
            BYTE3:begin
                if(in)next_state = BYTE4;
                else next_state = START;
            end
            BYTE4:begin
                if(in)next_state = BYTE5;
                else next_state = START;
            end
            BYTE5:begin
                if(in)next_state = BYTE6;
                else next_state = DISCARD;
            end
            DISCARD:begin
                if(~in)next_state = START;
                else next_state = BYTE1;
                end
            BYTE6:begin
                if(in)next_state = ERROR;
                else next_state = FLAG;
            end
            FLAG:begin
                if(~in)next_state = START;
                else next_state = BYTE1;
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

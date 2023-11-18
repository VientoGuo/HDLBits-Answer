//https://hdlbits.01xz.net/wiki/Exams/review2015_fancytimer
// debug note:
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    
    parameter IDLE = 4'b0000, BIT1=4'b0001, BIT2=4'b0010, BIT3=4'b0011;
    parameter DELAY4=4'b0100, DELAY3 = 4'b0101,DELAY2=4'b0110;
    parameter DELAY1=4'b0111,COUNT=4'b1000,ASSERT_DONE=4'b1001;
    reg [3:0]state, next_state;
    reg [14:0] cnt;
    reg [3:0] count_num;
    reg [3:0] delay;
    reg count_done;
    always@(posedge clk)begin
        if(reset)begin
            state = IDLE;
        end
        else state = next_state;
    end
    always@(*)begin
        case(state)
            IDLE: begin
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
                if(data) next_state = DELAY4;
                else next_state = IDLE;
            end
            DELAY4:begin
                next_state = DELAY3;
                delay[3] = data;
            end
            DELAY3: begin
                next_state = DELAY2;
                delay[2] = data;
            end
            DELAY2: begin
                next_state = DELAY1;
                delay[1] = data;
            end
            DELAY1: begin
                next_state = COUNT;
                delay[0] = data;
            end
            COUNT: begin
                if(count_done) next_state = ASSERT_DONE;
                else next_state = COUNT;
            end
            ASSERT_DONE:begin
                if(ack) next_state = IDLE;
                else next_state = ASSERT_DONE;
            end
        endcase
    end
    always@(posedge clk)begin
        if(state == DELAY1) begin
            cnt = 0;
            count_num = 0;
        end
        if(state == COUNT) cnt = cnt+1;
        if((cnt%1000 == 0)&(cnt!=0)) count_num = count_num +1;
    end
    always@(*)begin
        done = state == ASSERT_DONE;
        counting = state == COUNT;
        count = (state == COUNT)?delay- count_num:0;
    end
    assign count_done = cnt== (delay +1)*1000-1;
endmodule

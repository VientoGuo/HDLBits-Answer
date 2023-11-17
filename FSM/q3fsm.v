//https://hdlbits.01xz.net/wiki/Exams/2014_q3fsm
// note: output z switch at CLK1, but at CLK1 cnt has to be reset, so I used prev_cnt to record the previous state(CLK3) cnt;
module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    parameter IDLE=3'b000, CLK1=3'b010,CLK2=3'b011, CLK3=3'b100, SET=3'b101;
    reg [2:0] state, next_state;
    reg [2:0] cnt,cnt_prev;
    always@(posedge clk)begin
        if(reset)begin
            state = 0;
        end else begin
            state = next_state;
            cnt_prev = cnt;
        end
    end
    always@(*)begin
        case(state)
            IDLE: begin
                if(s)next_state = CLK1;
                else next_state = IDLE;
            end
            CLK1: begin
                next_state = CLK2;

            end
            CLK2: begin
                next_state = CLK3;

            end
            CLK3:begin
                next_state = CLK1;
            end
        endcase
    end
    always@(*)begin
        case (state)
            IDLE: begin
                cnt = 0;
                z = 0;
            end
            CLK1:begin
                cnt = 0;
                if(w) cnt = cnt+1;
                if(cnt_prev ==2) z = 1;
                else z=0;
            end
            CLK2:if(w) cnt = cnt +1;
            CLK3: if(w) cnt = cnt +1;
        endcase
    end

endmodule

//https://hdlbits.01xz.net/wiki/Exams/2013_q2bfsm
// debug code: 1. SET_G also counted as a waiting y stage. 2. y is required to stay 1 for 2 clock period.
//             3. remember to check output assignment. 4. don't assign output at the state assignment section, assign them at the end.
module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
    parameter A = 1,SET_F=2,X_0=3,X_1=4,X_2=5,SET_G=6,WAIT_Y_1=7,WAIT_Y_2=8,SET_G_1=9,SET_G_0=10;
    reg [3:0] state,next_state;
    reg flag;
    always@(posedge clk)begin
        if(!resetn) state <= A;
        else state<= next_state;
    end
    always@(*)begin
        case(state)
            A:next_state = SET_F;
            SET_F: next_state = X_0;
            X_0:begin
                if(x) next_state = X_1;
                else next_state = X_0;
            end
            X_1:begin
                if(!x) next_state = X_2;
                else next_state = X_1;
            end
            X_2:begin
                if(x) next_state = SET_G;
                else next_state = X_0;
            end
            SET_G:next_state = WAIT_Y_1;
            WAIT_Y_1: begin
                if (flag) next_state = SET_G_1;
                else next_state = SET_G_0;
            end
            SET_G_1: next_state = SET_G_1;
            SET_G_0: next_state = SET_G_0;
        endcase
    end
    always@(*)begin
        if(next_state == SET_G) flag = 0;
        if((state == WAIT_Y_1)|(state == SET_G))begin
            if(y) flag = 1; else flag = 0;
        end
    end
    assign g = (state==SET_G_1)|(state == SET_G)|(state == WAIT_Y_1);
    assign f = (state == SET_F);
endmodule

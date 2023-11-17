// https://hdlbits.01xz.net/wiki/Exams/review2015_fsmshift
module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    parameter IDLE=3'b000, CLK1='b001, CLK2=3'b010, CLK3=3'b011, CLK4=3'b100, ZERO = 3'b101;
    reg [2:0] state, next_state;
    always@(posedge clk)begin
        if(reset) state=IDLE;
        else state = next_state;
    end
    always@(*)begin
        case(state)
            IDLE:next_state = CLK1;
            CLK1:next_state = CLK2;
            CLK2:next_state = CLK3;
            CLK3:next_state = CLK4;
            CLK4:next_state = ZERO;
            ZERO:next_state = ZERO;
       
        endcase  
    end
    assign shift_ena = (state == CLK1)||(state == CLK2)||(state == CLK3)||(state == CLK4)||(state == IDLE);


endmodule

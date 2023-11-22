//https://hdlbits.01xz.net/wiki/Exams/review2015_fsmseq
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
    parameter IDLE=3'b000,BIT1=3'b001,BIT2=3'b010,BIT3=3'b011,FINISH=3'b100;
    reg[2:0] state, next_state;
    
    always@(posedge clk)begin
        if (reset) state<=IDLE;
        else state<=next_state;
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
                if(data) next_state = FINISH;
                else next_state = IDLE;
            end
            FINISH: next_state = FINISH;
        endcase
    end
	assign start_shifting = state == FINISH;
endmodule

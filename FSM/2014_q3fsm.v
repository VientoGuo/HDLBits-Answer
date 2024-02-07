// https://hdlbits.01xz.net/wiki/Exams/2014_q3fsm
// debug code: 1. can't assign output with@(*), should use @(posedge clk)
//             2. notice that should add reset for output section
//             3. notice that my FSM B stage starts at the period after s became 1, which is 1 clock period later than the plot on that webset. 

module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    parameter A=1,B=2,CLK1=3,CLK2=4;
    reg[2:0] state, next_state;
    reg[1:0]counter;
    always@(posedge clk)begin
        if(reset) begin
            state = A;
        end
        else state =next_state;
    end
    always@(*)begin
        case(state)
            A: begin
                if(s)next_state = B;
                else next_state = A;
            end
            B:next_state = CLK1;
            CLK1:next_state = CLK2;
            CLK2:next_state = B;
        endcase
    end
    always@(posedge clk)begin
        if(reset)z=0;
        else begin
        case(state)
            A: begin
                counter = 0;
                z=0;
            end
            B:begin
                counter = 0;
                if(w)counter = counter+1;
                z=0;
            end
            CLK1:begin
                if(w)counter = counter+1;
                z=0;
            end
            CLK2: begin
                if(w)counter = counter+1;
                if(counter ==2) z=1;
                else z=0;
            end
            endcase
        end
    end
endmodule


// solution 2
// debug code: when the current state output depends on previous output, should use @(posedge clk) to write output
module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    parameter A=0,B=1,BIT2=2,BIT3=3;
    reg [1:0]count_ones;
    reg [1:0] state, next_state;
    always@(posedge clk)begin
        if(reset) state = A;
        else state = next_state;
    end
    always@(*)begin
        case(state)
            A: next_state = s?B:A;
            B: next_state = BIT2;
            BIT2:next_state = BIT3;
            BIT3:next_state = B;
        endcase
    end
    always@(posedge clk)begin
        if(reset) begin
            z= 0;
            count_ones = 0;
        end else begin
        if((state== BIT2)|(state==BIT3)) count_ones += w;
        z = (state==BIT3)&(count_ones==2);
        if(state == B) count_ones =w?1:0;
        end
    end
    

endmodule


// https://hdlbits.01xz.net/wiki/Exams/2013_q2afsm
module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 
    parameter A=2'b00,B=2'b01,C=2'b10,D=2'b11;
    reg [1:0] state, next_state;
    
    always@(posedge clk)begin
        if(!resetn) state <= A;
        else state <=next_state;
    end
    always@(*)begin
        case(state)
            A:begin
                if(r[1]) next_state = B;
                else if(r[2]) next_state = C;
                else if (r[3]) next_state = D;
                else next_state = A;
            end
            B:begin
                if(r[1]) next_state = B;
                else next_state = A;
            end
            C:begin
                if(r[2]) next_state = C;
                else next_state = A;
            end
            D:begin
                if(r[3]) next_state = D;
                else next_state = A;
            end
        endcase
    end
    assign g[1] = stste==B;
    assign g[2] = stste==C;
    assign g[3] = stste==D;
    
endmodule

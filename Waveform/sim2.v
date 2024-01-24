//https://hdlbits.01xz.net/wiki/Sim/circuit2
// debug code: 
// multiple inputs (even) 
// XOR: output will be 1 when there are odd number of inputs are 1.
// XNOR: output will be 1 when there are even number of inputs are 1.
// multiple inputs (odd)
// XOR: output will be 1 when there are even number of inputs are 1.
// XNOR: output will be 1 when there are odd number of inputs are 1.
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = ~(a^b^c^d); // Fix me

endmodule

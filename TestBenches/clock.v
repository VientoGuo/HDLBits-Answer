// https://hdlbits.01xz.net/wiki/Tb/clock
// debug note: period is 10 ps, change clk every 5 ps.
module top_module ( );
  reg clk;
  initial begin
      clk = 0;
      forever #5ps clk = ~clk;
  end
    dut ins_dut (.clk(clk));
endmodule

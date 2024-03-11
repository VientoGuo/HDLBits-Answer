This is just a simple shared plaintext pad, with no execution capabilities.

When you know what language you'd like to use for your interview,
simply choose it from the dots menu on the tab, or add a new language
tab using the Languages button on the left.

You can also change the default language your pads are created with
in your account settings: https://app.coderpad.io/settings

Enjoy your interview!

module foo;

logic a;
logic b;

logic c;

assign c = (a === b) ? 1'b1 : 1'b0;

initial 
$display ("value of c is %b", c);

endmodule 


class Parent;

variables, functions etc
virtual function foo();

endclass

class Child extend Parent;
variables, functions etc

function foo();
endlcass

module ();

Parent p;
Child  c , c1;

c = new();
c.foo();

p = new();
$cast(p,c1)

$cast(c1,p)
c1 = p;

0-99
function rando 
rand number;
number=$rand{[0:99]}
reg arry [100];
if (arry[number]) return rando;
arry[number] =1;
if (&arry) arry =0;
return number;
endfunction

a. Signal 'x' stays high for the first 50 clocks
b. Signal 'x' toggles forever every clock after the first 50 clocks 

property checkx;
  rst ##50 x;
  @(posedge clk) disable #50 iff(rst) x|-> ##1 !x;
  @(posedge clk) disable #50 iff(rst) !x|-> ##1 x;
  endproperty

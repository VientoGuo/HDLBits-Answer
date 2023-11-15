//https://blog.csdn.net/qq_40919669/article/details/116429611?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169993586016800192260237%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169993586016800192260237&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-116429611-null-null.142%5Ev96%5Epc_search_result_base7&utm_term=verilog%20%E5%90%8C%E6%AD%A5%20fifo&spm=1018.2226.3001.4187
// note: reg a memory; main function: 1. reset, 2. write when not full, 3. read when not empty;
module sync_fifo#(parameter WIDTH = 8, parameter DEPTH = 256)
  (
    input clk;
    input rd_en;
    input wt_en;
    input reset;
    input [WIDTH-1:0] in_data;
    output full;
    output empty;
    output [WIDTH-1:0] out_data;
  );
  reg [$clog2(DEPTH):0] wt_cnt;
  reg [$clog2(DEPTH):0] rd_cnt;
  wire [$clog2(DEPTH)-1:0] wt_pt;
  wire [$clog2(DEPTH)-1:0] rd_pt;
  assign wt_pt = wt_cnt[$clog2(DEPTH)-1:0];
  assign rd_pt = rd_cnt[$clog2(DEPTH)-1:0];
  assign full = (wt_cnt[$clog2(DEPTH)]!=rd_cnt[$clog2(DEPTH)])&&(wt_cnt[$clog2(DEPTH)-1:0]==rd_cnt[$clog2(DEPTH)-1:0]);
  assign empty = wt_cnt == rd_cnt;
  reg [WIDTH-1:0] memory [DEPTH-1:0];
  reg [WIDTH-1:0] out_r;
  assign out_data = out_r;
    
  always@(posedge clk)begin
    if(reset)begin
      wt_cnt = 0;
      rd_cnt = 0;
    end
    else begin
      if(!full && wt_en)begin
        memory[wt_pt] = in_data;
        wt_cnt = wt_cnt +1;
      end
      if(!empty && rd_en)begin
        out_r = memory[rd_pt];
        rd_cnt = rd_cnt+1;
      end
    end
  end

  
endmodule

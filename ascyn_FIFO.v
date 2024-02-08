//-- modified by xlinxdu, 2022/05/17
// 原文链接：https://blog.csdn.net/qq_43244515/article/details/124825458
// To Verify an Async_fifo:
//Only read
//Only write
//Read and write simultaneously
//write full
//read empty
//full and empty are mutually exclusive
//simultaneously write_full and read_empty are active ( When read-side-clk is deactivated and other side it is writing)
//check reset behavior
//check reset to read/write wake up

module async_fifo
#(
  parameter DATA_WIDTH    = 16               ,
  parameter FIFO_DEPTH    = 8                ,
  parameter PTR_WIDTH     = 4                ,
  parameter ADDR_DEPTH    = $clog2(FIFO_DEPTH)
)
(
  //reset signal
  input   wire                      wr_rst_n_i,
  input   wire                      rd_rst_n_i,

  //write interface
  input   wire                      wr_clk_i ,
  input   wire                      wr_en_i  ,
  input   wire    [DATA_WIDTH-1:0]  wr_data_i,

  //read interface
  input   wire                      rd_clk_i ,
  input   wire                      rd_en_i  ,
  output  reg     [DATA_WIDTH-1:0]  rd_data_o,

  //flag
  output  reg                       full_o   ,
  output  reg                       empty_o
);
//-- memery
reg  [DATA_WIDTH-1:0] regs_array [FIFO_DEPTH-1:0] ;

//-- memery addr
wire [ADDR_DEPTH-1:0] wr_addr                     ;
wire [ADDR_DEPTH-1:0] rd_addr                     ;

//-- write poiter,write poiter of gray and sync
reg  [PTR_WIDTH -1:0] wr_ptr                      ;
wire [PTR_WIDTH -1:0] gray_wr_ptr                 ;
reg  [PTR_WIDTH -1:0] gray_wr_ptr_d1              ;
reg  [PTR_WIDTH -1:0] gray_wr_ptr_d2              ;

//-- read poiter,read poiter of gray and sync
reg  [PTR_WIDTH -1:0] rd_ptr                      ;
wire [PTR_WIDTH -1:0] gray_rd_ptr                 ;
reg  [PTR_WIDTH -1:0] gray_rd_ptr_d1              ;
reg  [PTR_WIDTH -1:0] gray_rd_ptr_d2              ;


/*-----------------------------------------------\
 --        write poiter and bin->gray      --
\-----------------------------------------------*/
always @ (posedge wr_clk_i or negedge wr_rst_n_i) begin
  if (!wr_rst_n_i) begin
    wr_ptr <= {(PTR_WIDTH){1'b0}};
  end
  else if (wr_en_i && !full_o) begin
    wr_ptr <= wr_ptr + 1'b1;
  end
end

assign gray_wr_ptr = wr_ptr ^ (wr_ptr >> 1'b1);

/*-----------------------------------------------\
 --              gray_wr_prt sync             --
\-----------------------------------------------*/
always @ (posedge wr_clk_i or negedge wr_rst_n_i) begin
  if (!wr_rst_n_i) begin
    gray_wr_ptr_d1 <= {(PTR_WIDTH){1'b0}};
    gray_wr_ptr_d2 <= {(PTR_WIDTH){1'b0}};
  end
  else begin
    gray_wr_ptr_d1 <= gray_wr_ptr   ;
    gray_wr_ptr_d2 <= gray_wr_ptr_d1;
  end
end

/*-----------------------------------------------\
 --         read poiter and bin->gray      --
\-----------------------------------------------*/
always @ (posedge rd_clk_i or negedge rd_rst_n_i) begin
  if (!rd_rst_n_i) begin
    rd_ptr <= {(PTR_WIDTH){1'b0}};
  end
  else if (rd_en_i && !empty_o) begin
    rd_ptr <= rd_ptr + 1'b1;
  end
end

assign gray_rd_ptr = rd_ptr ^ (rd_ptr >> 1'b1);

/*-----------------------------------------------\
 --              gray_rd_ptr sync             --
\-----------------------------------------------*/
always @ (posedge rd_clk_i or negedge rd_rst_n_i) begin
  if (!rd_rst_n_i) begin
    gray_rd_ptr_d1 <= {(PTR_WIDTH){1'b0}};
    gray_rd_ptr_d2 <= {(PTR_WIDTH){1'b0}};
  end
  else begin
    gray_rd_ptr_d1 <= gray_rd_ptr   ;
    gray_rd_ptr_d2 <= gray_rd_ptr_d1;
  end
end


/*-----------------------------------------------\
 --         full flag and empty flag           --
\-----------------------------------------------*/
assign full_o  = (gray_wr_ptr == {~gray_rd_ptr_d2[PTR_WIDTH-1],gray_rd_ptr_d2[PTR_WIDTH-2:0]})? 1'b1 : 1'b0;
assign empty_o = (gray_rd_ptr == gray_wr_ptr_d2)? 1'b1 : 1'b0;

/*-----------------------------------------------\
 --         write addr and read addr          --
\-----------------------------------------------*/
assign wr_addr = wr_ptr[PTR_WIDTH-2:0];
assign rd_addr = rd_ptr[PTR_WIDTH-2:0];

/*-----------------------------------------------\
 --             write operation              --
\-----------------------------------------------*/
integer [PTR_WIDTH-1:0] i;

always @ (posedge wr_clk_i or negedge wr_rst_n_i) begin
  if (!wr_rst_n_i) begin
    for(i=0;i<FIFO_DEPTH;i=i+1)begin
      regs_array[i] <= {(DATA_WIDTH){1'b0}};
    end
  end
  else if (wr_en_i && !full_o) begin
    regs_array[wr_addr] <= wr_data_i;
  end
end
/*-----------------------------------------------\
 --             read operation              --
\-----------------------------------------------*/

always @ (posedge rd_clk_i or negedge rd_rst_n_i) begin
  if (!rd_rst_n_i) begin
    rd_data_o <= {(DATA_WIDTH){1'b0}};
  end
  else if (rd_en_i && !empty_o) begin
    rd_data_o <= regs_array[rd_addr];
  end
end

endmodule
————————————————


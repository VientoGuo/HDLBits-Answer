module fifo
#(
	parameter  DATA_WIDTH =  8,
	parameter  DATA_DEPTH =  8,
	parameter  RAM_DEPTH  =  (1 << DATA_DEPTH)
)
(
	input      							clk,
	input      							rst_n,
	input  	  [DATA_WIDTH-1:0]   data_in,
	input      							wr_req,
	input      							rd_req,
	output reg [DATA_WIDTH-1:0]  	data_out,
	output     							empty,      //fifo empty
	output     							full      	//fifo full
);

	reg   [DATA_DEPTH-1:0]  wr_cnt;
	reg   [DATA_DEPTH-1:0]  rd_cnt;
	reg   [DATA_DEPTH-1:0]  data_cnt;


//-------------------------------------------------------
	assign full  = (data_cnt == (RAM_DEPTH-1))? 1'b1: 1'b0;
	assign empty = (data_cnt == 0)? 1'b1: 1'b0;

//-------------------------------------------------------
	always @(posedge clk or negedge rst_n)begin
		if(rst_n == 1'b0)begin
			wr_cnt <= 0;
		end
		else if(wr_cnt == RAM_DEPTH-1)
			wr_cnt <= 0;
		else if(wr_req)begin
			wr_cnt <= wr_cnt + 1'b1;
		end
		else
			wr_cnt <= wr_cnt;
	end

//-------------------------------------------------------
	always @(posedge clk or negedge rst_n)begin
		if(rst_n == 1'b0)begin
			rd_cnt <= 0;
		end
		else if(rd_cnt == RAM_DEPTH-1)
			rd_cnt <= 0;
		else if(rd_req)begin
			rd_cnt <= rd_cnt + 1'b1;
		end
		else
			rd_cnt <= rd_cnt;
	end

//-------------------------------------------------------
	always @(posedge clk or negedge rst_n)begin
		if(rst_n == 1'b0)begin
			data_cnt <= 0;
		end
		else if(rd_req && !wr_req && (data_cnt != 0))begin
			data_cnt <= data_cnt - 1;
		end
		else if(wr_req && !rd_req && (data_cnt != RAM_DEPTH-1))
			data_cnt <= data_cnt + 1;
		else
			data_cnt <= data_cnt;

	end
endmodule


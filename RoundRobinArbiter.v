//原文链接：https://blog.csdn.net/Ocean_Yv/article/details/126496121
// Verify a RRA:
// 1)In any cycle, there can be only one grant signal that can be asserted.
// 2) Each requesting agent should get a grant signal in a maximum 2 cycle window.
// 3) If one requesting agent gets a grant, it cannot receive another grant unless no other agent is requesting.
// 4) If there are no requests, there cannot be any grants asserted
// 5) If not in reset, none of the grants should go to unknown. 
module round_robin_arb(
    input   clk         ,
    input   rst_n       ,
    
    input  [3:0] request,
    output [3:0] grant
);

    // 存储移位后上一次仲裁结果
    reg  [3:0] last_state;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            last_state <= 4'b0001;     // 默认值，表示最低位的优先级最高
        else if(|request)
            last_state <= {grant[2],grant[1],grant[0],grant[3]}; // 有仲裁请求，根据上一次的仲裁结果，左移1bit后用于控制新的优先级
        else
            last_state <= last_state;  // 无仲裁请求时，pre_state不更新
    end

    // 如果最左侧几个高优先级主机都为发起仲裁请求，需要从最低位开始轮询。
    // 此处通过两个request拼接，将右侧低位拼接到左侧，即可实现对低位的判断。
    wire [7:0] grant_ext;
    assign grant_ext = {request,request} & ~({request,request} - last_state);

    // 得到的grant_ext必定为一个独热码，但是置高位可能在代表低位的高4bit中，因此进行求或运算
    assign grant = grant_ext[3:0] | grant_ext[7:4];

endmodule
// another way
module round_robin(clk,rst,req,grant);

   output [3:0] grant;
   reg   grant;
   input  clk;
   input  rst;
   input [3:0]  req;


   reg [2:0]  state;
   reg [2:0]  next_state;
   reg [1:0]  count;
 
 
   parameter [2:0] s_ideal=3'b000;
   parameter [2:0] s0=3'b001;
   parameter [2:0] s1=3'b010;
   parameter [2:0] s2=3'b011;
   parameter [2:0] s3=3'b100;



   always @(posedge clk or posedge rst)
     begin
 if(rst)
   state=s_ideal;
 else
   state=next_state;
     end


   always @(state,next_state,count)
     begin
 case (state)
   s0:
     begin
        if (req[0])
   begin
      if(count==2'b11)
        begin
    if (req[1])
      begin
         count=2'b00;
         next_state=s1;
      end
    else if (req[2])
      begin
         count=2'b00;
         next_state=s2;
      end
    else if (req[3])
      begin
         count=2'b00;
         next_state=s3;
      end
    else
      begin
         count=2'b00;
         next_state=s0;
      end
        end // if (count==2'b11)
      else
        begin
    count=count+2'b01;
    next_state=s0;
        end // else: !if(count==2'b11)
   end // if (req[0])
        else if (req[1])
   begin
      count=2'b00;
      next_state=s1;
   end
        else if (req[2])
   begin
      count=2'b00;
      next_state=s2;
   end
        else if (req[3])
   begin
      count=2'b00;
      next_state=s3;
   end
        else
   begin
      count=2'b00;
      next_state=s_ideal;
   end
     end // case: s0


   s1:
     begin
        if (req[1])
   begin
      if (count==2'b11)
        begin
    if (req[2])
      begin
         count=2'b00;
         next_state=s2;
      end
    else if (req[3])
      begin
         count=2'b00;
         next_state=s3;
      end
    else if (req[0])
      begin
         count=2'b00;
         next_state=s0;
      end
    else
      begin
         count=2'b00;
         next_state=s1;
      end
        end // if (count==2'b11)
      else
        begin
    count=count+2'b01;
    next_state=s1;
        end // else: !if(count==2'b11)
   end // if (req[1])
        else if (req[2])
   begin
      count=2'b00;
      next_state=s2;
   end
        else if (req[3])
   begin
      count=2'b00;
      next_state=s3;
   end
        else if (req[0])
   begin
      count=2'b00;
      next_state=s0;
   end
        else
   begin
      count=2'b00;
      next_state=s_ideal;
   end
     end // case: s1



   s2:
     begin
        if (req[2])
   begin
      if (count==2'b11)
        begin
    if (req[3])
      begin
         count=2'b00;
         next_state=s3;
      end
    else if (req[0])
      begin
         count=2'b00;
         next_state=s0;
      end
    else if (req[1])
      begin
         count=2'b00;
         next_state=s1;
      end
    else
      begin
         count=2'b00;
         next_state=s2;
      end
        end // if (count==2'b11)
      else
        begin
    count=count+2'b01;
    next_state=s2;
        end // else: !if(count==2'b11)
   end // if (req[2])
        else if (req[3])
   begin
      count=2'b00;
      next_state=s3;
   end
        else if (req[0])
   begin
      count=2'b00;
      next_state=s0;
   end
        else if (req[1])
   begin
      count=2'b00;
      next_state=s1;
   end
        else
   begin
      count=2'b00;
      next_state=s_ideal;
   end
     end // case: s2



   s3:
     begin
        if (req[3])
   begin
      if (count==2'b11)
        begin
    if (req[0])
      begin
         count=2'b00;
         next_state=s0;
      end
    else if (req[1])
      begin
         count=2'b00;
         next_state=s1;
      end
    else if (req[2])
      begin
         count=2'b00;
         next_state=s2;
      end
    else
      begin
         count=2'b00;
         next_state=s3;
      end
        end // if (count==2'b11)
      else
        begin
    count=count+2'b01;
    next_state=s3;
        end // else: !if(count==2'b11)
   end // if (req[3])
        else if (req[0])
   begin
      count=2'b00;
      next_state=s0;
   end
        else if (req[1])
   begin
      count=2'b00;
      next_state=s1;
   end
        else if (req[2])
   begin
      count=2'b00;
      next_state=s2;
   end
        else
   begin
      count=2'b00;
      next_state=s_ideal;
   end
     end // case: s3


   default:
     begin
        if (req[0])
   begin
      count=2'b00;
      next_state=s0;
   end
        else if (req[1])
   begin
      count=2'b00;
      next_state=s1;
   end
        else if (req[2])
   begin
      count=2'b00;
      next_state=s2;
   end
        else if (req[3])
   begin
      count=2'b00;
      next_state=s3;
   end
        else
   begin
      count=2'b00;
      next_state=s_ideal;
   end
     end // case: default
 endcase // case (state)
     end // always @ (state,next_state,count)     


always @(state,next_state,count)
  begin
     case (state)
       s0:begin grant=4'b0001; end
       s1:begin grant=4'b0010; end
       s2:begin grant=4'b0100; end
       s3:begin grant=4'b1000; end
       default:begin grant=4'b0000; end
     endcase // case (state)
  end
 endmodule



/* 

Title : FIFO 
Author : Shree

*/






module router_fifo(input clk,resetn,soft_reset,write_enb,read_enb,lfd_state,input [7:0]data_in,output reg [7:0]data_out,output full,empty);
		reg [8:0]mem[15:0];
		reg [4:0]wr_pt,rd_pt;
		reg [6:0]counter;
		integer i;
		reg lfd_state_s;

//fifo counter logic
		always@(posedge clk)
		begin
		   if(!resetn)
		   counter<=7'd0;
		   
		   else if(soft_reset)
		   counter<=7'd0;
		   
		   else if(read_enb && !empty)
		   begin
			if(mem[rd_pt[3:0]] [8]==1'b1)
			counter<=mem[rd_pt[3:0]] [7:2]+7'd1;
			
			else if(counter!=7'd0)
			counter<=counter-7'd1;
		   end
		end	
		
		
		always@(posedge clk)
			begin
				
				if(~resetn)	
					lfd_state_s<=1'b0;
				else	
					lfd_state_s<= lfd_state;
				
			end

		//read logic
		always@(posedge clk)
		begin
		   if(!resetn)
		   data_out<=8'd0;
		   
		   else if(soft_reset)
		   data_out<=8'dz;
		   
		   else
		   begin
			 if(counter==7'd0 && data_out!=8'd0)
			 data_out<=8'dz;
			 
			 else if(read_enb && !empty)
			 data_out<=mem[rd_pt[3:0]][7:0];
			end
		end	

		//write logic
		always@(posedge clk)
		begin
		  if(!resetn)
		  begin
		  for(i=0;i<16;i=i+1)
		  mem[i]<=9'd0;
		  end
		  
		   else if(soft_reset)
		   begin
		   for(i=0;i<16;i=i+1)
		   mem[i]<=9'd0;
		   end
		   
		   else
		   begin
			if(write_enb && !full)
			mem[wr_pt[3:0]]<={lfd_state_s,data_in};
		   end
		end	
				
		//wr_pt and rd_pt logic
		always@(posedge clk)
		begin
		 if(!resetn)
		 begin
		   wr_pt<=5'd0;
		   rd_pt<=5'd0;
		 end
		  
		  else if(soft_reset)
		  begin
		   wr_pt<=5'd0;
		   rd_pt<=5'd0;
		  end
		  
		  else
		  begin
		   if(!full && write_enb)
			wr_pt<=wr_pt+5'd1;
		   
		   else
		   wr_pt<=wr_pt;
		   
		   if(!empty && read_enb)
			rd_pt<=rd_pt+5'd1;
		   
		   else
		   rd_pt<=rd_pt;
		   end
		end

		assign full=(wr_pt=={~rd_pt[4],rd_pt[3:0]}) ? 1'b1:1'b0;
		assign empty=(wr_pt==rd_pt) ? 1'b1:1'b0;

endmodule

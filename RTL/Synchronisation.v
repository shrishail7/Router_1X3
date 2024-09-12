
// Synchronisation RTL
// int_addr_reg ??? => in program

module router_sync(clk,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,data_in,write_enb,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,vld_out_0,vld_out_1,vld_out_2);

	input clk,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
	input [1:0]data_in;
	output reg [2:0]write_enb;
	output reg soft_reset_0,soft_reset_1,soft_reset_2;
	output reg fifo_full;
	output vld_out_0,vld_out_1,vld_out_2;

	reg [1:0]temp_reg;//stores addr
	reg [4:0]timer_0,timer_1,timer_2;//for noting 30 clock pulse of each fifo_0,1,2 

//capturing address into synchronizer if detect_add==1
		always@(posedge clk)
			begin
				if(!resetn)
				   temp_reg<=2'b00;
				else if(detect_add)
				temp_reg<=data_in;
			end

//write enable logic--decoder logic-enables anyone of the fifo based on adrr stored in temp_reg(combinational circuit)
		always@(*)
		begin

		   if(write_enb_reg)
			  begin
				case(temp_reg)
				  2'b00:write_enb=3'b001;
				  2'b01:write_enb=3'b010;
				  2'b10:write_enb=3'b100;
				default:write_enb=3'b000;
				endcase
			  end
			  
			else
			write_enb=3'b000;
		end

//fifo_full logic depends on temp_reg for indicating fifo_full(mux 4x1-combinational circuit) 
		always@(*)
			begin
				 case(temp_reg)
				 2'b00:fifo_full=full_0;
				 2'b01:fifo_full=full_1;
				 2'b10:fifo_full=full_2;
				 default:fifo_full=1'b0;
			 endcase
		end

//activating soft_reset_0 after 30 clock cycles if read_enb_0 is not high if vld_out_0 is high
		always@(posedge clk)
			begin
				 soft_reset_0<=1'b0;
				 timer_0<=5'd0;
				  if(!resetn)
				  begin
					   soft_reset_0<=1'b0;
					   timer_0<=5'd0;
				  end
				  
				  else if(vld_out_0)
				  begin
				  
					if(!read_enb_0)
					begin
					  if(timer_0==5'd29)
						  begin
							   soft_reset_0<=1'b1;
							   timer_0<=5'd0;
						  end
						else
						  begin
							   soft_reset_0<=1'b0;
							   timer_0<=timer_0+5'd1;
						  end
					  
					end   
				  end
			end

//activating soft_reset_1 after 30 clock cycles if read_enb_1 is not high if vld_out_1 is high
		always@(posedge clk)
		begin
		 soft_reset_1<=1'b0;
		 timer_1<=5'd0;
		  if(!resetn)
			  begin
			   soft_reset_1<=1'b0;
			   timer_1<=5'd0;
			  end
		  
		  else if(vld_out_1)
			  begin
			  
				if(!read_enb_1)
				begin
				  if(timer_1==5'd29)
				  begin
				   soft_reset_1<=1'b1;
				   timer_1<=5'd0;
				  end
				  else
				  begin
				   soft_reset_1<=1'b0;
				   timer_1<=timer_1+5'd1;
				  end
				end   
		  end
		end

//activating soft_reset_2 after 30 clock cycles if read_enb_2 is not high if vld_out_2 is high
		always@(posedge clk)
		begin
			 soft_reset_2<=1'b0;
			 timer_2<=5'd0;
			  if(!resetn)
				  begin
				   soft_reset_2<=1'b0;
				   timer_2<=5'd0;
				  end
			  
			  else if(vld_out_2)
				  begin
				  
					if(!read_enb_2)
						begin
						  if(timer_2==5'd29)
							  begin
							   soft_reset_2<=1'b1;
							   timer_2<=5'd0;
							  end
						  else
							  begin
							   soft_reset_2<=1'b0;
							   timer_2<=timer_2+5'd1;
							  end
						end   
			  end
		end

		//vld_out_0,1,2 to be high when empty_0,1,2 is low
		assign vld_out_0=~empty_0;
		assign vld_out_1=~empty_1;
		assign vld_out_2=~empty_2;

endmodule






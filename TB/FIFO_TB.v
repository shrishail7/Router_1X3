
/* 

Title : FIFO TB
Author : Shree

*/


//Router_fifo TB
module router_fifo_tb();
		reg  clk,resetn,soft_reset,write_enb,read_enb,lfd_state;
		reg  [7:0]data_in;
		wire [7:0]data_out;
		wire full,empty;
		integer k;

		router_fifo DUT(clk,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,data_out,full,empty);

		always
		begin
		#5 clk=1'b0;
		#5 clk=1'b1;
		end


		task reset;
			begin
				@(negedge clk)
				resetn=1'b0;
				@(negedge clk)
				resetn=1'b1;
			end
		endtask

		task soft_rst;
			begin
				@(negedge clk)
				soft_reset=1'b1;
				@(negedge clk)
				soft_reset=1'b0;
			end
		endtask

		task read(input i,j);
			begin
				write_enb=i;
				read_enb=j;
			end 
		endtask

		task write();
			reg [7:0]header,payload,parity;
			reg[5:0]payload_len;
			reg[1:0]adrr;

			begin
				 @(negedge clk)
				 payload_len=6'd14;
				 adrr=2'd0;
				 header={payload_len,adrr};
				 data_in=header;
				 lfd_state=1'b1;
				 write_enb=1'b1;
			 
				 for(k=0;k<payload_len;k=k+1)
					begin
					 @(negedge clk)
						 lfd_state=1'b0;
						 payload={$random}%256;
						 data_in=payload;
					end
 
					 @(negedge clk)
					 parity={$random}%256;
					 data_in=parity;
			 end
		endtask
					 
		 initial
			 begin
				 reset;
				 write;
				 #10;
				 read(0,1);
				 soft_rst;
			end
 
 endmodule
 


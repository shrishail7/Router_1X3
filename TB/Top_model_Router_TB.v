
// Top model router TB


module Router_Top_model_TB;
	
	reg clk , resetn , read_enb_0 , read_enb_1 , read_enb_2 , pkt_valid ;
	reg [7:0] data_in ;
	wire vld_out_0 , vld_out_1 , vld_out_2 , err , busy ;
	wire [7:0] data_out_0 , data_out_1 , data_out_2 ;
	
	// clock generation
	always
		begin
			#5 clk=1'b0;
			#5 clk=1'b1;
		end
		
	// reset the system
	task reset_system;
		begin
			@(negedge clk)
				resetn = 1'b0;
			@(negedge clk)
				resetn = 1'b1;
		end
	endtask
	
	
	// initialisation 
	task initialize;
		begin
			//{read_enb_0 , read_enb_1 , read_enb_2 , pkt_valid , data_in , vld_out_0 , vld_out_1 , vld_out_2} = 8'd0;
			read_enb_0 = 1'b0;
			read_enb_1 = 1'b0;
			read_enb_2 = 1'b0;
			pkt_valid = 1'b0;
			data_in = 1'b0;
			vld_out_0 = 1'b0;
			vld_out_1 = 1'b0;
			vld_out_2 = 1'b0;
			resetn=0;
			
			#5;
			resetn = 1'd1;
		end
	endtask
	
	// packet genartion
	task pkt_gen(input [5:0] x);
		
			reg [7:0] payload_data;
			reg [7:0] parity , header;
			reg [5:0] payload_len;
			reg [1:0] addr;
			integer i;
		
		begin
			wait(!busy);
			
				@(negedge clk);
				payload_len = x;
				addr=2'b00;
				header={payload_len , addr};
				parity=0;
				data_in = header;
				pkt_valid=1;
				parity = parity^header;
				
				for(i=0;i<payload_len;i=i+1)
					begin
						wait(~busy);
						@(negedge clk);
						payload_data = {$random}%256;
						data_in = payload_data;
						parity = parity^data_in;
					end
					
					wait(!busy);
					@(negedge clk);
					pkt_valid=0;
					data_in = parity;
			
		end
	endtask
	
	
	initial
		begin
			initialize;
			reset_system;
			fork
				pkt_gen(6'd14);
				begin
					wait(vld_out_0);
					@(negedge clk);
					read_enb_0=1'b1;
				end
			join
		end
		
endmodule

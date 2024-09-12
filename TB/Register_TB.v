
// Register TB


module Register_TB;
	
	reg clk , rst , pkt_valid , detect_add , fifo_full , rst_int_reg , ld_state , laf_state , full_state , lfd_state ;  
	reg [7:0] data_in;
	
	wire parity_done , low_pkt_valid , err ;
	wire  [7:0] dout ;
	
	Register DUT (clk , rst , pkt_valid , data_in , fifo_full , rst_int_reg , detect_add , ld_state , laf_state , full_state , lfd_state , parity_done , low_pkt_valid , err , dout);
	
	
	initial
		clk= 1'd1;
		
	always
		begin
			#5;
			clk = ~clk;
		end
	
	task reset_system;
		begin
			rst = 1'b0;
			{clk , rst , pkt_valid , fifo_full , rst_int_reg , ld_state , laf_state , full_state , lfd_state, data_in} = 'd0;
			#5;
			rst=1'd1;
		end
	endtask
	// good packet  
	task packet_generation;
		reg [7:0] payload_data , parity , header;
		reg [5:0] payload_len;
		reg [1:0] addr;
		integer i;
		begin 
			@(negedge clk)
			payload_len = 6'd5;
			addr = 2'b10;
			pkt_valid = 1'b1;
			detect_add = 1'b1;
			header = {payload_len , addr};
			parity = 8'h00^header;
			@(negedge clk)
			detect_add = 1'b0;
			lfd_state = 1'b1;
			full_state = 1'b0;
			fifo_full = 1'b0;
			laf_state = 1'b0;
			
			for(i=0;i<payload_len;i=i+1)
				begin
					@(negedge clk)
						lfd_state = 1'b0;
						ld_state = 1'b1;
						payload_data = {$random}%256;
						data_in = payload_data;
						parity = parity^data_in;
				end
			@(negedge clk)
			pkt_valid = 1'b0;
			data_in = parity;
			@(negedge clk)
			ld_state = 1'b0;
		end
	endtask
	
	initial
		begin
			reset_system;
			packet_generation;
			#10000 $finish;
		end
	
endmodule
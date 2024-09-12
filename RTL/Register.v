
 // Register
 
 module Register(clk , rst , pkt_valid , data_in , fifo_full , rst_int_reg , detect_add , ld_state , laf_state , full_state , lfd_state , parity_done , low_pkt_valid , err , dout);
	
	input clk , rst , pkt_valid , detect_add , fifo_full , rst_int_reg , ld_state , laf_state , full_state , lfd_state ;  
	input [7:0] data_in;
	
	output reg parity_done , low_pkt_valid , err ;
	output reg [7:0] dout ;
	
	reg [7:0] Header_byte , fifo_full_state_byte;
	reg [7:0] internal_parity;
	reg packet_parity;
	
	// data output
	always@(posedge clk)
		begin
			if(!rst)
				dout<=8'd0;
				
			else if(lfd_state)
				dout<=Header_byte;
			else if(ld_state && !fifo_full)
				dout<=data_in;
			else if(laf_state)
				dout<=fifo_full_state_byte;
			else 
				dout<=dout;
		end
		
	// header byte
	always@(posedge clk)
		begin
			if(!rst)
				{Header_byte  , fifo_full_state_byte}<=8'd0;
			else
				begin
					if(pkt_valid && detect_add)
						Header_byte<=data_in;
					else if( ld_state && fifo_full)
						fifo_full_state_byte<=data_in;
				end
		end
	
	// parity_done logic 
	always@(posedge clk)
		begin
			if(!rst)
				parity_done<= 1'd0;
			else 
				begin
					if(ld_state && !pkt_valid && !fifo_full)
						parity_done<=1'd1;
					else if(laf_state && !parity_done && low_pkt_valid)
						parity_done<=1'd1;
					else 
						begin
							if(detect_add)
								parity_done<=1'd0;
						end
				end
		end
		
	// packet_parity logic
	always@(posedge clk)
		begin
			if(!rst)
				packet_parity<=1'd0;
				
			else if((ld_state && !pkt_valid && !fifo_full) || (laf_state && low_pkt_valid && !parity_done) )
				packet_parity<=data_in;
				
			else if(!pkt_valid && rst_int_reg)
				packet_parity<=1'd0;
			
			else 
				begin
					if(detect_add)
						packet_parity<=1'd0;
				end
		end
		
	
	// internal parity
	always@(posedge clk)
		begin
			if(!rst)
				internal_parity<=8'd0;
			else if(detect_add )
				internal_parity<=8'd0;
			else if(lfd_state)
				internal_parity<=Header_byte;
			else if(ld_state && pkt_valid && !full_state)
				internal_parity<=internal_parity ^ data_in;
			else if(!pkt_valid && rst_int_reg)
				internal_parity<=8'd0;
		end
		
	// Error logic
	always@(posedge clk)
		begin
			if(!rst)
				err<=0;
			else 
				begin
					if(parity_done == 1'b1 && (internal_parity != packet_parity))
						err<=1'b1;
					else	
						err<=1'b0;
				end
		end
		
	// low packet valid
	always@(posedge clk)
		begin
			if(!rst)
				low_pkt_valid<=1'b0;
			else
				begin
					if(rst_int_reg)
						low_pkt_valid<=1'b0;
					if(!pkt_valid && ld_state)
						low_pkt_valid <=1'd1;
				end
		end
		
endmodule


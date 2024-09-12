/*

	
******************** FSM TB for Router ********************
	Author : Shree

*/


module FSM_Router_TB;
	
	reg rst , clk , pkt_valid , parity_done , soft_rst_0 , soft_rst_1 , soft_rst_2 , fifo_full ,low_pkt_valid , fifo_empty_0 , fifo_empty_1 , fifo_empty_2;
	reg [1:0] data_in ;
	
	wire busy , detect_addr , ld_state , laf_state , full_state , write_enb_reg , rst_int_reg , lfd_state ;
	
	FSM_Router DUT(rst , clk ,pkt_valid , busy , parity_done , data_in , soft_rst_0 , soft_rst_1 , soft_rst_2 , fifo_full , low_pkt_valid , fifo_empty_0 ,
					fifo_empty_1 , fifo_empty_2 , detect_addr , ld_state , laf_state , full_state , write_enb_reg , rst_int_reg , lfd_state); 
	
// clk
	initial
		clk = 1'd1;
		
	always
		begin
			#5;
			clk=!clk;
		end
		
		
// reset the system
// pkt_valid , parity_done , soft_rst_0 , soft_rst_1 , soft_rst_2 , fifo_full ,low_pkt_valid , fifo_empty_0 , fifo_empty_1 , fifo_empty_2;

	task reset_system;
		begin
			rst = 1'd0;
			pkt_valid=1'd0;
			parity_done = 1'd0;
			soft_rst_0 = 1'd0;
			soft_rst_1 = 1'd0;
			soft_rst_2 = 1'd0;
			fifo_full = 1'd0;
			low_pkt_valid = 1'd0;
			fifo_empty_0 = 1'd0;
			fifo_empty_1 = 1'd0;
			fifo_empty_2 = 1'd0;
			#5;
			rst = 1'd1;
		
		end
	endtask
		
// task 1
	task t1();
		begin
			@(negedge clk)
				pkt_valid = 1'b1;
				data_in = 2'b01;
				fifo_empty_1 = 1'b01;
				@(negedge clk)
				@(negedge clk)
				fifo_full = 1'b0;
				pkt_valid = 1'b0;
				@(negedge clk)
				@(negedge clk)
				fifo_full = 1'b0;
		end
	endtask
	
// task 2 
	task t2();
		begin
			@(negedge clk)
				pkt_valid = 1'b1;
				data_in = 2'b01;
				fifo_empty_1 = 1'b1;
				@(negedge clk)
				@(negedge clk)
				fifo_full = 1'b1;
				@(negedge clk)
				fifo_full = 1'b0;
				@(negedge clk)
				parity_done = 1'b0;
				low_pkt_valid = 1'b1;
				@(negedge clk)
				@(negedge clk)
				fifo_full = 1'b0;
		end
	endtask
	
	
// task 3
	
	task t3();
		begin
			@(negedge clk)
			pkt_valid = 1'b1;
			data_in = 2'b01;
			fifo_empty_1 = 1'b1;
			@(negedge clk)
			@(negedge clk)
			fifo_full = 1'b1;
			@(negedge clk)
			fifo_full = 1'b0;
			@(negedge clk)
			parity_done = 1'b0;
			low_pkt_valid = 1'b0;
			@(negedge clk)
			fifo_full = 1'b0;
			pkt_valid = 1'b0;
			@(negedge clk)
			@(negedge clk)
			fifo_full=1'b0;
		end
	endtask
	
	// task 4
	
		task t4();
		begin
			@(negedge clk)
			pkt_valid = 1'b1;
			data_in = 2'b01;
			fifo_empty_1 = 1'b1;
			@(negedge clk)
			@(negedge clk)
			fifo_full = 1'b0;
			pkt_valid = 1'b0;
			@(negedge clk)
			@(negedge clk)
			fifo_full = 1'b1;
			@(negedge clk)
			fifo_full = 1'b0;
			@(negedge clk)
			parity_done = 1'b1;
		end
	endtask
	


	initial	
		begin
			//rst=1'd0;
			//#5;
			//rst=1'd1;
			reset_system ; 
			t1;
			t2;
			t3;
			t4;
			#1000 $finish;
		end
		
	
		

endmodule


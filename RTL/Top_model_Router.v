

// router top model rtl

/*
	***** FIFO *****
		write_enb
		[2:0] write_enb
		lfd_state 
		[7:0] data_in
		[2:0] data_in
		
	***** SYNC *****
	write_enb_reg
	[1:0] data_in
	[2:0] write_enb
	fifo_full
	
	***** FSM *****
	parity_done
	fifo_full
	low_pkt_valid
	[1:0] data_in  => data_in_reg
	ld_state'
	laf_state
	full_state
	write_enb_reg
	rst_int_reg 
	lfd_state

*/

module Router_Top_model(  clk , resetn , read_enb_0 , read_enb_1 , read_enb_2 , pkt_valid , data_in , 
						 vld_out_0 , vld_out_1 , vld_out_2 , err , busy ,  data_out_0 , data_out_1 , data_out_2  );
						
	input clk , resetn , read_enb_0 , read_enb_1 , read_enb_2 , pkt_valid ;
	input [7:0] data_in ;
	output vld_out_0 , vld_out_1 , vld_out_2 , err , busy ;
	output [7:0] data_out_0 , data_out_1 , data_out_2 ;
	
	
	reg soft_reset  , read_enb  , detect_add  , empty_0 , empty_1 , empty_2,full_0 , full_1 , full_2 ; // , parity_done , write_enb_reg , low_pkt_valid ; 
	reg soft_rst_0 , soft_rst_1 , soft_rst_2  , fifo_empty_0 , fifo_empty_1 , fifo_empty_2 ; 
	//reg [7:0] data_in ;
	
	wire write_enb_reg , parity_done , low_pkt_valid ;
	
	wire [1:0] data_in_reg;  // change
	wire [7:0] data_out , dout ;
	wire full , lfd_state , write_enb , empty , soft_reset_0 , soft_reset_1 , soft_reset_2 , fifo_full , detect_addr , ld_state , laf_state , full_state , rst_int_reg ;

	
	router_fifo f0 ( clk,resetn,soft_reset,write_enb,read_enb,lfd_state, data_in, data_out, full,empty);
	router_fifo f1 ( clk,resetn,soft_reset,write_enb,read_enb,lfd_state, data_in, data_out, full,empty);
	router_fifo f2 ( clk,resetn,soft_reset,write_enb,read_enb,lfd_state, data_in, data_out, full,empty);


	router_sync sync (clk,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,data_in_reg,write_enb,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,vld_out_0,vld_out_1,vld_out_2);
	// data_in change in SYNC
	// data_in change in fsm
	FSM_Router FSM (resetn , clk ,pkt_valid , busy , parity_done , data_in_reg , soft_rst_0 , soft_rst_1 , soft_rst_2 , fifo_full , low_pkt_valid , fifo_empty_0 ,
					fifo_empty_1 , fifo_empty_2 , detect_addr , ld_state , laf_state , full_state , write_enb_reg , rst_int_reg , lfd_state );
					
					
	
	Register  register (clk , resetn , pkt_valid , data_in , fifo_full , rst_int_reg , detect_add , ld_state , laf_state , full_state , lfd_state , parity_done , low_pkt_valid , err , dout);
	
endmodule


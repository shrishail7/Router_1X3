
/* 

******************** FSM for Router ********************
Author : Shree 
	
	
*/
/*

	ld_state = load data state ,
	laf_state = load after full state ,
	lfd_state = load first data state

*/

module FSM_Router(rst , clk ,pkt_valid , busy , parity_done , data_in , soft_rst_0 , soft_rst_1 , soft_rst_2 , fifo_full , low_pkt_valid , fifo_empty_0 ,
					fifo_empty_1 , fifo_empty_2 , detect_addr , ld_state , laf_state , full_state , write_enb_reg , rst_int_reg , lfd_state );
					
		
	input rst , clk , pkt_valid , parity_done , soft_rst_0 , soft_rst_1 , soft_rst_2 , fifo_full ,low_pkt_valid , fifo_empty_0 , fifo_empty_1 , fifo_empty_2;
	input [1:0] data_in ;
	
	output busy , detect_addr , ld_state , laf_state , full_state , write_enb_reg , rst_int_reg , lfd_state ;
	
	
	parameter	DECODE_ADDRESS=3'D0,
				LOAD_FIRST_DATA=3'D1,
				LOAD_DATA = 3'D2,
				FIFO_FULL_STATE = 3'D3,
				LOAD_AFTER_FULL = 3'D4 ,
				LOAD_PARITY = 3'D5,
				CHECK_PARITY_ERROR = 3'D6,
				WAIT_TILL_EMPTY = 3'D7;
				
	reg [2:0] curr , next;
	reg [1:0] addr;  // to store the address;
				
	//******************** present state logic ********************
	
	always@(posedge clk)
		begin
			if(!rst)
				curr<=DECODE_ADDRESS;
			else
				if((soft_rst_0 && data_in == 2'b00) || (soft_rst_1 && data_in == 2'b01)  ||  (soft_rst_0 && data_in == 2'b10))
					curr <= DECODE_ADDRESS;
				else 	
					curr <= next;
		end
		
	//******************** internal address variable ********************
	
	always@(posedge clk)
		begin
			if(!rst)
				addr<=2'd00;
			else if((soft_rst_0 && data_in == 2'b00) || (soft_rst_1 && data_in == 2'b01)  ||  (soft_rst_0 && data_in == 2'b10))
				addr<=2'd00;
			else if(detect_addr)
				addr<=data_in;
		end
		
	// ******************** next state logic ********************
	always@(*)
		begin
			case(curr)
				//begin
					DECODE_ADDRESS : 
									begin
										if((pkt_valid && (data_in == 2'b00) && fifo_empty_0) || 
											(pkt_valid && (data_in == 2'b01) && fifo_empty_1) || 
												(pkt_valid && (data_in == 2'b10) && fifo_empty_2))
												next<=LOAD_FIRST_DATA;
												
										else if((pkt_valid && (data_in == 2'b00) && !fifo_empty_0) || 
											(pkt_valid && (data_in == 2'b01) && !fifo_empty_1) || 
												(pkt_valid && (data_in == 2'b10) && !fifo_empty_2))
												next<=WAIT_TILL_EMPTY;
												
										else 	
											next <= DECODE_ADDRESS;												
									end
					
					LOAD_FIRST_DATA : 
									begin
										next<=LOAD_DATA;
									end
					LOAD_DATA		:
									begin
										if(!fifo_full && !pkt_valid)
											next<=LOAD_PARITY;
										else if( fifo_full)
											next<= FIFO_FULL_STATE;
										else 
											next<= LOAD_DATA;
									end
					LOAD_PARITY		: next<=CHECK_PARITY_ERROR;
					CHECK_PARITY_ERROR : 
									begin
										if(!fifo_full)
											next<=DECODE_ADDRESS;
										else 
											next<=FIFO_FULL_STATE;
									end
					FIFO_FULL_STATE :
									begin
										if(!fifo_full)
											next<=LOAD_AFTER_FULL;
										else 
											next<=FIFO_FULL_STATE;
									end
					LOAD_AFTER_FULL :
									begin
										if(!parity_done && !low_pkt_valid)
											next<=LOAD_DATA;
										else if(parity_done)
											next<=DECODE_ADDRESS;
									end	
					default : next<=DECODE_ADDRESS;
				//end
				endcase
		end
		
		
	// **********  output **********
	assign detect_addr = (curr == DECODE_ADDRESS) ? 1'b1 : 1'b0 ;
	assign lfd_state = (curr == LOAD_FIRST_DATA ) ? 1'b1 : 1'b0 ;
	assign ld_state = (curr == LOAD_DATA) ? 1'b1 : 1'b0 ;
	assign full_state = (curr == FIFO_FULL_STATE) ? 1'b1 : 1'b0 ;
	assign laf_state = (curr == LOAD_AFTER_FULL) ? 1'b1 : 1'b0 ;
	assign rst_int_reg = (curr == CHECK_PARITY_ERROR) ? 1'b1 : 1'b0 ;
	assign write_enb_reg = ( (curr == LOAD_DATA) || (curr == LOAD_AFTER_FULL) || ( curr == LOAD_PARITY) ) ? 1'b1 : 1'b0 ;
	assign busy = ( (curr == LOAD_FIRST_DATA) || (curr == FIFO_FULL_STATE) || (curr == LOAD_AFTER_FULL) || (curr == LOAD_PARITY) || ( curr == CHECK_PARITY_ERROR ) || ( curr == WAIT_TILL_EMPTY )) ? 1'b1 : 1'b0 ;
	
endmodule


		
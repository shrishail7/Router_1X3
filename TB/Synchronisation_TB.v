
// Synchronisation TB



module router_sync_tb();
	reg clk,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
	reg[1:0]data_in;
	wire[2:0]write_enb;
	wire soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,vld_out_0,vld_out_1,vld_out_2;

router_sync DUT(clk,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,data_in,write_enb,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,vld_out_0,vld_out_1,vld_out_2);

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

	task initialize;
		begin
		  detect_add=1'b0;
		  data_in=2'b00;
		  write_enb_reg=1'b0;
		  {empty_0,empty_1,empty_2}=3'b111;
		  {full_0,full_1,full_2}=3'b000;
		  {read_enb_0,read_enb_1,read_enb_2}=3'b000;
		end
	endtask 

	task addr(input [1:0]k);
		begin 
		  @(negedge clk)
		  detect_add=1'b1;
		  data_in=k;
		  @(negedge clk)
		  detect_add=1'b0;
		end
	endtask 

	task write;
		begin
		 @(negedge clk)
		 write_enb_reg=1'b1;
		 @(negedge clk)
		 write_enb_reg=1'b0;
		end
	endtask 

	task stimulus;
		begin 
		 @(negedge clk)
		 {full_0,full_1,full_2}=3'b100;
		 @(negedge clk)
		 {empty_0,empty_1,empty_2}=3'b011;
		 @(negedge clk)
		 {read_enb_0,read_enb_1,read_enb_2}=3'b000;
		end
	endtask

	initial
		begin
			initialize;
			reset;
			addr(2'b00);
			write;
			stimulus;
			#310 $finish;

		end
endmodule 
 
  
module lights (clk, reset, sw, out);
	input logic clk, reset; 
	input logic [1:0] sw;
	output logic [2:0] out;
	
	// State variables
	// 3 leds in total, l, m, r. RL: R->L. LR: L->R
	enum { Calm_lr, L_l, L_m,  L_r } ps, ns;	
	
	// Next State logic
	always_comb begin
		case (ps)
		Calm_lr:		if (~sw[1] & ~sw[0])			ns = L_m;		// 00
						else if (~sw[1] & sw[0])		ns = L_r;		// 01
						else if (sw[1] & ~sw[0])		ns = L_l;		// 10
						else							ns = Calm_lr;	// Stay in its ps 
						
		L_m:			if (~sw[1] & ~sw[0])			ns = Calm_lr;	// 00
						else if (~sw[1] & sw[0])		ns = L_l;		// 01
						else if (sw[1] & ~sw[0])		ns = L_r;		// 10
						else							ns = L_m;		// Stay in its ps 					
				
		L_l:			if (~sw[1] & ~sw[0])			ns = Calm_lr;	// 00
						else if (~sw[1] & sw[0])		ns = L_r;		// 01
						else if (sw[1] & ~sw[0])		ns = L_m;		// 10
						else							ns = L_l;		// Stay in its ps 	

		L_r:			if (~sw[1] & ~sw[0])			ns = Calm_lr;	// 00
						else if (~sw[1] & sw[0])		ns = L_m;		// 01
						else if (sw[1] & ~sw[0])		ns = L_l;		// 10
						else							ns = L_r;		// Stay in its ps 	
						
		endcase
	end

	// Output logic - could also be another always_comb block.
	// assign out = (ps == got_two);
	
	always_comb begin
		case (ps)
			Calm_lr:		out[2] = 1;
			L_m:			out[2] = 0;
			L_l:			out[2] = 1;
			L_r:			out[2] = 0;
		endcase
			
		case (ps)
			Calm_lr:		out[1] = 0;
			L_m:			out[1] = 1;
			L_l:			out[1] = 0;
			L_r:			out[1] = 0;
		endcase
		
		case (ps)
			Calm_lr:		out[0] = 1;
			L_m:			out[0] = 0;
			L_l:			out[0] = 0;
			L_r:			out[0] = 1;
		endcase
	end
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= Calm_lr;		//Choose the reset state to Calm_lr
		else
			ps <= ns;
	end

endmodule


module lights_testbench();
	logic clk, reset;
	logic [1:0] w;
	logic [2:0] out;
	lights dut (clk, reset, w[1:0], out[2:0]);
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; 
	// Forever toggle the clock
	end

// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
													@(posedge clk);
		reset <= 1;									@(posedge clk); // Always reset FSMs at start
		reset <= 0; 	w[0] <= 0;		w[1] <= 0;	@(posedge clk);	// test Calm
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
						w[0] <= 0;		w[1] <= 1;	@(posedge clk);	// test RL.
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
						w[0] <= 1;		w[1] <= 0;	@(posedge clk);	// test LR.
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
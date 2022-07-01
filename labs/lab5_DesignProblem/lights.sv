module lights (clk, reset, sw, out);
	input logic clk, reset; 
	input logic [1:0] sw;
	output logic [2:0] out;
	
	// State variables
	// 3 leds in total, l, m, r. RL: R->L. LR: L->R
	enum { Calm_lr, Calm_m, RL_r, RL_m, RL_l, LR_l, LR_m, LR_r } ps, ns;	
	
	// Next State logic
	always_comb begin
		case (ps)
		Calm_lr:		if (~sw[0] & ~sw[1])			ns = Calm_m;
						else if (sw[0] & ~sw[1])		ns = RL_r;
						else if (~sw[0] & sw[1])		ns = LR_l;
						else							ns = Calm_lr;	// Stay in its ps 
						
		Calm_m:			if (~sw[0] & ~sw[1])			ns = Calm_lr;
						else if (sw[0] & ~sw[1])		ns = RL_l;
						else if (~sw[0] & sw[1])		ns = LR_r;
						else							ns = Calm_m;
						
		RL_r:			if (~sw[0] & ~sw[1])			ns = Calm_m;
						else if (sw[0] & ~sw[1])		ns = RL_m;
						else if (~sw[0] & sw[1])		ns = LR_l;		
						else							ns = RL_r;						
		RL_m:			if (~sw[0] & ~sw[1])			ns = Calm_m;
						else if (sw[0] & ~sw[1])		ns = RL_l;
						else if (~sw[0] & sw[1])		ns = LR_l;
						else							ns = RL_m;						
		RL_l:			if (~sw[0] & ~sw[1])			ns = Calm_m;
						else if (sw[0] & ~sw[1])		ns = RL_r;
						else if (~sw[0] & sw[1])		ns = LR_l;
						else							ns = RL_l;
						
		
		LR_l:			if (~sw[0] & ~sw[1])			ns = Calm_m;
						else if (sw[0] & ~sw[1])		ns = RL_r;
						else if (~sw[0] & sw[1])		ns = LR_m;
						else							ns = LR_l;
		LR_m:			if (~sw[0] & ~sw[1])			ns = Calm_m;
						else if (sw[0] & ~sw[1])		ns = RL_r;
						else if (~sw[0] & sw[1])		ns = LR_r;
						else							ns = LR_m;
		LR_r:			if (~sw[0] & ~sw[1])			ns = Calm_m;
						else if (sw[0] & ~sw[1])		ns = RL_r;
						else if (~sw[0] & sw[1])		ns = LR_l;
						else							ns = LR_r;
		endcase
	end

	// Output logic - could also be another always_comb block.
	// assign out = (ps == got_two);
	
	always_comb begin
		case (ps)
			Calm_lr:		out[2] = 1;
			Calm_m:			out[2] = 0;
			RL_r:			out[2] = 0;
			RL_m:			out[2] = 0;
			RL_l:			out[2] = 1;
			LR_l:			out[2] = 1;
			LR_m:			out[2] = 0;
			LR_r:			out[2] = 0;
		endcase
			
		case (ps)
			Calm_lr:		out[1] = 0;
			Calm_m:			out[1] = 1;
			RL_r:			out[1] = 0;
			RL_m:			out[1] = 1;
			RL_l:			out[1] = 0;
			LR_l:			out[1] = 0;
			LR_m:			out[1] = 1;
			LR_r:			out[1] = 0;
		endcase
		
		case (ps)
			Calm_lr:		out[0] = 1;
			Calm_m:			out[0] = 0;
			RL_r:			out[0] = 1;
			RL_m:			out[0] = 0;
			RL_l:			out[0] = 0;
			LR_l:			out[0] = 0;
			LR_m:			out[0] = 0;
			LR_r:			out[0] = 1;
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
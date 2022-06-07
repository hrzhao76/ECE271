// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	output logic [6:0]	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0]	LEDR;
	input logic [3:0]		KEY;
	input logic [9:0]		SW;
// Default values, turns off the HEX displays
//	assign HEX0 = 7'b1111111;
//	assign HEX1 = 7'b1111111;
//	assign HEX2 = 7'b1111111;
//	assign HEX3 = 7'b1111111;
//	assign HEX4 = 7'b1111111;
//	assign HEX5 = 7'b1111111;

// SW[9] for U, SW[8] for P, SW[7] for C
// LEDR[0]: Disconunted 
	assign LEDR[0] = SW[8] | ( SW[9] & SW[7]);
	
// SW[9] for U, SW[8] for P, SW[7] for C
// SW[0] for the secret mark	
// LEDR[1]: Stolen
	assign LEDR[1] = (SW[9] & ~SW[8] & ~SW[0]) | (~SW[8] & ~SW[7] & ~SW[0]);
	
	
	logic[6:0] hex[5:0]; 
//	seg7 Disconunted (.bcd(SW[3:0]), .leds(dis));
//	seg7 Stolen (.bcd(SW[7:4]), .leds(sto));
	seg7 control(.bcd(SW[9:7]), .leds(hex));
	assign HEX0 = ~hex[0];
	assign HEX1 = ~hex[1];
	assign HEX2 = ~hex[2];
	assign HEX3 = ~hex[3];
	assign HEX4 = ~hex[4];
	assign HEX5 = ~hex[5];

endmodule

module seg7 (bcd, leds);
	input logic [2:0] bcd;
	output logic [6:0] leds[5:0];
//	output logic [6:0] leds5, led4, leds3, leds2, leds1, leds0;

	// 000  SHOES
	// 001 COSJEU
	// 011 CHPOPE
	// 100 8USSU1
	// 101    CO7
	// 110  SOC1S
	always_comb begin
		case (bcd)
		//			 	  Light: 6543210
		4'b000: leds[5] = 7'b0000000; // turn off
		4'b001: leds[5] = 7'b0111001; // C
		4'b011: leds[5] = 7'b0111001; // C
		4'b100: leds[5] = 7'b1111111; // 8
		4'b101: leds[5] = 7'b0000000; // turn off
		4'b110: leds[5] = 7'b0000000; // turn off
		default: leds[5] = 7'bX;
		endcase
		
		case (bcd)
		//			 	  Light: 6543210
		4'b000: leds[4] = 7'b1101101; // S
		4'b001: leds[4] = 7'b0111111; // O
		4'b011: leds[4] = 7'b1110110; // H
		4'b100: leds[4] = 7'b0111110; // U
		4'b101: leds[4] = 7'b0000000; // turn off
		4'b110: leds[4] = 7'b1101101; // S
		default: leds[4] = 7'bX;
		endcase
		
		case (bcd)
		//			 	  Light: 6543210
		4'b000: leds[3] = 7'b1110110; // H
		4'b001: leds[3] = 7'b1101101; // S
		4'b011: leds[3] = 7'b1110011; // P
		4'b100: leds[3] = 7'b1101101; // S
		4'b101: leds[3] = 7'b0000000; // turn off
		4'b110: leds[3] = 7'b0111111; // 0
		default: leds[3] = 7'bX;
		endcase
		
		case (bcd)
		//			 	  Light: 6543210
		4'b000: leds[2] = 7'b0111111; // 0
		4'b001: leds[2] = 7'b0001111; // J
		4'b011: leds[2] = 7'b0111111; // 0
		4'b100: leds[2] = 7'b1101101; // S
		4'b101: leds[2] = 7'b0111001; // C
		4'b110: leds[2] = 7'b0111001; // C
		default: leds[2] = 7'bX;
		endcase
		
		case (bcd)
		//			 	  Light: 6543210
		4'b000: leds[1] = 7'b1111001; // E
		4'b001: leds[1] = 7'b1111001; // E
		4'b011: leds[1] = 7'b1110011; // P
		4'b100: leds[1] = 7'b0111110; // U
		4'b101: leds[1] = 7'b0111111; // 0
		4'b110: leds[1] = 7'b0000110; // 1
		default: leds[1] = 7'bX;
		endcase
		
		
		case (bcd)
		//			 	  Light: 6543210
		4'b000: leds[0] = 7'b1101101; // S
		4'b001: leds[0] = 7'b0111110; // U
		4'b011: leds[0] = 7'b1111001; // E
		4'b100: leds[0] = 7'b0000110; // 1
		4'b101: leds[0] = 7'b0000111; // 7
		4'b110: leds[0] = 7'b1101101; // S
		default: leds[0] = 7'bX;
		endcase
	end
endmodule

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR,.SW);
// Try all combinations of inputs.
	integer i;
	initial begin
		//SW[6:1] = 1'b0;
		for(i = 0; i <16; i++) begin
			{SW[9:7], SW[0]} = i; #10;
		end
	end
endmodule
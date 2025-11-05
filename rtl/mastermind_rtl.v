module switch_mon (input clk, rst, input wire SW0, SW1, SW2, SW3, output wire[3:0] switches_o);
	reg[3:0] switches;

	always@( posedge clk) begin
		if(rst) begin

		end else begin
			switches[0] <= SW0;
			switches[1] <= SW1;
			switches[2] <= SW2;
			switches[3] <= SW3;
		end
	end
	assign switches_o = switches;
endmodule //switch_mon

module led_driver(input [1:0] led_color, output red_pin_o, grn_pin_o, blu_pin_o);

	localparam RED = 2'b00;
	localparam YLW = 2'b01;
	localparam BLU = 2'b10;
	localparam GRN = 2'b11;

	reg red_pin, grn_pin, blu_pin;
	always@(*) begin
		case(led_color)
			RED: begin
				red_pin = 1;
				grn_pin = 0;
				blu_pin = 0;
			end
			YLW: begin
				red_pin = 1;
				grn_pin = 1;
				blu_pin = 0;
			end
			GRN: begin
				red_pin = 0;
				grn_pin = 1;
				blu_pin = 0;
			end
			BLU: begin
				red_pin = 0;
				grn_pin = 0;
				blu_pin = 1;
			end
			default : begin
				red_pin = 1;
				grn_pin = 1;
				blu_pin = 1;
			end
		endcase
	end

	assign red_pin_o = red_pin;
	assign grn_pin_o = grn_pin;
	assign blu_pin_o = blu_pin;
	
endmodule //led_driver

module mastermind_comb(
		input [15:0] code_i, guess_i,
		output [7:0] numbers_matched_o, positions_matched_o 
	);

	reg [3:0] a,b,c,d,w,x,y,z;
	reg a_hard, a_soft;
	reg b_hard, b_soft;
	reg c_hard, c_soft;
	reg d_hard, d_soft;

	reg[7:0] positions_matched;
	reg[7:0] numbers_matched;

	always@(*) begin
		a = code_i[15:12];
		b = code_i[11:8];
		c = code_i[7:4];
		d = code_i[3:0];

		w = guess_i[15:12];
		x = guess_i[11:8];
		y = guess_i[7:4];
		z = guess_i[3:0];
	end 

	always @(*) begin

		if(a == w) begin
			a_hard = 1;
			a_soft = 0;
		end else if((a == x) | (a == y) | (a == z)) begin
			a_hard = 0;
			a_soft = 1;
		end

		if(b == x) begin
			b_hard = 1;
			b_soft = 0;
		end else if((b == w) | (b == y) | (b == z)) begin
			b_hard = 0;
			b_soft = 1;
		end

		if(c == y) begin
			c_hard = 1;
			c_soft = 0;
		end else if((c == w) | (c == x) | (c == z)) begin
			c_hard = 0;
			c_soft = 1;
		end

		if(d == z) begin
			d_hard = 1;
			d_soft = 0;
		end else if((d == w) | (d == x) | (d == y)) begin
			d_hard = 0;
			d_soft = 1;
		end
	end

	always@(*) begin
		positions_matched = a_hard + b_hard + c_hard + d_hard;
		numbers_matched	= a_soft + b_soft + c_soft + d_soft;
	end

	assign positions_matched_o = positions_matched;
	assign numbers_matched_o 	= numbers_matched;
endmodule //mastermind_comb

module color_coder(input [7:0] numbers_matched_i, positions_matched_i, output [1:0] led_0_color_o, led_1_color_o, led_2_color_o, led_3_color_o);

	localparam RED = 2'b00;
	localparam YLW = 2'b01;
	localparam BLU = 2'b10;
	localparam GRN = 2'b11;

	reg [1:0] led_0_color,led_1_color,led_2_color,led_3_color;

	always@(*) begin
		case({numbers_matched_i,positions_matched_i})
	
			//no yellow
			16'h0000: begin
				led_0_color = RED;
				led_1_color = RED;
				led_2_color = RED;
				led_3_color = RED;
			end
	 		16'h0001: begin
				led_0_color = GRN;
				led_1_color = RED;
				led_2_color = RED;
				led_3_color = RED;
			end
	 		16'h0002: begin
				led_0_color = GRN;
				led_1_color = GRN;
				led_2_color = RED;
				led_3_color = RED;
			end
	 		16'h0003: begin
				led_0_color = GRN;
				led_1_color = GRN;
				led_2_color = GRN;
				led_3_color = RED;
			end
	 		16'hxx04: begin
				led_0_color = GRN;
				led_1_color = GRN;
				led_2_color = GRN;
				led_3_color = GRN;
			end
			//1 yellow
			16'h0100: begin
				led_0_color = YLW;
				led_1_color = RED;
				led_2_color = RED;
				led_3_color = RED;
			end
	 		16'h0101: begin
				led_0_color = GRN;
				led_1_color = YLW;
				led_2_color = RED;
				led_3_color = RED;
			end
	 		16'h0102: begin
				led_0_color = GRN;
				led_1_color = GRN;
				led_2_color = YLW;
				led_3_color = RED;
			end
	 		16'h0103: begin
				led_0_color = GRN;
				led_1_color = GRN;
				led_2_color = GRN;
				led_3_color = YLW;
			end
			//2 yellow
			16'h0200: begin
				led_0_color = YLW;
				led_1_color = YLW;
				led_2_color = RED;
				led_3_color = RED;
			end
	 		16'h0201: begin
				led_0_color = GRN;
				led_1_color = YLW;
				led_2_color = YLW;
				led_3_color = RED;
			end
	 		16'h0202: begin
				led_0_color = GRN;
				led_1_color = GRN;
				led_2_color = YLW;
				led_3_color = YLW;
			end
			//3 yellow
			16'h0300: begin
				led_0_color = YLW;
				led_1_color = YLW;
				led_2_color = YLW;
				led_3_color = RED;
			end
	 		16'h0301: begin
				led_0_color = GRN;
				led_1_color = YLW;
				led_2_color = YLW;
				led_3_color = YLW;
			end
			//4 yellow
			16'h0400: begin
				led_0_color = YLW;
				led_1_color = YLW;
				led_2_color = YLW;
				led_3_color = YLW;
			end
	
			default: begin
				led_0_color = BLU;
				led_1_color = BLU;
				led_2_color = BLU;
				led_3_color = BLU;
			end
	
		endcase //positions_matched
	end
endmodule

module guess_generator(input clk, rst, input [3:0] switches, output [15:0] guess_o);

	reg [15:0] cntr;
	reg [3:0] w,x,y,z;

	always@(posedge clk ) begin

		if(rst)
			cntr = '0;
		else
			cntr = cntr + 1;

		if(cntr == 16'hffff) begin
			if(switches[0])
				w = w + 1;
			if(switches[1])
				x = x + 1;
			if(switches[2])
				y = y + 1;
			if(switches[3])
				z = z + 1;
		end
	end

	assign guess_o = {w,x,y,z};
endmodule
`include "seven_seg_driver.v"

module mastermind_top(
		input [3:0] SW, 
		input PB, 
		input clk, 
		input rst, 
		output [2:0] led0,led1,led2,led3, 
		output lock
	);

	reg [15:0] code;

	wire [3:0] switches;
	wire[15:0] guess;
	wire r0,g0,b0;
	wire r1,g1,b1;
	wire r2,g2,b2;
	wire r3,g3,b3;
	wire [1:0] led_0_color,led_1_color,led_2_color,led_3_color;
	wire [15:0] numbers_matched, positions_matched;

	switch_mon switch_m(clk,rst, SW[0],SW[1],SW[2],SW[3], switches);
	guess_generator gg(clk, rst, switches,guess);
	led_driver led_drv_0(led_0_color, r0,g0,b0);
	led_driver led_drv_1(led_1_color, r1,g1,b1);
	led_driver led_drv_2(led_2_color, r2,g2,b2);
	led_driver led_drv_3(led_3_color, r3,g3,b3);
	
	seven_segment_driver ssd0(clk,rst,{4'h0,guess[15:12]},symbol_0);
	seven_segment_driver ssd1(clk,rst,{4'h0,guess[11:8]}, symbol_1);
	seven_segment_driver ssd2(clk,rst,{4'h0,guess[7:4]},  symbol_2);
	seven_segment_driver ssd3(clk,rst,{4'h0,guess[3:0]},  symbol_3);

	mastermind_comb mm_c(code, guess, numbers_matched, positions_matched);

	color_coder c(numbers_matched, positions_matched,led_0_color,led_1_color,led_2_color,led_3_color);

endmodule

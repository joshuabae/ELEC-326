`timescale 1ns/1ns

/*
 * Module: calculator
 * Description: The top module of this lab 
 */
module calculator(
	input CLK,
	input [7:0] SW,
	input [3:0] BTN,
	output [7:0] LED,
	output [6:0] SEG,
	output DP,
	output [3:0] AN
); 
	
	reg [15:0] display_num;
	wire [15:0] counter;
	wire clk_en;
	
	// STEP 2 - implement the calculator logic here
	
	
	// END STEP 2
	
	assign LED = display_num[7:0];
	
	clkdiv #(.SIZE(10)) Iclkdiv (
		.clk_pi(CLK),
		.clk_en_po(clk_en));
	
	increment Iincrement (
		.clk_pi(CLK),
		.counter_po(counter)
	);
	
	sevenSegDisplay IsevenSegDisplay (
		.clk_pi(CLK),
		.clk_en_pi(clk_en),
		.num_pi(display_num),
		.seg_po(SEG),
		.dp_po(DP),
		.an_po(AN));
		

endmodule // calculator



/* 
 * Module: segmentFormatter
 * 
 * Description: Combinational logic for the seven segment bits of a digit of the seven segment display
 *
 * 0 - LSB of disp_po
 * 6 - MSB of disp_po
 *      --(0)   
 * (5)|      |(1)
 *      --(6)
 * (4)|      |(2)
 *      --(3) 
 * 
 * disp_po is active low 
 */
module segmentFormatter(
	input [3:0] num_pi,
	output reg [6:0] disp_po
);
	
// STEP 1: Implement the segmentFormatter module


// END STEP 1
endmodule // segmentFormatter

/*
 * Module: sevenSegDisplay
 * Description: Formats an input 16 bit number for the four digit seven-segment display
 */
module sevenSegDisplay(
	input clk_pi,
	input clk_en_pi,
	input[15:0] num_pi,
	output reg [6:0] seg_po,
	output dp_po,
	output reg [3:0] an_po
);
	
	wire [6:0] disp0, disp1, disp2, disp3;
	
	assign dp_po = 1'b1;
	
	
	segmentFormatter IsegmentFormat0 ( .num_pi(num_pi[3:0]),   .disp_po(disp0));
	segmentFormatter IsegmentFormat1 ( .num_pi(num_pi[7:4]),   .disp_po(disp1));
	segmentFormatter IsegmentFormat2 ( .num_pi(num_pi[11:8]),  .disp_po(disp2));
	segmentFormatter IsegmentFormat3 ( .num_pi(num_pi[15:12]), .disp_po(disp3));
	
	initial begin
		seg_po <= 7'h7F;
		an_po <= 4'b1111;
	end
	
	always @(posedge clk_pi) begin
		if(clk_en_pi) begin
			case(an_po) 
				4'b1110: begin
					seg_po <= disp1;
					an_po  <= 4'b1101;
				end
				4'b1101: begin
					seg_po <= disp2;
					an_po  <= 4'b1011;
				end
				4'b1011: begin
					seg_po <= disp3;
					an_po  <= 4'b0111;
				end
				default: begin
					seg_po <= disp0;
					an_po <= 4'b1110;
				end
			endcase
		end // clk_en
	end // always @(posedge clk_pi)
endmodule // sevenSegDisplay


/*
 * Module: clkdiv
 * Description: Generates a clk_en signal that can be used to effectively divide the clock used elsewhere
 *              The seven segment display is not particularly visible with the full 50Mhz clock
 *
 * Parameterized to experiment with different clock frequencies for the display
 */
module clkdiv (
	input clk_pi,
	output clk_en_po
);
	
	parameter SIZE = 8;
	
	reg [SIZE-1:0] counter;
		
	initial begin
		counter <= 0;
	end
	
	always @(posedge clk_pi) begin
		counter = counter + 1;
	end
	
	assign clk_en_po = (counter == {SIZE{1'b0}}); 
	
endmodule // clkdiv


/*
 * Module: increment
 * Description: Constantly increments a sixteen bit number 
 */
module increment (
	input clk_pi,
	output [15:0] counter_po
);
	localparam SIZE = 40;

	reg [SIZE:0] count;
	
	always @(posedge clk_pi) begin
		count = count+1;
	end
	
	assign counter_po = count[SIZE:SIZE-15];

endmodule // increment

	
 
`timescale 1ns/1ns

/*
 * Module: calculator
 * Description: The top module of this lab 
 */
module calculator(
	input CLK, // onboard 50Mhz clock 
	input [7:0] SW, // the eight board switches 
	input [3:0] BTN, // four board push buttons 
	output [7:0] LED, // eight board LEDs
	output [6:0] SEG,
	output DP,
	output [3:0] AN
); 
 
	wire [15:0] display_num; //TODO: Change back to reg
	wire [15:0] counter;
	wire clk_en;
	
	assign display_num = {8’h00, SW};
	// STEP 2 - implement the calculator logic here 
        always@(*) begin 
			/*
			casez(BTN)
        	4'b0000 : display_num = SW;
        	4'b1000 : display_num = SW[7:4]+SW[3:0];      
        	4'b0100 : display_num = SW[7:4]*SW[3:0];
        	4'b0010 : display_num = SW[7:4]^SW[3:0];
        	//4'b0001 : display_num =  ;
        	4'b???? : display_num = counter;
			*/
        end

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

always @(*) begin
		case(num_pi)                //6543210
		4'b0000:	disp_po[6:0] = ~7'b0111111; //0
		4'b0001:	disp_po[6:0] = ~7'b0000110; //1
		4'b0010:	disp_po[6:0] = ~7'b1011011; //2
		4'b0011:	disp_po[6:0] = ~7'b1001111; //3
		4'b0100:	disp_po[6:0] = ~7'b1100110; //4
		4'b0101:	disp_po[6:0] = ~7'b1101101; //5
		4'b0110:	disp_po[6:0] = ~7'b1111101; //6
		4'b0111:	disp_po[6:0] = ~7'b0000111; //7
		4'b1000:	disp_po[6:0] = ~7'b1111111; //8
		4'b1001:	disp_po[6:0] = ~7'b1100111; //9
		4'b1010:	disp_po[6:0] = ~7'b1110111; //10 - A
		4'b1011:	disp_po[6:0] = ~7'b1111100; //11 - B
		4'b1100:	disp_po[6:0] = ~7'b0111001; //12 - C
		4'b1101:	disp_po[6:0] = ~7'b1011110; //13 - D
		4'b1110:	disp_po[6:0] = ~7'b1111001; //14 - E
		4'b1111:	disp_po[6:0] = ~7'b1110001; //15 - F
		endcase

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

	
 

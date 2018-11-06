    `timescale 1ns / 100ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 10/17/2016 06:16:54 PM
    // Design Name: 
    // Module Name: sim1
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////
    
    //module processor ( input CLK, input [7:0] SW, input [3:0] BTN, output [7:0] LED, output [6:0] SEG,
    //      	output DP, output [7:0] AN );
    
 module sim1();
    reg CLK;
    
    reg [7:0] SW;
    reg [4:0] BTN; //I think we had to change this to four, but it wasn't working so unsure of what's going on.
	reg CPU_RESETN;
    wire [7:0] LED;
    wire [6:0] SEG;
    wire DP;
    wire [7:0] AN;
    
    //  Inistiantiate the alarm_clock
    processor test_processor(.CLK (CLK), .SW (SW), .BTN (BTN), .CPU_RESETN (CPU_RESETN) , .LED (LED), .SEG (SEG), .DP (DP), .AN (AN));

    //this process block sets up the free running clock
    initial begin
        CLK = 0;
		CPU_RESETN = 1'b1;
        forever #5 CLK = ~CLK;
    end

    initial begin// this process block specifies the stimulus.
        SW = 8'b11110011;
        BTN = 4'b0000;
        #200000
        SW = 8'b11000010;	
     
    end
    
    initial begin// this process block pipes the ASCII results to the
        //terminal or text editor
        //$timeformat(-9,1,"ns",12);
        //$display(" Time Clk Rst Ld SftRg Data Sel");
        //$monitor("%t %b %b %b %b %b %b", $realtime,
        //clock, reset, load, shiftreg, data, sel);
    end
    
endmodule

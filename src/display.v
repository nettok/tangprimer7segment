module display(
	input wire clk,
	input wire user_btn,
	output wire [2:0] rgb_led,
		
	output wire digit1,
	output wire digit2,
	output wire digit3,
	output wire digit4,
	
	output wire segmentA,
	output wire segmentB,
	output wire segmentC,
	output wire segmentD,
	output wire segmentE,
	output wire segmentF,
	output wire segmentG
);

	localparam fivemillis = 'd120_000;	// Clock is 24Mhz
	
	localparam num_0 = 7'b1111110;
	localparam num_1 = 7'b0110000;
	localparam num_2 = 7'b1101101;
	localparam num_3 = 7'b1111001;
	localparam num_4 = 7'b0110011;
	localparam num_5 = 7'b1011011;
	localparam num_6 = 7'b1011111;
	localparam num_7 = 7'b1110000;
	localparam num_8 = 7'b1111111;
	localparam num_9 = 7'b1110011;
		
	reg [19:0] count;
	reg [3:0] digit_selector;
	reg [6:0] digit_out;
	
	assign rgb_led = 3'b111;
	assign {digit1, digit2, digit3, digit4} = ~digit_selector;
	assign {segmentA, segmentB, segmentC, segmentD, segmentE, segmentF, segmentG} = digit_out;

	always @(posedge clk) begin
		if (user_btn == 0) begin
			count <= 0;
			digit_selector <= 4'b0001;
			digit_out <= 7'b0000000;
		end
		if (count == fivemillis) begin
			count <= 0;
			digit_selector <= {digit_selector[2:0], digit_selector[3]};
		end
		else if (count == 1) begin
			case (digit_selector)
				4'b1000 : digit_out <= num_1;
				4'b0100 : digit_out <= num_2;
				4'b0010 : digit_out <= num_3;				
				4'b0001 : digit_out <= num_4;				
			endcase
			count <= count + 1;
		end
		else begin
			count <= count + 1;
		end
	end
endmodule

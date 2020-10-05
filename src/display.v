module display(
	input wire clk,
	input wire user_btn,
	output wire [2:0] rgb_led,
		
	output wire digit_anode1,
	output wire digit_anode2,
	output wire digit_anode3,
	output wire digit_anode4,
	
	output wire segmentA,
	output wire segmentB,
	output wire segmentC,
	output wire segmentD,
	output wire segmentE,
	output wire segmentF,
	output wire segmentG
);
	// Clock is 24Mhz
	localparam five_millis = 'd120_000;
	localparam one_second = 'd24_000_000;
	
	// Counter
	
	reg [27:0] one_second_timer;
	reg [19:0] counter;
	
	always @(posedge clk) begin
		if (user_btn == 0) begin
			counter <= 0;
		end
		if (one_second_timer == one_second) begin
			one_second_timer <= 0;
			if (counter == 10_000) counter <= 0;
			else counter <= counter + 1;
		end
		else one_second_timer <= one_second_timer + 1;
	end
	
	wire [3:0] counter_digit_thousands;
	wire [3:0] counter_digit_cents;
	wire [3:0] counter_digit_tens;
	wire [3:0] counter_digit_ones;
	
	assign counter_digit_thousands = counter >= 'd1000 ? counter / 'd1000 % 'd10 : 0;
	assign counter_digit_cents = counter >= 'd100 ? counter / 'd100 % 'd10 : 0;
	assign counter_digit_tens = counter >= 'd10 ? counter / 'd10 % 'd10 : 0;
	assign counter_digit_ones = counter >= 'd1 ? counter / 'd1 % 'd10 : 0;
	
	wire [6:0] digit1_out;
	wire [6:0] digit2_out;
	wire [6:0] digit3_out;
	wire [6:0] digit4_out;
	
	decimal_to_7segment_digit digit1_converter (counter_digit_thousands, digit1_out);
	decimal_to_7segment_digit digit2_converter (counter_digit_cents, digit2_out);
	decimal_to_7segment_digit digit3_converter (counter_digit_tens, digit3_out);
	decimal_to_7segment_digit digit4_converter (counter_digit_ones, digit4_out);
	
	// Display
		
	reg [19:0] display_timer;
	reg [3:0] digit_selector;
	reg [6:0] segments_out;
	
	assign rgb_led = 3'b111;
	assign {digit_anode1, digit_anode2, digit_anode3, digit_anode4} = ~digit_selector;
	assign {segmentA, segmentB, segmentC, segmentD, segmentE, segmentF, segmentG} = segments_out;

	always @(posedge clk) begin
		if (user_btn == 0) begin
			display_timer <= 0;
			digit_selector <= 4'b0001;
			segments_out <= 7'b0000000;
		end
		if (display_timer == five_millis) begin
			display_timer <= 0;
			digit_selector <= {digit_selector[2:0], digit_selector[3]};
		end
		else if (display_timer == 1) begin
			case (digit_selector)
				4'b1000 : segments_out <= digit1_out;
				4'b0100 : segments_out <= digit2_out;
				4'b0010 : segments_out <= digit3_out;
				4'b0001 : segments_out <= digit4_out;
			endcase
			display_timer <= display_timer + 1;
		end
		else display_timer <= display_timer + 1;
	end
endmodule

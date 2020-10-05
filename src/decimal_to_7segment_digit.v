module decimal_to_7segment_digit(
	input [3:0] decimal,
	output [6:0] segments
);

	localparam num0 = 7'b1111110;
	localparam num1 = 7'b0110000;
	localparam num2 = 7'b1101101;
	localparam num3 = 7'b1111001;
	localparam num4 = 7'b0110011;
	localparam num5 = 7'b1011011;
	localparam num6 = 7'b1011111;
	localparam num7 = 7'b1110000;
	localparam num8 = 7'b1111111;
	localparam num9 = 7'b1110011;
	
	localparam error = 7'b1001111;
	
	reg [6:0] segments_out;
	
	assign segments = segments_out;

	always @ (decimal) begin
		case (decimal)
			4'd0 : segments_out <= num0;
			4'd1 : segments_out <= num1;
			4'd2 : segments_out <= num2;
			4'd3 : segments_out <= num3;
			4'd4 : segments_out <= num4;
			4'd5 : segments_out <= num5;
			4'd6 : segments_out <= num6;
			4'd7 : segments_out <= num7;
			4'd8 : segments_out <= num8;
			4'd9 : segments_out <= num9;
			default : segments_out <= error;
		endcase
	end

endmodule

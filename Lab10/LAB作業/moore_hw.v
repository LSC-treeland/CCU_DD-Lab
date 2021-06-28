module moore_hw( input clk,
				 input reset,
				 input x,
				 output reg y );
		
	reg [2:0] current_state, next_state;
	
	parameter S0 = 3'd0;
	parameter S1 = 3'd1;
	parameter S2 = 3'd2; 
	parameter S3 = 3'd3;
	parameter S4 = 3'd4;
	parameter S5 = 3'd5;
	
	always@(*) begin
		case(current_state)
			S0:
				if(x) begin
					next_state = S1;
				end
				else begin
					next_state = S0;
				end
			S1:
				if(x) begin
					next_state = S1;
				end
				else begin
					next_state = S2;
				end
			S2:
				if(x) begin
					next_state = S1;
				end
				else begin
					next_state = S3;
				end
			S3:
				if(x) begin
					next_state = S4;
				end
				else begin
					next_state = S0;
				end
			S4:
				if(x) begin
					next_state = S1;
				end
				else begin
					next_state = S5;
				end
			S5:
				if(x) begin
					next_state = S1;
				end
				else begin
					next_state = S3;
				end
			default:
				next_state = S0;
		endcase
	end

	always@(posedge clk) begin
		if(reset) begin
			current_state <= S0;
		end
		else begin
			current_state <= next_state;
		end
	end

	always@(*) begin
		case(current_state)
			S0:
				y = 1'b0;
			S1:
				y = 1'b0;
			S2:
				y = 1'b0;
			S3:
				y = 1'b0;
			S4:
				y = 1'b0;
			S5:
				y = 1'b1;
			default:
				y = 1'b0;
		endcase
	end
		
endmodule
		
	
	
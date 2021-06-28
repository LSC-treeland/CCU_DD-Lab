module mealy_hw( input clk,
			  input reset,
			  input x,
			  output reg y );
		
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010 ,S3 = 3'b011,S4 = 3'b100;
	reg [2:0] current_state, next_state;
	reg y_temp;
	
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
					next_state = S2;
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
				if(x) begin
					y_temp = 1'b0;
				end
				else begin
					y_temp = 1'b0;
				end
			S1:
				if(x) begin
					y_temp = 1'b0;
				end
				else begin
					y_temp = 1'b0;
				end
			S2:
				if(x) begin
					y_temp = 1'b0;
				end
				else begin
					y_temp = 1'b0;
				end
			S3:
				if(x) begin
					y_temp = 1'b0;
				end
				else begin
					y_temp = 1'b0;
				end
			S4:
				if(x) begin
					y_temp = 1'b0;
				end
				else begin
					y_temp = 1'b1;
				end
			default:
				y_temp = 1'b0;
		endcase
	end
		
	always@(posedge clk) begin
		if(reset) begin
			y <= 1'b0;
		end
		else begin	
			y <= y_temp;
		end
	end
		
endmodule
		
	
	
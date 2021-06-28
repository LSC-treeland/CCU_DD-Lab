module top(
	clk,
	rst,
    sw,
	CA,
	CB,
	CC,
	CD,
	CE,
	CF,
	CG,
	AN0,
	AN1,
	AN2,
	AN3,
	AN4,
	AN5,
	AN6,
	AN7
    );
    
input clk,rst;
input [11:0]sw;
output CA,CB,CC,CD,CE,CF,CG;
output AN0,AN1,AN2,AN3,AN4,AN5,AN6,AN7;

wire [5:0]num1;
wire [5:0]num2;
wire [6:0]sum;
reg [2:0] state;
reg [6:0] seg_number,seg_data;
reg [20:0] counter;
reg [7:0] scan;

assign num1 = sw[11:6];
assign num2 = sw[5:0]; 
assign sum = num1+num2; 

assign {AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0} = scan;
always@(posedge clk) begin
  counter <=(counter<=100000) ? (counter +1) : 0;
  state <= (counter==100000) ? (state + 1) : state;
	case(state)
		0:begin// 負向個位數
			seg_number <= sum%10 +10 ;//+10代表負向 下方case會做判斷
			scan <= 8'b0111_1111;//顯示AN7
		end
		1:begin// 負向十位數
			seg_number <= (sum / 10 ) % 10 +10 ;//+10代表負向 下方case會做判斷
			scan <= 8'b1011_1111;//顯示AN6
		end
		2:begin// 負向百位數
			seg_number <= (sum / 100 ) % 10 +10 ;//+10代表負向 下方case會做判斷
			scan <= 8'b1101_1111;//顯示AN5
		end
		3:begin// 負向千位數
			seg_number <= sum / 1000 +10 ;//+10代表負向 下方case會做判斷
			scan <= 8'b1110_1111;//顯示AN4
		end
		4:begin// 正向千位數
			seg_number <= sum/1000;
			scan <= 8'b1111_0111;//顯示AN3
		end
		5:begin// 正向百位數
			seg_number <= (sum/100) % 10;
			scan <= 8'b1111_1011;//顯示AN2
		end
		6:begin// 正向十位數
			seg_number <= (sum/10) % 10;
			scan <= 8'b1111_1101;//顯示AN1
		end
		7:begin// 正向個位數
			seg_number <= sum % 10;
			scan <= 8'b1111_1110;//顯示AN0
		end
		default: state <= state;
	endcase 
end  


assign {CG,CF,CE,CD,CC,CB,CA} = seg_data;

//----CA-----
//CF         CB
//\----CG---|
//CE         CC
// |--CD----|
//0 is turn on, 1 is turn off

always@(posedge clk) begin  
  //正向顯示
  case(seg_number)
	16'd0:seg_data <= 7'b100_0000;// 0  CG 不顯示
	16'd1:seg_data <= 7'b111_1001;// 1  只顯示CB和CC
	16'd2:seg_data <= 7'b010_0100;// 2  不顯示CC和CF
	16'd3:seg_data <= 7'b011_0000;// 3  不顯示CE和CF
	16'd4:seg_data <= 7'b001_1001;// 4  不顯示CA和CD和CE
	16'd5:seg_data <= 7'b001_0010;// 5  不顯示CB和CE
	16'd6:seg_data <= 7'b000_0010;// 6  不顯示CB
	16'd7:seg_data <= 7'b101_1000;// 7  不顯示CD和CE和CG
	16'd8:seg_data <= 7'b000_0000;// 8  全turn on
	16'd9:seg_data <= 7'b001_0000;// 9  不顯示CE
	
	//鏡向表示
	16'd10:seg_data <= 7'b100_0000;// 鏡像0 同正向0  CG 不顯示
	16'd11:seg_data <= 7'b100_1111;// 鏡像1  只顯示CF和CE
	16'd12:seg_data <= 7'b001_0010;// 鏡像2  同正向5 不顯示CB和CE
	16'd13:seg_data <= 7'b000_0110;// 鏡像3  不顯示CB和CC
	16'd14:seg_data <= 7'b000_1101;// 鏡像4  不顯示CA和CC和CD
	16'd15:seg_data <= 7'b010_0100;// 鏡像5   同正向2 不顯示CC和CF
	16'd16:seg_data <= 7'b010_0000;// 鏡像6  不顯示CF
	16'd17:seg_data <= 7'b100_1100;// 鏡像7  不顯示CC和CD和CG
	16'd18:seg_data <= 7'b000_0000;// 鏡像8 同正向8  全turn on
	16'd19:seg_data <= 7'b000_0100;// 鏡像9  不顯示CC
	default: seg_number <= seg_number;
  endcase
  
end 

endmodule
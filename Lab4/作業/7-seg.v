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
		0:begin// �t�V�Ӧ��
			seg_number <= sum%10 +10 ;//+10�N��t�V �U��case�|���P�_
			scan <= 8'b0111_1111;//���AN7
		end
		1:begin// �t�V�Q���
			seg_number <= (sum / 10 ) % 10 +10 ;//+10�N��t�V �U��case�|���P�_
			scan <= 8'b1011_1111;//���AN6
		end
		2:begin// �t�V�ʦ��
			seg_number <= (sum / 100 ) % 10 +10 ;//+10�N��t�V �U��case�|���P�_
			scan <= 8'b1101_1111;//���AN5
		end
		3:begin// �t�V�d���
			seg_number <= sum / 1000 +10 ;//+10�N��t�V �U��case�|���P�_
			scan <= 8'b1110_1111;//���AN4
		end
		4:begin// ���V�d���
			seg_number <= sum/1000;
			scan <= 8'b1111_0111;//���AN3
		end
		5:begin// ���V�ʦ��
			seg_number <= (sum/100) % 10;
			scan <= 8'b1111_1011;//���AN2
		end
		6:begin// ���V�Q���
			seg_number <= (sum/10) % 10;
			scan <= 8'b1111_1101;//���AN1
		end
		7:begin// ���V�Ӧ��
			seg_number <= sum % 10;
			scan <= 8'b1111_1110;//���AN0
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
  //���V���
  case(seg_number)
	16'd0:seg_data <= 7'b100_0000;// 0  CG �����
	16'd1:seg_data <= 7'b111_1001;// 1  �u���CB�MCC
	16'd2:seg_data <= 7'b010_0100;// 2  �����CC�MCF
	16'd3:seg_data <= 7'b011_0000;// 3  �����CE�MCF
	16'd4:seg_data <= 7'b001_1001;// 4  �����CA�MCD�MCE
	16'd5:seg_data <= 7'b001_0010;// 5  �����CB�MCE
	16'd6:seg_data <= 7'b000_0010;// 6  �����CB
	16'd7:seg_data <= 7'b101_1000;// 7  �����CD�MCE�MCG
	16'd8:seg_data <= 7'b000_0000;// 8  ��turn on
	16'd9:seg_data <= 7'b001_0000;// 9  �����CE
	
	//��V���
	16'd10:seg_data <= 7'b100_0000;// �蹳0 �P���V0  CG �����
	16'd11:seg_data <= 7'b100_1111;// �蹳1  �u���CF�MCE
	16'd12:seg_data <= 7'b001_0010;// �蹳2  �P���V5 �����CB�MCE
	16'd13:seg_data <= 7'b000_0110;// �蹳3  �����CB�MCC
	16'd14:seg_data <= 7'b000_1101;// �蹳4  �����CA�MCC�MCD
	16'd15:seg_data <= 7'b010_0100;// �蹳5   �P���V2 �����CC�MCF
	16'd16:seg_data <= 7'b010_0000;// �蹳6  �����CF
	16'd17:seg_data <= 7'b100_1100;// �蹳7  �����CC�MCD�MCG
	16'd18:seg_data <= 7'b000_0000;// �蹳8 �P���V8  ��turn on
	16'd19:seg_data <= 7'b000_0100;// �蹳9  �����CC
	default: seg_number <= seg_number;
  endcase
  
end 

endmodule
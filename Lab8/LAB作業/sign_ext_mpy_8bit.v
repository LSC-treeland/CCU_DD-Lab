module MPY(clk,a, b, p);
    input [7:0] a, b;
	input clk;
    output [15:0] p;
    wire [8:0] add[7:0] ;
    wire [15:0] add_ext[7:0];
	
    booth_add booth1(a, {b[0],1'b0}, add[0]);
    booth_add booth2(a, b[1:0], add[1]);
    booth_add booth3(a, b[2:1], add[2]);
    booth_add booth4(a, b[3:2], add[3]);
	booth_add booth5(a, b[4:3], add[4]);
	booth_add booth6(a, b[5:4], add[5]);
	booth_add booth7(a, b[6:5], add[6]);
	booth_add booth8(a, b[7:6], add[7]);

    assign add_ext[0] = {{7{add[0][8]}}, add[0]};
    assign add_ext[1] = {{6{add[1][8]}}, add[1], 1'b0};
	assign add_ext[2] = {{5{add[2][8]}}, add[2], 2'b0};
	assign add_ext[3] = {{4{add[3][8]}}, add[3], 3'b0};
	assign add_ext[4] = {{3{add[4][8]}}, add[4], 4'b0};
	assign add_ext[5] = {{2{add[5][8]}}, add[5], 5'b0};
	assign add_ext[6] = {{1{add[6][8]}}, add[6], 6'b0};
	assign add_ext[7] = { add[7], 7'b0};
	
    assign p = add_ext[0] + add_ext[1] + add_ext[2] + add_ext[3] + add_ext[4] + add_ext[5] + add_ext[6] + add_ext[7];
endmodule

module booth_add(a, b, ab);
    input [7:0] a;
    input [1:0] b;
    wire signed [8:0] a_ext;
    output [8:0] ab;

    assign a_ext = {a[7],a};
    assign ab = (b==2'b01) ? a_ext:
                (b==2'b10) ? -a_ext:
                             33'b0;                                
endmodule
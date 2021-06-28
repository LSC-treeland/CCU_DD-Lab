`timescale 1ns/1ps

module RCA_16bit(a,b,cin,sum,cout);

    input [15:0] a,b;
    input cin;
    output [15:0] sum;
    output cout;
    wire [14:0] c;
	// --- Write down your design here --- //
	fulladder FA1(a[0],b[0],cin,sum[0],c[0]);
	fulladder FA2(a[1],b[1],c[0],sum[1],c[1]);
	fulladder FA3(a[2],b[2],c[1],sum[2],c[2]);
	fulladder FA4(a[3],b[3],c[2],sum[3],c[3]);
	fulladder FA5(a[4],b[4],c[3],sum[4],c[4]);
	fulladder FA6(a[5],b[5],c[4],sum[5],c[5]);
	fulladder FA7(a[6],b[6],c[5],sum[6],c[6]);
	fulladder FA8(a[7],b[7],c[6],sum[7],c[7]);
	fulladder FA9(a[8],b[8],c[7],sum[8],c[8]);
	fulladder FA10(a[9],b[9],c[8],sum[9],c[9]);
	fulladder FA11(a[10],b[10],c[9],sum[10],c[10]);
	fulladder FA12(a[11],b[11],c[10],sum[11],c[11]);
	fulladder FA13(a[12],b[12],c[11],sum[12],c[12]);
	fulladder FA14(a[13],b[13],c[12],sum[13],c[13]);
	fulladder FA15(a[14],b[14],c[13],sum[14],c[14]);
	fulladder FA16(a[15],b[15],c[14],sum[15],cout);
	// ----------------------------------- //

endmodule

// FA module
module fulladder(a,b,cin,sum,cout);
	
	input a, b, cin;
	output sum,cout;
	wire x,y,z;

	// --- Write down your design here --- //
	xorgate xor1(a,b,x);
	xorgate xor2(x,cin,sum);
	andgate and2(a,b,y);
	andgate and1(x,cin,z);
	orgate or2(y,z,cout);
	// ----------------------------------- //

endmodule


// xor gate
module xorgate (a,b,out);
	
	input a,b;
	output out;
	wire x,y,z;

	// --- Write down your design here --- //
	andgate and1 (a,~b,x);
	andgate and2 (~a,b,y);
	orgate or1 (x,y,out);
	// ----------------------------------- //


endmodule



// and gate
module andgate (a,b,out);
	
	input a, b;
	output reg out;

	always @ (*)  begin
		#10 out <= a & b; // #10ns 為 and gate's gate delay
	end

endmodule

// or gate
module orgate (a,b,out);
	
	input a, b;
	output reg out;

	always @ (*)  begin
		#4 out <= a | b; // #4ns 為 or gate's gate delay
	end

endmodule
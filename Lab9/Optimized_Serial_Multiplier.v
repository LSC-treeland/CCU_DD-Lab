//以前者(1ns)為單位，以後者(1ps)的時間，查看一次電路的行為
`timescale 1ns/1ps

//宣告module名稱,輸出入名稱
module lab9_hw(
	CLK, 
	RST, 
	in_a, 
	in_b, 
	Product, 
	Product_Valid
);
// in_a * in_b = Product
// in_a is Multiplicand , in_b is Multiplier
					
//定義port, 包含input, output
input 			CLK, RST;
input 	[7:0]	in_a;			// Multiplicand
input 	[7:0]	in_b;			// Multiplier
output 	[15:0]  Product;
output  		Product_Valid;

reg 	[7:0]	Mplicand;		//被乘數
reg 	[15:0]	Product;
reg 			Product_Valid;
reg 	[5:0]	Counter ;
reg				sign;	//isSigned

//Counter
always @(posedge CLK or posedge RST)
begin
	if (RST)
		Counter <= 6'b0;
	else
		Counter <= Counter + 6'b1;
end

//Product
always @(posedge CLK or posedge RST)
begin
	//初始化數值
	if (RST) begin
		Product  = 16'b0;
		Mplicand = 8'b0;
		
		sign <= (in_a[7]) ^ (in_b[7]);
	end

	//輸入結果與被乘數
	else if (Counter == 6'd0  ) begin
		if ((in_a[7] == 1'b1) )
			Mplicand 	<= ~in_a+8'b1;
		else
			Mplicand 	<= in_a;
			
		if ((in_b[7] == 1'b1) ) 
			Product	 	<= {8'b0, ~in_b+8'b1};
		else
			Product	 	<= {8'b0, in_b};

	end
	
	//乘法與數值移位
	else if (Counter <= 6'd8  )begin
		
		if (Product[0] == 1'b1) begin
			Product 	<= {Mplicand,8'b0} + Product >> 1'b1  ;
		end
		else 
			Product     <= Product >> 1'b1;

	end
	
	//給定結果正負號
	//當計算到最後一次的時候
	else begin
		if (sign == 1'b1) begin
			Product 	<= ~Product+1'b1  ;
			sign <= 1'b0;
		end
		else begin
			Product 	<= Product ;	
		end
		Mplicand	<= Mplicand;	
		
	end
end

//Product_Valid
always @(posedge CLK or posedge RST)
begin
	if (RST)
		Product_Valid <=1'b0;
	else if (Counter==6'd17)
		Product_Valid <=1'b1;
	else
		Product_Valid <=1'b0;
end

endmodule

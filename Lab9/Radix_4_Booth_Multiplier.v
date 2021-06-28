
`timescale 1ns/1ps

module lab(
	CLK, 
	RST,
	en,
	in_a, 
	in_b, 
	Product
);
// in_a * in_b = Product
// in_a is Multiplicand , in_b is Multiplier
					

input 			CLK, RST;
input			en;
input 	[7:0]	in_a;			// Multiplicand
input  	[7:0]	in_b;			// Multiplier
output	[15:0]  	Product;

reg 		  [7:0] Mplicand;		
reg signed    [16:0]	Product_booth;
reg       	  [2:0] deter ;
reg 		  [2:0]  Counter;
assign Product = Product_booth[16:1];
reg mpy_done;
reg signed [16:0] Product_booth_temp;
reg signed [16:0] Product_booth_shift_temp;

always @(posedge CLK or posedge RST) begin
	if(RST)
		mpy_done <= 1'b1;
	else if(en)
		mpy_done <= 1'b0;
	else if(Counter==3'd4)
		mpy_done <= 1'b1;
	else
		mpy_done <= mpy_done;
end

//Counter
always @(posedge CLK or posedge RST)
begin
	if (RST)
		Counter <= 3'b0;
	else if (~mpy_done)
		Counter <= Counter + 1'b1;
	else
		Counter <= Counter;
end

//Product
always @(posedge CLK or posedge RST)
begin
	if (RST) begin
		Product_booth  <= 17'b0;
		Mplicand <= 8'b0;
	end

	else if (Counter == 3'd0) begin
		Mplicand <= in_a;
		Product_booth <= {8'b0, in_b, 1'b0};	
	end
	
	else if (Counter <= 3'd4)begin
	/**Your design **/
	   //Product_booth = 100;
        //Product_booth <= {8'b0, in_b, 1'b0};
           if ( mpy_done == 1'b0 ) begin
               Product_booth <= Product_booth_shift_temp;
            end
            //sequential circuit 

	end
	else begin
		Product_booth <= Product_booth;
		Mplicand	<= Mplicand;
	end
end

//combin circuit
always@(*)begin
    if ( Mplicand <= 127 ) begin// + 
        case ( Product_booth[2:0] )
            3'b001:begin//001 +A, +A is + sign 
                Product_booth_temp <= (Product_booth + {Mplicand,9'b0}) ; 
                Product_booth_shift_temp <= {1'b0,1'b0,Product_booth_temp[16:2]};
            end
            3'b010:begin//001 +A
                Product_booth_temp <= (Product_booth + {Mplicand,9'b0}) ;
                Product_booth_shift_temp <= {1'b0,1'b0,Product_booth_temp[16:2]}; 
            end
            3'b101:begin//101 -A
                Product_booth_temp <= (Product_booth - {Mplicand,9'b0}) ;
                Product_booth_shift_temp <= {1'b1,1'b1,Product_booth_temp[16:2]};
            end
            3'b110:begin//110 -A
                Product_booth_temp <= (Product_booth - {Mplicand,9'b0});
                Product_booth_shift_temp <= {1'b1,1'b1,Product_booth_temp[16:2]};
            end
            3'b011:begin
                Product_booth_temp <= (Product_booth + {Mplicand,9'b0} +{Mplicand,9'b0}) ;
                Product_booth_shift_temp <= {1'b0,1'b0,Product_booth_temp[16:2]};
            end
            3'b100:begin
                Product_booth_temp <= (Product_booth - {Mplicand,9'b0} -{Mplicand,9'b0} ) ;
                Product_booth_shift_temp <= {1'b1,1'b1,Product_booth_temp[16:2]};
           end
           default:begin
                Product_booth_temp <= Product_booth;
                Product_booth_shift_temp <= {Product_booth_temp[16],Product_booth_temp[16],Product_booth_temp[16:2]};
           end
        endcase
    end
    else begin // - 
        case ( Product_booth[2:0] )
            3'b001:begin
                Product_booth_temp <= (Product_booth + {Mplicand,9'b0}) ; 
                Product_booth_shift_temp <= {1'b1,1'b1,Product_booth_temp[16:2]};
            end
            3'b010:begin
                Product_booth_temp <= (Product_booth + {Mplicand,9'b0}) ;
                Product_booth_shift_temp <= {1'b1,1'b1,Product_booth_temp[16:2]}; 
            end
            3'b101:begin
                Product_booth_temp <= (Product_booth - {Mplicand,9'b0}) ;
                Product_booth_shift_temp <= {1'b0,1'b0,Product_booth_temp[16:2]};
            end
            3'b110:begin
                Product_booth_temp <= (Product_booth - {Mplicand,9'b0});
                Product_booth_shift_temp <= {1'b0,1'b0,Product_booth_temp[16:2]};
            end
            3'b011:begin
                Product_booth_temp <= (Product_booth + {Mplicand,9'b0} +{Mplicand,9'b0}) ;
                Product_booth_shift_temp <= {1'b1,1'b1,Product_booth_temp[16:2]};
            end
            3'b100:begin
                Product_booth_temp <= (Product_booth - {Mplicand,9'b0} -{Mplicand,9'b0} ) ;
                Product_booth_shift_temp <= {1'b0,1'b0,Product_booth_temp[16:2]};
           end
           default:begin
                Product_booth_temp <= Product_booth;
                Product_booth_shift_temp <= {Product_booth_temp[16],Product_booth_temp[16],Product_booth_temp[16:2]};
           end
        endcase
    end

end

endmodule

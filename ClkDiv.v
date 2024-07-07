module ClkDiv
#( parameter RATIO_WD = 4 )

(
input 	wire 						I_ref_clk,
input 	wire 						I_rst_n,
input 	wire 						I_clk_en,
input 	wire 	[RATIO_WD-1:0]		I_div_ratio,
output 	wire						O_div_clk
);

wire 	[RATIO_WD-1:0]		divide;
wire   						clk_en;
reg 						div_clk;
reg 	[RATIO_WD-1:0] 		count;

assign divide 		= I_div_ratio >>1;
assign clk_en		= I_clk_en & (I_div_ratio !== 1'b1) & (|I_div_ratio);
assign O_div_clk 	= clk_en ? (!div_clk) : I_ref_clk;


always @(posedge I_ref_clk, negedge I_rst_n)

 if(!I_rst_n)
 begin
 	count 		<= 0;
	div_clk 	<= 0;
 end
 else 
	begin
		if(clk_en)
		begin
			if((count < divide-1)& (div_clk) & (!I_div_ratio[0]))  //even
				begin
				 count <= count +1;
				 div_clk <= div_clk;
				end
				
			else if((count < divide)& (div_clk) & I_div_ratio[0])  //odd
				begin
				 count <= count +1;
				 div_clk <= div_clk;
				end
			
			else if ((count < divide-1)&(!div_clk))
				begin
				 count <= count +1;
				 div_clk <= div_clk;
				end
				
			else 
				begin
				 div_clk <= !div_clk;
				 count <= 0;
				end
		end
		else 
			div_clk <= 0;
	end

endmodule 
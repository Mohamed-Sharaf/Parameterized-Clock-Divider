//////////////////////////////////////////////////////////////////
// File: ClkDiv.v
// Description: Parameterized clock divider module
// Author: Mohamed Sharaf
// Date: 11/05/2022
//////////////////////////////////////////////////////////////////

module ClkDiv
#( parameter RATIO_WD = 4 ) // Parameter defining the width of the divider ratio

(
input 	wire 						I_ref_clk,       // Input reference clock
input 	wire 						I_rst_n,         // Active-low reset signal
input 	wire 						I_clk_en,        // Clock enable signal
input 	wire 	[RATIO_WD-1:0]				I_div_ratio,     // Divider ratio
output 	wire						O_div_clk        // Output divided clock
);

// Internal signals
wire 	[RATIO_WD-1:0]		divide;   // Half of the division ratio
wire   				clk_en;   // Internal clock enable signal
reg 				div_clk;  // Register for the divided clock
reg 	[RATIO_WD-1:0] 		count;    // Counter register

// Assign divide to half of I_div_ratio
assign divide 		= I_div_ratio >>1;

// Assign clk_en based on I_clk_en and the validity of I_div_ratio
assign clk_en		= I_clk_en & (I_div_ratio !== 1'b1) & (|I_div_ratio);

// Assign O_div_clk based on clk_en and div_clk
assign O_div_clk 	= clk_en ? (!div_clk) : I_ref_clk;


always @(posedge I_ref_clk, negedge I_rst_n)
 if(!I_rst_n)
 begin
 	count 		<= 0;    // Reset count to 0
	div_clk 	<= 0;    // Reset div_clk to 0
 end
 else 
 begin
	// When clk_en is high, perform division
	if(clk_en)
	begin
		// Even division case
		if((count < divide-1) & (div_clk) & (!I_div_ratio[0]))
		begin
			count <= count + 1;  
		end
		
		// Odd division case
		else if((count < divide) & (div_clk) & I_div_ratio[0])
		begin
			count <= count + 1;  
		end
		
		// General case for toggling div_clk
		else if ((count < divide-1) & (!div_clk))
		begin
			count <= count + 1;  
		end
		
		// Toggle div_clk and reset count
		else 
		begin
			div_clk <= !div_clk; // Toggle div_clk
			count <= 0;          // Reset count
		end
	end
	else 
		div_clk <= 0;  // When clk_en is low, set div_clk to 0
 end

endmodule 

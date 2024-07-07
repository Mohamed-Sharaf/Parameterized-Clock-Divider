# ClkDiv Module

## Overview
The `ClkDiv` module is a parameterized clock divider implemented in Verilog. It takes an input reference clock and divides it by a user-defined ratio, outputting a clock signal with a lower frequency. This is useful in digital designs where multiple clock domains are required.

## Features
- **Parameterized Division Ratio**: The division ratio can be customized using a parameter, allowing the module to be reused with different division settings.
- **Clock Enable Control**: Includes a clock enable input to control whether the clock division is active.
- **Supports Even and Odd Division Ratios**: Correctly handles both even and odd division ratios for flexible clock management.

## Parameters
- `RATIO_WD`: Defines the width of the division ratio input. This parameter determines the maximum division ratio that can be specified.

## Inputs
- `I_ref_clk`: Input reference clock signal.
- `I_rst_n`: Active-low reset signal. Resets the output clock and counter when low.
- `I_clk_en`: Clock enable signal. Activates the clock division when high.
- `I_div_ratio`: Division ratio. The output clock frequency is the input clock frequency divided by this ratio.

## Outputs
- `O_div_clk`: Output divided clock signal.

## Internal Signals
- `divide`: Internal wire holding half of the division ratio.
- `clk_en`: Internal wire for clock enable, combining `I_clk_en` and validation checks on `I_div_ratio`.
- `div_clk`: Internal register holding the state of the divided clock.
- `count`: Internal counter register.

## Operation
The `ClkDiv` module operates as follows:

1. **Reset Handling**: When `I_rst_n` is low, the `count` and `div_clk` registers are reset to 0.
2. **Clock Enable**: When `clk_en` is high, the module performs clock division based on the value of `I_div_ratio`.
3. **Division Logic**:
    - For even division ratios, the module toggles the output clock (`div_clk`) when the counter reaches `divide - 1`.
    - For odd division ratios, the module toggles the output clock when the counter reaches `divide`.
    - In each case, the counter increments on each rising edge of the reference clock until it reaches the required value.
4. **Clock Output**: The divided clock output (`O_div_clk`) is determined by the state of `clk_en` and `div_clk`. If `clk_en` is low, `O_div_clk` follows the reference clock.

## Example
Here is an example instantiation of the `ClkDiv` module with a 4-bit division ratio:

```verilog
module top_module (
    input wire clk,        // System clock
    input wire rst_n,      // System reset (active-low)
    input wire clk_en,     // Clock enable
    output wire div_clk    // Divided clock output
);

    // Instantiate the ClkDiv module
    ClkDiv #(.RATIO_WD(4)) clk_div_inst (
        .I_ref_clk(clk),
        .I_rst_n(rst_n),
        .I_clk_en(clk_en),
        .I_div_ratio(4'b1010),  // Division ratio of 10
        .O_div_clk(div_clk)
    );

endmodule

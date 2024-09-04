
`timescale 1 ns / 1 ns

module Fully_Parallel
               (
                clk,
                clk_enable,
                reset,
                filter_in,
                filter_out
                );

  input   clk; 
  input   clk_enable; 
  input   reset; 
  input   signed [15:0] filter_in; //sfix16_En15
  output  signed [32:0] filter_out; //sfix33_En31

////////////////////////////////////////////////////////////////
//Module Architecture: Fully_Parallel
////////////////////////////////////////////////////////////////
  // Local Functions
  // Type Definitions
  // Constants
  parameter signed [15:0] coeff1 = 16'b1101110110111011; //sfix16_En16
  parameter signed [15:0] coeff2 = 16'b1110101010001110; //sfix16_En16
  parameter signed [15:0] coeff3 = 16'b0011001111011011; //sfix16_En16
  parameter signed [15:0] coeff4 = 16'b0110100000001000; //sfix16_En16
  parameter signed [15:0] coeff5 = 16'b0110100000001000; //sfix16_En16
  parameter signed [15:0] coeff6 = 16'b0011001111011011; //sfix16_En16
  parameter signed [15:0] coeff7 = 16'b1110101010001110; //sfix16_En16
  parameter signed [15:0] coeff8 = 16'b1101110110111011; //sfix16_En16

  // Signals
  reg  signed [15:0] delay_pipeline [0:7] ; // sfix16_En15
  wire signed [30:0] product8; // sfix31_En31
  wire signed [31:0] mul_temp; // sfix32_En31
  wire signed [30:0] product7; // sfix31_En31
  wire signed [31:0] mul_temp_1; // sfix32_En31
  wire signed [30:0] product6; // sfix31_En31
  wire signed [31:0] mul_temp_2; // sfix32_En31
  wire signed [30:0] product5; // sfix31_En31
  wire signed [31:0] mul_temp_3; // sfix32_En31
  wire signed [30:0] product4; // sfix31_En31
  wire signed [31:0] mul_temp_4; // sfix32_En31
  wire signed [30:0] product3; // sfix31_En31
  wire signed [31:0] mul_temp_5; // sfix32_En31
  wire signed [30:0] product2; // sfix31_En31
  wire signed [31:0] mul_temp_6; // sfix32_En31
  wire signed [32:0] product1_cast; // sfix33_En31
  wire signed [30:0] product1; // sfix31_En31
  wire signed [31:0] mul_temp_7; // sfix32_En31
  wire signed [32:0] sum1; // sfix33_En31
  wire signed [32:0] add_signext; // sfix33_En31
  wire signed [32:0] add_signext_1; // sfix33_En31
  wire signed [33:0] add_temp; // sfix34_En31
  wire signed [32:0] sum2; // sfix33_En31
  wire signed [32:0] add_signext_2; // sfix33_En31
  wire signed [32:0] add_signext_3; // sfix33_En31
  wire signed [33:0] add_temp_1; // sfix34_En31
  wire signed [32:0] sum3; // sfix33_En31
  wire signed [32:0] add_signext_4; // sfix33_En31
  wire signed [32:0] add_signext_5; // sfix33_En31
  wire signed [33:0] add_temp_2; // sfix34_En31
  wire signed [32:0] sum4; // sfix33_En31
  wire signed [32:0] add_signext_6; // sfix33_En31
  wire signed [32:0] add_signext_7; // sfix33_En31
  wire signed [33:0] add_temp_3; // sfix34_En31
  wire signed [32:0] sum5; // sfix33_En31
  wire signed [32:0] add_signext_8; // sfix33_En31
  wire signed [32:0] add_signext_9; // sfix33_En31
  wire signed [33:0] add_temp_4; // sfix34_En31
  wire signed [32:0] sum6; // sfix33_En31
  wire signed [32:0] add_signext_10; // sfix33_En31
  wire signed [32:0] add_signext_11; // sfix33_En31
  wire signed [33:0] add_temp_5; // sfix34_En31
  wire signed [32:0] sum7; // sfix33_En31
  wire signed [32:0] add_signext_12; // sfix33_En31
  wire signed [32:0] add_signext_13; // sfix33_En31
  wire signed [33:0] add_temp_6; // sfix34_En31
  reg  signed [32:0] output_register; // sfix33_En31

  // Block Statements
  always @( posedge clk or posedge reset)
    begin: Delay_Pipeline_process
      if (reset == 1'b1) begin
        delay_pipeline[0] <= 0;
        delay_pipeline[1] <= 0;
        delay_pipeline[2] <= 0;
        delay_pipeline[3] <= 0;
        delay_pipeline[4] <= 0;
        delay_pipeline[5] <= 0;
        delay_pipeline[6] <= 0;
        delay_pipeline[7] <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          delay_pipeline[0] <= filter_in;
          delay_pipeline[1] <= delay_pipeline[0];
          delay_pipeline[2] <= delay_pipeline[1];
          delay_pipeline[3] <= delay_pipeline[2];
          delay_pipeline[4] <= delay_pipeline[3];
          delay_pipeline[5] <= delay_pipeline[4];
          delay_pipeline[6] <= delay_pipeline[5];
          delay_pipeline[7] <= delay_pipeline[6];
        end
      end
    end // Delay_Pipeline_process


  assign mul_temp = delay_pipeline[7] * coeff8;
  assign product8 = mul_temp[30:0];

  assign mul_temp_1 = delay_pipeline[6] * coeff7;
  assign product7 = mul_temp_1[30:0];

  assign mul_temp_2 = delay_pipeline[5] * coeff6;
  assign product6 = mul_temp_2[30:0];

  assign mul_temp_3 = delay_pipeline[4] * coeff5;
  assign product5 = mul_temp_3[30:0];

  assign mul_temp_4 = delay_pipeline[3] * coeff4;
  assign product4 = mul_temp_4[30:0];

  assign mul_temp_5 = delay_pipeline[2] * coeff3;
  assign product3 = mul_temp_5[30:0];

  assign mul_temp_6 = delay_pipeline[1] * coeff2;
  assign product2 = mul_temp_6[30:0];

  assign product1_cast = $signed({{2{product1[30]}}, product1});

  assign mul_temp_7 = delay_pipeline[0] * coeff1;
  assign product1 = mul_temp_7[30:0];

  assign add_signext = product1_cast;
  assign add_signext_1 = $signed({{2{product2[30]}}, product2});
  assign add_temp = add_signext + add_signext_1;
  assign sum1 = add_temp[32:0];

  assign add_signext_2 = sum1;
  assign add_signext_3 = $signed({{2{product3[30]}}, product3});
  assign add_temp_1 = add_signext_2 + add_signext_3;
  assign sum2 = add_temp_1[32:0];

  assign add_signext_4 = sum2;
  assign add_signext_5 = $signed({{2{product4[30]}}, product4});
  assign add_temp_2 = add_signext_4 + add_signext_5;
  assign sum3 = add_temp_2[32:0];

  assign add_signext_6 = sum3;
  assign add_signext_7 = $signed({{2{product5[30]}}, product5});
  assign add_temp_3 = add_signext_6 + add_signext_7;
  assign sum4 = add_temp_3[32:0];

  assign add_signext_8 = sum4;
  assign add_signext_9 = $signed({{2{product6[30]}}, product6});
  assign add_temp_4 = add_signext_8 + add_signext_9;
  assign sum5 = add_temp_4[32:0];

  assign add_signext_10 = sum5;
  assign add_signext_11 = $signed({{2{product7[30]}}, product7});
  assign add_temp_5 = add_signext_10 + add_signext_11;
  assign sum6 = add_temp_5[32:0];

  assign add_signext_12 = sum6;
  assign add_signext_13 = $signed({{2{product8[30]}}, product8});
  assign add_temp_6 = add_signext_12 + add_signext_13;
  assign sum7 = add_temp_6[32:0];

  always @ (posedge clk or posedge reset)
    begin: Output_Register_process
      if (reset == 1'b1) begin
        output_register <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          output_register <= sum7;
        end
      end
    end // Output_Register_process

  // Assignment Statements
  assign filter_out = output_register;
endmodule  // Fully_Parallel
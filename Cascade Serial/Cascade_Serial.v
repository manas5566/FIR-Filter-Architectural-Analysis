
`timescale 1 ns / 1 ns

module Cascade_Serial
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
//Module Architecture: Cascade_Serial
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
  reg  [2:0] cur_count; // ufix3
  wire phase_4; // boolean
  wire phase_0; // boolean
  wire phase_1; // boolean
  reg  signed [15:0] delay_pipeline [0:7] ; // sfix16_En15
  wire signed [15:0] inputmux_1; // sfix16_En15
  wire signed [15:0] inputmux_2; // sfix16_En15
  reg  signed [32:0] acc_final; // sfix33_En31
  reg  signed [32:0] acc_out_1; // sfix33_En31
  reg  signed [32:0] acc_out_2; // sfix33_En31
  wire signed [30:0] product_1; // sfix31_En31
  wire signed [15:0] product_1_mux; // sfix16_En16
  wire signed [31:0] mul_temp; // sfix32_En31
  wire signed [32:0] prod_typeconvert_1; // sfix33_En31
  wire signed [32:0] acc_cscade_1; // sfix33_En31
  wire signed [32:0] acc_sum_1; // sfix33_En31
  wire signed [32:0] acc_in_1; // sfix33_En31
  wire signed [32:0] add_signext; // sfix33_En31
  wire signed [32:0] add_signext_1; // sfix33_En31
  wire signed [33:0] add_temp; // sfix34_En31
  wire signed [30:0] product_2; // sfix31_En31
  wire signed [15:0] product_2_mux; // sfix16_En16
  wire signed [31:0] mul_temp_1; // sfix32_En31
  wire signed [32:0] prod_typeconvert_2; // sfix33_En31
  wire signed [32:0] acc_sum_2; // sfix33_En31
  wire signed [32:0] acc_in_2; // sfix33_En31
  wire signed [32:0] add_signext_2; // sfix33_En31
  wire signed [32:0] add_signext_3; // sfix33_En31
  wire signed [33:0] add_temp_1; // sfix34_En31
  reg  signed [32:0] output_register; // sfix33_En31

  // Block Statements
  always @ (posedge clk or posedge reset)
    begin: Counter_process
      if (reset == 1'b1) begin
        cur_count <= 3'b100;
      end
      else begin
        if (clk_enable == 1'b1) begin
          if (cur_count >= 3'b100) begin
            cur_count <= 3'b000;
          end
          else begin
            cur_count <= cur_count + 3'b001;
          end
        end
      end
    end // Counter_process

  assign  phase_4 = (cur_count == 3'b100 && clk_enable == 1'b1) ? 1'b1 : 1'b0;

  assign  phase_0 = (cur_count == 3'b000 && clk_enable == 1'b1) ? 1'b1 : 1'b0;

  assign phase_1 = (((cur_count == 3'b000) ||
                     (cur_count == 3'b001)  ||
                     (cur_count == 3'b010)  ||
                     (cur_count == 3'b011)) && clk_enable == 1'b1) ? 1'b1 : 1'b0;

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
        if (phase_4 == 1'b1) begin
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


  assign inputmux_1 = (cur_count == 3'b000) ? delay_pipeline[0] :
                     (cur_count == 3'b001) ? delay_pipeline[1] :
                     (cur_count == 3'b010) ? delay_pipeline[2] :
                     delay_pipeline[3];

  assign inputmux_2 = (cur_count == 3'b000) ? delay_pipeline[4] :
                     (cur_count == 3'b001) ? delay_pipeline[5] :
                     (cur_count == 3'b010) ? delay_pipeline[6] :
                     delay_pipeline[7];

  //   ------------------ Serial partition # 1 ------------------

  assign product_1_mux = (cur_count == 3'b000) ? coeff1 :
                        (cur_count == 3'b001) ? coeff2 :
                        (cur_count == 3'b010) ? coeff3 :
                        coeff4;
  assign mul_temp = inputmux_1 * product_1_mux;
  assign product_1 = mul_temp[30:0];

  assign prod_typeconvert_1 = $signed({{2{product_1[30]}}, product_1});

  assign acc_cscade_1 = (phase_4 == 1'b1) ? acc_out_2 :
                       prod_typeconvert_1;

  assign add_signext = acc_cscade_1;
  assign add_signext_1 = acc_out_1;
  assign add_temp = add_signext + add_signext_1;
  assign acc_sum_1 = add_temp[32:0];

  assign acc_in_1 = (phase_0 == 1'b1) ? acc_cscade_1 :
                   acc_sum_1;

  always @ (posedge clk or posedge reset)
    begin: Acc_reg_1_process
      if (reset == 1'b1) begin
        acc_out_1 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          acc_out_1 <= acc_in_1;
        end
      end
    end // Acc_reg_1_process

  //   ------------------ Serial partition # 2 ------------------

  assign product_2_mux = (cur_count == 3'b000) ? coeff5 :
                        (cur_count == 3'b001) ? coeff6 :
                        (cur_count == 3'b010) ? coeff7 :
                        coeff8;
  assign mul_temp_1 = inputmux_2 * product_2_mux;
  assign product_2 = mul_temp_1[30:0];

  assign prod_typeconvert_2 = $signed({{2{product_2[30]}}, product_2});

  assign add_signext_2 = prod_typeconvert_2;
  assign add_signext_3 = acc_out_2;
  assign add_temp_1 = add_signext_2 + add_signext_3;
  assign acc_sum_2 = add_temp_1[32:0];

  assign acc_in_2 = (phase_0 == 1'b1) ? prod_typeconvert_2 :
                   acc_sum_2;

  always @ (posedge clk or posedge reset)
    begin: Acc_reg_2_process
      if (reset == 1'b1) begin
        acc_out_2 <= 0;
      end
      else begin
        if (phase_1 == 1'b1) begin
          acc_out_2 <= acc_in_2;
        end
      end
    end // Acc_reg_2_process

  always @ (posedge clk or posedge reset)
    begin: Finalsum_reg_process
      if (reset == 1'b1) begin
        acc_final <= 0;
      end
      else begin
        if (phase_0 == 1'b1) begin
          acc_final <= acc_out_1;
        end
      end
    end // Finalsum_reg_process

  always @ (posedge clk or posedge reset)
    begin: Output_Register_process
      if (reset == 1'b1) begin
        output_register <= 0;
      end
      else begin
        if (phase_4 == 1'b1) begin
          output_register <= acc_final;
        end
      end
    end // Output_Register_process

  // Assignment Statements
  assign filter_out = output_register;
endmodule  // Cascade_Serial

 
`timescale 1 ns / 1 ns

module Partly_Serial_VM_CLA
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
//Module Architecture: Partly_Serial
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
  reg  [1:0] cur_count; // ufix2
  wire phase_3; // boolean
  wire phase_0; // boolean
  reg  signed [15:0] delay_pipeline [0:7] ; // sfix16_En15
  wire signed [15:0] inputmux_1; // sfix16_En15
  wire signed [15:0] inputmux_2; // sfix16_En15
  reg  signed [32:0] acc_final; // sfix33_En31
  reg  signed [32:0] acc_out_1; // sfix33_En31
  wire signed [30:0] product_1; // sfix31_En31
  wire signed [15:0] product_1_mux; // sfix16_En16
  wire signed [31:0] mul_temp; // sfix32_En31
  wire signed [32:0] prod_typeconvert_1; // sfix33_En31
  wire signed [32:0] acc_sum_1; // sfix33_En31
  wire signed [32:0] acc_in_1; // sfix33_En31
  wire signed [32:0] add_signext; // sfix33_En31
  wire signed [32:0] add_signext_1; // sfix33_En31
  wire signed [33:0] add_temp; // sfix34_En31
  reg  signed [32:0] acc_out_2; // sfix33_En31
  wire signed [30:0] product_2; // sfix31_En31
  wire signed [15:0] product_2_mux; // sfix16_En16
  wire signed [31:0] mul_temp_1; // sfix32_En31
  wire signed [32:0] prod_typeconvert_2; // sfix33_En31
  wire signed [32:0] acc_sum_2; // sfix33_En31
  wire signed [32:0] acc_in_2; // sfix33_En31
  wire signed [32:0] add_signext_2; // sfix33_En31
  wire signed [32:0] add_signext_3; // sfix33_En31
  wire signed [33:0] add_temp_1; // sfix34_En31
  wire signed [32:0] sum1; // sfix33_En31
  wire signed [32:0] add_signext_4; // sfix33_En31
  wire signed [32:0] add_signext_5; // sfix33_En31
  wire signed [33:0] add_temp_2; // sfix34_En31
  reg  signed [32:0] output_register; // sfix33_En31

  // Block Statements
  always @ (posedge clk or posedge reset)
    begin: Counter_process
      if (reset == 1'b1) begin
        cur_count <= 2'b11;
      end
      else begin
        if (clk_enable == 1'b1) begin
          if (cur_count >= 2'b11) begin
            cur_count <= 2'b00;
          end
          else begin
            cur_count <= cur_count + 2'b01;
          end
        end
      end
    end // Counter_process

  assign  phase_3 = (cur_count == 2'b11 && clk_enable == 1'b1) ? 1'b1 : 1'b0;

  assign  phase_0 = (cur_count == 2'b00 && clk_enable == 1'b1) ? 1'b1 : 1'b0;

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
        if (phase_3 == 1'b1) begin
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


  assign inputmux_1 = (cur_count == 2'b00) ? delay_pipeline[0] :
                     (cur_count == 2'b01) ? delay_pipeline[1] :
                     (cur_count == 2'b10) ? delay_pipeline[2] :
                     delay_pipeline[3];

  assign inputmux_2 = (cur_count == 2'b00) ? delay_pipeline[4] :
                     (cur_count == 2'b01) ? delay_pipeline[5] :
                     (cur_count == 2'b10) ? delay_pipeline[6] :
                     delay_pipeline[7];

  //   ------------------ Serial partition # 1 ------------------

  assign product_1_mux = (cur_count == 2'b00) ? coeff1 :
                        (cur_count == 2'b01) ? coeff2 :
                        (cur_count == 2'b10) ? coeff3 :
                        coeff4;
  //assign mul_temp = inputmux_1 * product_1_mux;
  vedic_16x16 m1(inputmux_1, product_1_mux,mul_temp);
  assign product_1 = mul_temp[30:0];

  assign prod_typeconvert_1 = $signed({{2{product_1[30]}}, product_1});

  assign add_signext = prod_typeconvert_1;
  assign add_signext_1 = acc_out_1;
  //assign add_temp = add_signext + add_signext_1;
  wire c0,c1,c2,c3,c4,c5;
  assign c1=1'b0;
  carry_look_adder_32bit a1(add_temp,c0,add_signext,add_signext_1,c1);
  assign acc_sum_1 = add_temp[31:0];

  assign acc_in_1 = (phase_0 == 1'b1) ? prod_typeconvert_1 :
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

  assign product_2_mux = (cur_count == 2'b00) ? coeff5 :
                        (cur_count == 2'b01) ? coeff6 :
                        (cur_count == 2'b10) ? coeff7 :
                        coeff8;
  //assign mul_temp_1 = inputmux_2 * product_2_mux;
  vedic_16x16 m2(inputmux_2,product_2_mux,mul_temp_1);
  assign product_2 = mul_temp_1[30:0];

  assign prod_typeconvert_2 = $signed({{2{product_2[30]}}, product_2});

  assign add_signext_2 = prod_typeconvert_2;
  assign add_signext_3 = acc_out_2;
  //assign add_temp_1 = add_signext_2 + add_signext_3;
  assign c3=1'b0;
  carry_look_adder_32bit a2(add_temp_1,c2,add_signext_2,add_signext_3,c3);
  assign acc_sum_2 = add_temp_1[31:0];

  assign acc_in_2 = (phase_0 == 1'b1) ? prod_typeconvert_2 :
                   acc_sum_2;

  always @ (posedge clk or posedge reset)
    begin: Acc_reg_2_process
      if (reset == 1'b1) begin
        acc_out_2 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          acc_out_2 <= acc_in_2;
        end
      end
    end // Acc_reg_2_process

  assign add_signext_4 = acc_out_2;
  assign add_signext_5 = acc_out_1;
  //assign add_temp_2 = add_signext_4 + add_signext_5;
  assign c5=1'b0;
  carry_look_adder_32bit a3(add_temp_2,c4,add_signext_4,add_signext_5,c5);
  assign sum1 = add_temp_2[31:0];

  always @ (posedge clk or posedge reset)
    begin: Finalsum_reg_process
      if (reset == 1'b1) begin
        acc_final <= 0;
      end
      else begin
        if (phase_0 == 1'b1) begin
          acc_final <= sum1;
        end
      end
    end // Finalsum_reg_process

  always @ (posedge clk or posedge reset)
    begin: Output_Register_process
      if (reset == 1'b1) begin
        output_register <= 0;
      end
      else begin
        if (phase_3 == 1'b1) begin
          output_register <= acc_final;
        end
      end
    end // Output_Register_process

  // Assignment Statements
  assign filter_out = output_register;
endmodule  // Partly_Serial


module vedic_16x16(a, b, result);
    input  [15:0] a,b;
    output [31:0] result;
    wire [31:0] result;
    
    wire [15:0] q0, q1, q2, q3,q4;
    wire [23:0] q5,q6;
    wire [15:0] temp1, temp2;
    wire [23:0] temp3,temp4; 
    
vedic_8x8 V9(a[7:0]  , b[7:0] , q0[15:0]);
vedic_8x8 V10(a[15:8], b[7:0] , q1[15:0]);
vedic_8x8 V11(a[7:0] , b[15:8], q2[15:0]);
vedic_8x8 V12(a[15:8], b[15:8], q3[15:0]);

assign temp1= {8'b00000000, q0[15:8]};
assign temp2= q1[15:0];
assign temp3= {8'b00000000, q2[15:0]}; 
assign temp4= {q3[15:0], 8'b00000000}; 

carry_look_adder_16bit A3(temp1, temp2, q4);
carry_look_adder_24bit A4(temp3, temp4, q5);
carry_look_adder_24bit A5({8'b00000000,q4}, q5, q6);

assign result[7:0]= q0[7:0];
assign result[31:8]= q6[23:0];

endmodule

module vedic_8x8(a, b, result);
    input  [7:0] a,b;
    output [15:0] result;
    wire [15:0] result;
    wire [7:0] q0, q1, q2, q3,q4;
    wire [11:0] q5,q6;
    wire [7:0] temp1, temp2;
    wire [11:0] temp3,temp4; 

vedic_4x4 V5(a[3:0], b[3:0], q0[7:0]);
vedic_4x4 V6(a[7:4], b[3:0], q1[7:0]);
vedic_4x4 V7(a[3:0], b[7:4], q2[7:0]);
vedic_4x4 V8(a[7:4], b[7:4], q3[7:0]);

assign temp1= {4'b0000, q0[7:4]};
assign temp2= q1[7:0];
assign temp3= {4'b0000, q2[7:0]}; 
assign temp4= {q3[7:0], 4'b0000}; 

carry_look_adder_8bit A3(temp1, temp2, q4);
carry_look_adder_12bit A4(temp3, temp4, q5);
carry_look_adder_12bit A5({4'b0000,q4}, q5, q6);

assign result[3:0]= q0[3:0];
assign result[15:4]= q6[11:0];

endmodule

module vedic_4x4(a, b, result);
    input  [3:0] a,b;
    output [7:0] result;
    wire [7:0] result;

wire w1, w2, w3, w4, w5;
wire [3:0] temp1;
wire [5:0] temp2;
wire [5:0] temp3;
wire [5:0] temp4;
wire [3:0] q0;
wire [3:0] q1;
wire [3:0] q2;
wire [3:0] q3;
wire [3:0] q4;
wire [5:0] q5;
wire [5:0] q6;

vedic_2x2 V1(a[1:0], b[1:0], q0[3:0]);
vedic_2x2 V2(a[3:2], b[1:0], q1[3:0]);
vedic_2x2 V3(a[1:0], b[3:2], q2[3:0]);
vedic_2x2 V4(a[3:2], b[3:2], q3[3:0]);

assign temp1= {2'b00, q0[3:2]};
carry_look_adder_4bit A0(q1[3:0], temp1, q4);
assign temp2= {2'b00, q2[3:0]};
assign temp3= {q3[3:0], 2'b00};
carry_look_adder_6bit A1(temp2, temp3, q5);
assign temp4= {2'b00, q4[3:0]};
carry_look_adder_6bit A2(temp4, q5, q6);
assign result[1:0] = q0[1:0];
assign result[7:2] = q6[5:0];
    
endmodule

module vedic_2x2 (a, b, result);
    input [1:0] a,b;
    output [3:0] result;

    wire [3:0] w;
    
    assign result[0]= a[0]&b[0];
    assign w[0]     = a[1]&b[0];
    assign w[1]     = a[0]&b[1];
    assign w[2]     = a[1]&b[1];

    halfAdder H0(w[0], w[1], result[1], w[3]);
    halfAdder H1(w[2], w[3], result[2], result[3]);    
    
endmodule

module halfAdder(a,b,sum,carry);
    input a,b;
    output sum, carry;

assign sum   = a ^ b;
assign carry = a & b;

endmodule

module carry_look_adder_32bit(Sum, Cout, A, B, Cin);
    output [31:0] Sum;
    output Cout;
    input [31:0] A;
    input [31:0] B;
    input Cin;
    wire [31:0] P, G;
  
  assign P[0] = A[0] ^ B[0];
  assign G[0] = A[0] & B[0];
  
  assign P[1] = A[1] ^ B[1] ^ G[0];
  assign G[1] = (A[1] & B[1]) | (A[1] & G[0]) | (B[1] & G[0]);
  
  assign P[2] = A[2] ^ B[2] ^ G[1];
  assign G[2] = (A[2] & B[2]) | (A[2] & G[1]) | (B[2] & G[1]);
  
  assign P[3] = A[3] ^ B[3] ^ G[2];
  assign G[3] = (A[3] & B[3]) | (A[3] & G[2]) | (B[3] & G[2]);
  
  assign P[4] = A[4] ^ B[4] ^ G[3];
  assign G[4] = (A[4] & B[4]) | (A[4] & G[3]) | (B[4] & G[3]);
  
  assign P[5] = A[5] ^ B[5] ^ G[4];
  assign G[5] = (A[5] & B[5]) | (A[5] & G[4]) | (B[5] & G[4]);
  
  assign P[6] = A[6] ^ B[6] ^ G[5];
  assign G[6] = (A[6] & B[6]) | (A[6] & G[5]) | (B[6] & G[5]);
  
  assign P[7] = A[7] ^ B[7] ^ G[6];
  assign G[7] = (A[7] & B[7]) | (A[7] & G[6]) | (B[7] & G[6]);
  
  assign P[8] = A[8] ^ B[8] ^ G[7];
  assign G[8] = (A[8] & B[8]) | (A[8] & G[7]) | (B[8] & G[7]);
  
  assign P[9] = A[9] ^ B[9] ^ G[8];
  assign G[9] = (A[9] & B[9]) | (A[9] & G[8]) | (B[9] & G[8]);
  
  assign P[10] = A[10] ^ B[10] ^ G[9];
  assign G[10] = (A[10] & B[10]) | (A[10] & G[9]) | (B[10] & G[9]);
  
  assign P[11] = A[11] ^ B[11] ^ G[10];
  assign G[11] = (A[11] & B[11]) | (A[11] & G[10]) | (B[11] & G[10]);
  
  assign P[12] = A[12] ^ B[12] ^ G[11];
  assign G[12] = (A[12] & B[12]) | (A[12] & G[11]) | (B[12] & G[11]);
  
  assign P[13] = A[13] ^ B[13] ^ G[12];
  assign G[13] = (A[13] & B[13]) | (A[13] & G[12]) | (B[13] & G[12]);
  
  assign P[14] = A[14] ^ B[14] ^ G[13];
  assign G[14] = (A[14] & B[14]) | (A[14] & G[13]) | (B[14] & G[13]);
  
  assign P[15] = A[15] ^ B[15] ^ G[14];
  assign G[15] = (A[15] & B[15]) | (A[15] & G[14]) | (B[15] & G[14]);
  
  assign P[16] = A[16] ^ B[16] ^ G[15];
  assign G[16] = (A[16] & B[16]) | (A[16] & G[15]) | (B[16] & G[15]);
  
  assign P[17] = A[17] ^ B[17] ^ G[16];
  assign G[17] = (A[17] & B[17]) | (A[17] & G[16]) | (B[17] & G[16]);
  
  assign P[18] = A[18] ^ B[18] ^ G[17];
  assign G[18] = (A[18] & B[18]) | (A[18] & G[17]) | (B[18] & G[17]);
  
  assign P[19] = A[19] ^ B[19] ^ G[18];
  assign G[19] = (A[19] & B[19]) | (A[19] & G[18]) | (B[19] & G[18]);
  
  assign P[20] = A[20] ^ B[20] ^ G[19];
  assign G[20] = (A[20] & B[20]) | (A[20] & G[19]) | (B[20] & G[19]);
  
  assign P[21] = A[21] ^ B[21] ^ G[20];
  assign G[21] = (A[21] & B[21]) | (A[21] & G[20]) | (B[21] & G[20]);
  
  assign P[22] = A[22] ^ B[22] ^ G[21];
  assign G[22] = (A[22] & B[22]) | (A[22] & G[21]) | (B[22] & G[21]);
  
  assign P[23] = A[23] ^ B[23] ^ G[22];
  assign G[23] = (A[23] & B[23]) | (A[23] & G[22]) | (B[23] & G[22]);
  
  assign P[24] = A[24] ^ B[24] ^ G[23];
  assign G[24] = (A[24] & B[24]) | (A[24] & G[23]) | (B[24] & G[23]);
  
  assign P[25] = A[25] ^ B[25] ^ G[24];
  assign G[25] = (A[25] & B[25]) | (A[25] & G[24]) | (B[25] & G[24]);
  
  assign P[26] = A[26] ^ B[26] ^ G[25];
  assign G[26] = (A[26] & B[26]) | (A[26] & G[25]) | (B[26] & G[25]);
  
  assign P[27] = A[27] ^ B[27] ^ G[26];
  assign G[27] = (A[27] & B[27]) | (A[27] & G[26]) | (B[27] & G[26]);
  
  assign P[28] = A[28] ^ B[28] ^ G[27];
  assign G[28] = (A[28] & B[28]) | (A[28] & G[27]) | (B[28] & G[27]);
  
  assign P[29] = A[29] ^ B[29] ^ G[28];
  assign G[29] = (A[29] & B[29]) | (A[29] & G[28]) | (B[29] & G[28]);
  
  assign P[30] = A[30] ^ B[30] ^ G[29];
  assign G[30] = (A[30] & B[30]) | (A[30] & G[29]) | (B[30] & G[29]);
  
  assign P[31] = A[31] ^ B[31] ^ G[30];
  assign G[31] = (A[31] & B[31]) | (A[31] & G[30]) | (B[31] & G[30]);

  assign Sum = P ^ Cin;
  assign Cout = G[31] | (P[31] & Cin);

endmodule


module carry_look_adder_24bit(A, B, Sum);
    input [23:0] A;
    input [23:0] B;
    output [23:0] Sum;
    
    wire Cin;
    wire [23:0] P, G;
    assign Cin = 1'b0;
  
  assign P[0] = A[0] ^ B[0];
  assign G[0] = A[0] & B[0];
  
  assign P[1] = A[1] ^ B[1] ^ G[0];
  assign G[1] = (A[1] & B[1]) | (A[1] & G[0]) | (B[1] & G[0]);
  
  assign P[2] = A[2] ^ B[2] ^ G[1];
  assign G[2] = (A[2] & B[2]) | (A[2] & G[1]) | (B[2] & G[1]);
  
  assign P[3] = A[3] ^ B[3] ^ G[2];
  assign G[3] = (A[3] & B[3]) | (A[3] & G[2]) | (B[3] & G[2]);
  
  assign P[4] = A[4] ^ B[4] ^ G[3];
  assign G[4] = (A[4] & B[4]) | (A[4] & G[3]) | (B[4] & G[3]);
  
  assign P[5] = A[5] ^ B[5] ^ G[4];
  assign G[5] = (A[5] & B[5]) | (A[5] & G[4]) | (B[5] & G[4]);
  
  assign P[6] = A[6] ^ B[6] ^ G[5];
  assign G[6] = (A[6] & B[6]) | (A[6] & G[5]) | (B[6] & G[5]);
  
  assign P[7] = A[7] ^ B[7] ^ G[6];
  assign G[7] = (A[7] & B[7]) | (A[7] & G[6]) | (B[7] & G[6]);
  
  assign P[8] = A[8] ^ B[8] ^ G[7];
  assign G[8] = (A[8] & B[8]) | (A[8] & G[7]) | (B[8] & G[7]);
  
  assign P[9] = A[9] ^ B[9] ^ G[8];
  assign G[9] = (A[9] & B[9]) | (A[9] & G[8]) | (B[9] & G[8]);
  
  assign P[10] = A[10] ^ B[10] ^ G[9];
  assign G[10] = (A[10] & B[10]) | (A[10] & G[9]) | (B[10] & G[9]);
  
  assign P[11] = A[11] ^ B[11] ^ G[10];
  assign G[11] = (A[11] & B[11]) | (A[11] & G[10]) | (B[11] & G[10]);
  
  assign P[12] = A[12] ^ B[12] ^ G[11];
  assign G[12] = (A[12] & B[12]) | (A[12] & G[11]) | (B[12] & G[11]);
  
  assign P[13] = A[13] ^ B[13] ^ G[12];
  assign G[13] = (A[13] & B[13]) | (A[13] & G[12]) | (B[13] & G[12]);
  
  assign P[14] = A[14] ^ B[14] ^ G[13];
  assign G[14] = (A[14] & B[14]) | (A[14] & G[13]) | (B[14] & G[13]);
  
  assign P[15] = A[15] ^ B[15] ^ G[14];
  assign G[15] = (A[15] & B[15]) | (A[15] & G[14]) | (B[15] & G[14]);
  
  assign P[16] = A[16] ^ B[16] ^ G[15];
  assign G[16] = (A[16] & B[16]) | (A[16] & G[15]) | (B[16] & G[15]);
  
  assign P[17] = A[17] ^ B[17] ^ G[16];
  assign G[17] = (A[17] & B[17]) | (A[17] & G[16]) | (B[17] & G[16]);
  
  assign P[18] = A[18] ^ B[18] ^ G[17];
  assign G[18] = (A[18] & B[18]) | (A[18] & G[17]) | (B[18] & G[17]);
  
  assign P[19] = A[19] ^ B[19] ^ G[18];
  assign G[19] = (A[19] & B[19]) | (A[19] & G[18]) | (B[19] & G[18]);
  
  assign P[20] = A[20] ^ B[20] ^ G[19];
  assign G[20] = (A[20] & B[20]) | (A[20] & G[19]) | (B[20] & G[19]);
  
  assign P[21] = A[21] ^ B[21] ^ G[20];
  assign G[21] = (A[21] & B[21]) | (A[21] & G[20]) | (B[21] & G[20]);
  
  assign P[22] = A[22] ^ B[22] ^ G[21];
  assign G[22] = (A[22] & B[22]) | (A[22] & G[21]) | (B[22] & G[21]);
  
  assign P[23] = A[23] ^ B[23] ^ G[22];
  assign G[23] = (A[23] & B[23]) | (A[23] & G[22]) | (B[23] & G[22]);

  assign Sum = P ^ Cin;
  assign Cout = G[23] | (P[23] & Cin);

endmodule

module carry_look_adder_16bit(A, B, Sum);
    input [15:0] A;
    input [15:0] B;
    output [15:0] Sum;
    
    wire Cin;
    wire [15:0] P, G;
    assign Cin = 1'b0;
  
  assign P[0] = A[0] ^ B[0];
  assign G[0] = A[0] & B[0];
  
  assign P[1] = A[1] ^ B[1] ^ G[0];
  assign G[1] = (A[1] & B[1]) | (A[1] & G[0]) | (B[1] & G[0]);
  
  assign P[2] = A[2] ^ B[2] ^ G[1];
  assign G[2] = (A[2] & B[2]) | (A[2] & G[1]) | (B[2] & G[1]);
  
  assign P[3] = A[3] ^ B[3] ^ G[2];
  assign G[3] = (A[3] & B[3]) | (A[3] & G[2]) | (B[3] & G[2]);
  
  assign P[4] = A[4] ^ B[4] ^ G[3];
  assign G[4] = (A[4] & B[4]) | (A[4] & G[3]) | (B[4] & G[3]);
  
  assign P[5] = A[5] ^ B[5] ^ G[4];
  assign G[5] = (A[5] & B[5]) | (A[5] & G[4]) | (B[5] & G[4]);
  
  assign P[6] = A[6] ^ B[6] ^ G[5];
  assign G[6] = (A[6] & B[6]) | (A[6] & G[5]) | (B[6] & G[5]);
  
  assign P[7] = A[7] ^ B[7] ^ G[6];
  assign G[7] = (A[7] & B[7]) | (A[7] & G[6]) | (B[7] & G[6]);
  
  assign P[8] = A[8] ^ B[8] ^ G[7];
  assign G[8] = (A[8] & B[8]) | (A[8] & G[7]) | (B[8] & G[7]);
  
  assign P[9] = A[9] ^ B[9] ^ G[8];
  assign G[9] = (A[9] & B[9]) | (A[9] & G[8]) | (B[9] & G[8]);
  
  assign P[10] = A[10] ^ B[10] ^ G[9];
  assign G[10] = (A[10] & B[10]) | (A[10] & G[9]) | (B[10] & G[9]);
  
  assign P[11] = A[11] ^ B[11] ^ G[10];
  assign G[11] = (A[11] & B[11]) | (A[11] & G[10]) | (B[11] & G[10]);
  
  assign P[12] = A[12] ^ B[12] ^ G[11];
  assign G[12] = (A[12] & B[12]) | (A[12] & G[11]) | (B[12] & G[11]);
  
  assign P[13] = A[13] ^ B[13] ^ G[12];
  assign G[13] = (A[13] & B[13]) | (A[13] & G[12]) | (B[13] & G[12]);
  
  assign P[14] = A[14] ^ B[14] ^ G[13];
  assign G[14] = (A[14] & B[14]) | (A[14] & G[13]) | (B[14] & G[13]);
  
  assign P[15] = A[15] ^ B[15] ^ G[14];
  assign G[15] = (A[15] & B[15]) | (A[15] & G[14]) | (B[15] & G[14]);

  assign Sum = P ^ Cin;
  assign Cout = G[15] | (P[15] & Cin);

endmodule

module carry_look_adder_12bit(A, B, Sum);
    input [11:0] A;
    input [11:0] B;
    output [11:0] Sum;
    
    wire Cin;
    wire [11:0] P, G;
    assign Cin = 1'b0;
  
  assign P[0] = A[0] ^ B[0];
  assign G[0] = A[0] & B[0];
  
  assign P[1] = A[1] ^ B[1] ^ G[0];
  assign G[1] = (A[1] & B[1]) | (A[1] & G[0]) | (B[1] & G[0]);
  
  assign P[2] = A[2] ^ B[2] ^ G[1];
  assign G[2] = (A[2] & B[2]) | (A[2] & G[1]) | (B[2] & G[1]);
  
  assign P[3] = A[3] ^ B[3] ^ G[2];
  assign G[3] = (A[3] & B[3]) | (A[3] & G[2]) | (B[3] & G[2]);
  
  assign P[4] = A[4] ^ B[4] ^ G[3];
  assign G[4] = (A[4] & B[4]) | (A[4] & G[3]) | (B[4] & G[3]);
  
  assign P[5] = A[5] ^ B[5] ^ G[4];
  assign G[5] = (A[5] & B[5]) | (A[5] & G[4]) | (B[5] & G[4]);
  
  assign P[6] = A[6] ^ B[6] ^ G[5];
  assign G[6] = (A[6] & B[6]) | (A[6] & G[5]) | (B[6] & G[5]);
  
  assign P[7] = A[7] ^ B[7] ^ G[6];
  assign G[7] = (A[7] & B[7]) | (A[7] & G[6]) | (B[7] & G[6]);
  
  assign P[8] = A[8] ^ B[8] ^ G[7];
  assign G[8] = (A[8] & B[8]) | (A[8] & G[7]) | (B[8] & G[7]);
  
  assign P[9] = A[9] ^ B[9] ^ G[8];
  assign G[9] = (A[9] & B[9]) | (A[9] & G[8]) | (B[9] & G[8]);
  
  assign P[10] = A[10] ^ B[10] ^ G[9];
  assign G[10] = (A[10] & B[10]) | (A[10] & G[9]) | (B[10] & G[9]);
  
  assign P[11] = A[11] ^ B[11] ^ G[10];
  assign G[11] = (A[11] & B[11]) | (A[11] & G[10]) | (B[11] & G[10]);

  assign Sum = P ^ Cin;
  assign Cout = G[11] | (P[11] & Cin);

endmodule

module carry_look_adder_8bit(A, B, Sum);
    input [7:0] A;
    input [7:0] B;
    output [7:0] Sum;
    
    wire Cin;
    wire [7:0] P, G;
    assign Cin = 1'b0;
  
  assign P[0] = A[0] ^ B[0];
  assign G[0] = A[0] & B[0];
  
  assign P[1] = A[1] ^ B[1] ^ G[0];
  assign G[1] = (A[1] & B[1]) | (A[1] & G[0]) | (B[1] & G[0]);
  
  assign P[2] = A[2] ^ B[2] ^ G[1];
  assign G[2] = (A[2] & B[2]) | (A[2] & G[1]) | (B[2] & G[1]);
  
  assign P[3] = A[3] ^ B[3] ^ G[2];
  assign G[3] = (A[3] & B[3]) | (A[3] & G[2]) | (B[3] & G[2]);
  
  assign P[4] = A[4] ^ B[4] ^ G[3];
  assign G[4] = (A[4] & B[4]) | (A[4] & G[3]) | (B[4] & G[3]);
  
  assign P[5] = A[5] ^ B[5] ^ G[4];
  assign G[5] = (A[5] & B[5]) | (A[5] & G[4]) | (B[5] & G[4]);
  
  assign P[6] = A[6] ^ B[6] ^ G[5];
  assign G[6] = (A[6] & B[6]) | (A[6] & G[5]) | (B[6] & G[5]);
  
  assign P[7] = A[7] ^ B[7] ^ G[6];
  assign G[7] = (A[7] & B[7]) | (A[7] & G[6]) | (B[7] & G[6]);

  assign Sum = P ^ Cin;
  assign Cout = G[7] | (P[7] & Cin);

endmodule



module carry_look_adder_6bit(A, B, Sum);
    input [5:0] A;
    input [5:0] B;
    output [5:0] Sum;
    
    wire Cin;
    wire [5:0] P, G;
    assign Cin = 1'b0;
  
  assign P[0] = A[0] ^ B[0];
  assign G[0] = A[0] & B[0];
  
  assign P[1] = A[1] ^ B[1] ^ G[0];
  assign G[1] = (A[1] & B[1]) | (A[1] & G[0]) | (B[1] & G[0]);
  
  assign P[2] = A[2] ^ B[2] ^ G[1];
  assign G[2] = (A[2] & B[2]) | (A[2] & G[1]) | (B[2] & G[1]);
  
  assign P[3] = A[3] ^ B[3] ^ G[2];
  assign G[3] = (A[3] & B[3]) | (A[3] & G[2]) | (B[3] & G[2]);
  
  assign P[4] = A[4] ^ B[4] ^ G[3];
  assign G[4] = (A[4] & B[4]) | (A[4] & G[3]) | (B[4] & G[3]);
  
  assign P[5] = A[5] ^ B[5] ^ G[4];
  assign G[5] = (A[5] & B[5]) | (A[5] & G[4]) | (B[5] & G[4]);

  assign Sum = P ^ Cin;
  assign Cout = G[5] | (P[5] & Cin);

endmodule


module carry_look_adder_4bit(A, B, Sum);
    input [3:0] A;
    input [3:0] B;
    output [3:0] Sum;
    
    wire Cin;
    wire [3:0] P, G;
    assign Cin = 1'b0;
  
  assign P[0] = A[0] ^ B[0];
  assign G[0] = A[0] & B[0];
  
  assign P[1] = A[1] ^ B[1] ^ G[0];
  assign G[1] = (A[1] & B[1]) | (A[1] & G[0]) | (B[1] & G[0]);
  
  assign P[2] = A[2] ^ B[2] ^ G[1];
  assign G[2] = (A[2] & B[2]) | (A[2] & G[1]) | (B[2] & G[1]);
  
  assign P[3] = A[3] ^ B[3] ^ G[2];
  assign G[3] = (A[3] & B[3]) | (A[3] & G[2]) | (B[3] & G[2]);

  assign Sum = P ^ Cin;
  assign Cout = G[3] | (P[3] & Cin);

endmodule
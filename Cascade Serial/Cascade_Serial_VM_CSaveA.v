
`timescale 1 ns / 1 ns

module Cascade_Serial_VM_CSaveA
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
  wire c0,c1,c2,c3;
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
  //assign mul_temp = inputmux_1 * product_1_mux;
  vedic_16x16 m1(inputmux_1,product_1_mux,mul_temp);
  assign product_1 = mul_temp[30:0];

  assign prod_typeconvert_1 = $signed({{2{product_1[30]}}, product_1});

  assign acc_cscade_1 = (phase_4 == 1'b1) ? acc_out_2 :
                       prod_typeconvert_1;

  assign add_signext = acc_cscade_1;
  assign add_signext_1 = acc_out_1;
  //assign add_temp = add_signext + add_signext_1;
  
  assign c1=1'b0;
  csa_32 a1(add_temp,c0,add_signext,add_signext_1,c1);
  assign acc_sum_1 = add_temp[31:0];

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
  //assign mul_temp_1 = inputmux_2 * product_2_mux;
  vedic_16x16 m2(inputmux_2,product_2_mux,mul_temp_1);
  assign product_2 = mul_temp_1[30:0];

  assign prod_typeconvert_2 = $signed({{2{product_2[30]}}, product_2});

  assign add_signext_2 = prod_typeconvert_2;
  assign add_signext_3 = acc_out_2;
  //assign add_temp_1 = add_signext_2 + add_signext_3;
  
  assign c3=1'b0;
  csa_32 a2(add_temp_1,c2,add_signext_2,add_signext_3,c3);
  assign acc_sum_2 = add_temp_1[31:0];

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

csa_16 A3(temp1, temp2, q4);
csa_24 A4(temp3, temp4, q5);
csa_24 A5({8'b00000000,q4}, q5, q6);

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

csa_8 A3(temp1, temp2, q4);
csa_12 A4(temp3, temp4, q5);
csa_12 A5({4'b0000,q4}, q5, q6);

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
csa_4 A0(q1[3:0], temp1, q4);
assign temp2= {2'b00, q2[3:0]};
assign temp3= {q3[3:0], 2'b00};
csa_6 A1(temp2, temp3, q5);
assign temp4= {2'b00, q4[3:0]};
csa_6 A2(temp4, q5, q6);
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

module fa(a,b,cin,sum,carry);
  input a,b,cin;
  output sum;
  output carry;
  assign sum=a^b^cin;
  assign carry=(a&b)|(a&cin)|(b&cin);
 endmodule
  
module csa_32(s, c, x, y, z1);
  input [31:0] x,y;
  input z1;
  output [31:0] s;
  output c;
  wire cc;
  wire [31:0] c1,s1,c2,z;
  assign z=0;
  fa f0(x[0],y[0],z1,s1[0],c1[0]);
  fa f1(x[1],y[1],z[1],s1[1],c1[1]);
  fa f2(x[2],y[2],z[2],s1[2],c1[2]);
  fa f3(x[3],y[3],z[3],s1[3],c1[3]);
  fa f4(x[4],y[4],z[4],s1[4],c1[4]);
  fa f5(x[5],y[5],z[5],s1[5],c1[5]);
  fa f6(x[6],y[6],z[6],s1[6],c1[6]);
  fa f7(x[7],y[7],z[7],s1[7],c1[7]);
  fa f8(x[8],y[8],z[8],s1[8],c1[8]);
  fa f9(x[9],y[9],z[9],s1[9],c1[9]);
  fa f10(x[10],y[10],z[10],s1[10],c1[10]);
  fa f11(x[11],y[11],z[11],s1[11],c1[11]);
  fa f12(x[12],y[12],z[12],s1[12],c1[12]);
  fa f13(x[13],y[13],z[13],s1[13],c1[13]);
  fa f14(x[14],y[14],z[14],s1[14],c1[14]);
  fa f15(x[15],y[15],z[15],s1[15],c1[15]);
  fa f16(x[16],y[16],z[16],s1[16],c1[16]);
  fa f17(x[17],y[17],z[17],s1[17],c1[17]);
  fa f18(x[18],y[18],z[18],s1[18],c1[18]);
  fa f19(x[19],y[19],z[19],s1[19],c1[19]);
  fa f20(x[20],y[20],z[20],s1[20],c1[20]);
  fa f21(x[21],y[21],z[21],s1[21],c1[21]);
  fa f22(x[22],y[22],z[22],s1[22],c1[22]);
  fa f23(x[23],y[23],z[23],s1[23],c1[23]);
  fa f24(x[24],y[24],z[24],s1[24],c1[24]);
  fa f25(x[25],y[25],z[25],s1[25],c1[25]);
  fa f26(x[26],y[26],z[26],s1[26],c1[26]);
  fa f27(x[27],y[27],z[27],s1[27],c1[27]);
  fa f28(x[28],y[28],z[28],s1[28],c1[28]);
  fa f29(x[29],y[29],z[29],s1[29],c1[29]);
  fa f30(x[30],y[30],z[30],s1[30],c1[30]);
  fa f31(x[31],y[31],z[31],s1[31],c1[31]);
  assign c2[0]=1'b0;
  fa f1_0(s1[1],c1[0],c2[0],s[1],c2[1]);
  fa f1_1(s1[2],c1[1],c2[1],s[2],c2[2]);
  fa f1_2(s1[3],c1[2],c2[2],s[3],c2[3]);
  fa f1_3(s1[4],c1[3],c2[3],s[4],c2[4]);
  fa f1_4(s1[5],c1[4],c2[4],s[5],c2[5]);
  fa f1_5(s1[6],c1[5],c2[5],s[6],c2[6]);
  fa f1_6(s1[7],c1[6],c2[6],s[7],c2[7]);
  fa f1_7(s1[8],c1[7],c2[7],s[8],c2[8]);
  fa f1_8(s1[9],c1[8],c2[8],s[9],c2[9]);
  fa f1_9(s1[10],c1[9],c2[9],s[10],c2[10]);
  fa f1_10(s1[11],c1[10],c2[10],s[11],c2[11]);
  fa f1_11(s1[12],c1[11],c2[11],s[12],c2[12]);
  fa f1_12(s1[13],c1[12],c2[12],s[13],c2[13]);
  fa f1_13(s1[14],c1[13],c2[13],s[14],c2[14]);
  fa f1_14(s1[15],c1[14],c2[14],s[15],c2[15]);
  fa f1_15(s1[16],c1[15],c2[15],s[16],c2[16]);
  fa f1_16(s1[17],c1[16],c2[16],s[17],c2[17]);
  fa f1_17(s1[18],c1[17],c2[17],s[18],c2[18]);
  fa f1_18(s1[19],c1[18],c2[18],s[19],c2[19]);
  fa f1_19(s1[20],c1[19],c2[19],s[20],c2[20]);
  fa f1_20(s1[21],c1[20],c2[20],s[21],c2[21]);
  fa f1_21(s1[22],c1[21],c2[21],s[22],c2[22]);
  fa f1_22(s1[23],c1[22],c2[22],s[23],c2[23]);
  fa f1_23(s1[24],c1[23],c2[23],s[24],c2[24]);
  fa f1_24(s1[25],c1[24],c2[24],s[25],c2[25]);
  fa f1_25(s1[26],c1[25],c2[25],s[26],c2[26]);
  fa f1_26(s1[27],c1[26],c2[26],s[27],c2[27]);
  fa f1_27(s1[28],c1[27],c2[27],s[28],c2[28]);
  fa f1_28(s1[29],c1[28],c2[28],s[29],c2[29]);
  fa f1_29(s1[30],c1[29],c2[29],s[30],c2[30]);
  fa f1_30(s1[31],c1[30],c2[30],s[31],c2[31]);
  fa f1_31(1'b0,c1[31],c2[31],c,cc);
  assign s[0]=s1[0];
endmodule

module csa_24(x, y, s);
  input [23:0] x,y;
  output [23:0] s;
  wire c,cc;
  wire [23:0] z;
  wire [23:0] c1,s1,c2;
  assign z=0;
  fa f0(x[0],y[0],z[0],s1[0],c1[0]);
  fa f1(x[1],y[1],z[1],s1[1],c1[1]);
  fa f2(x[2],y[2],z[2],s1[2],c1[2]);
  fa f3(x[3],y[3],z[3],s1[3],c1[3]);
  fa f4(x[4],y[4],z[4],s1[4],c1[4]);
  fa f5(x[5],y[5],z[5],s1[5],c1[5]);
  fa f6(x[6],y[6],z[6],s1[6],c1[6]);
  fa f7(x[7],y[7],z[7],s1[7],c1[7]);
  fa f8(x[8],y[8],z[8],s1[8],c1[8]);
  fa f9(x[9],y[9],z[9],s1[9],c1[9]);
  fa f10(x[10],y[10],z[10],s1[10],c1[10]);
  fa f11(x[11],y[11],z[11],s1[11],c1[11]);
  fa f12(x[12],y[12],z[12],s1[12],c1[12]);
  fa f13(x[13],y[13],z[13],s1[13],c1[13]);
  fa f14(x[14],y[14],z[14],s1[14],c1[14]);
  fa f15(x[15],y[15],z[15],s1[15],c1[15]);
  fa f16(x[16],y[16],z[16],s1[16],c1[16]);
  fa f17(x[17],y[17],z[17],s1[17],c1[17]);
  fa f18(x[18],y[18],z[18],s1[18],c1[18]);
  fa f19(x[19],y[19],z[19],s1[19],c1[19]);
  fa f20(x[20],y[20],z[20],s1[20],c1[20]);
  fa f21(x[21],y[21],z[21],s1[21],c1[21]);
  fa f22(x[22],y[22],z[22],s1[22],c1[22]);
  fa f23(x[23],y[23],z[23],s1[23],c1[23]);
  assign c2[0]=1'b0;
  fa f1_0(s1[1],c1[0],c2[0],s[1],c2[1]);
  fa f1_1(s1[2],c1[1],c2[1],s[2],c2[2]);
  fa f1_2(s1[3],c1[2],c2[2],s[3],c2[3]);
  fa f1_3(s1[4],c1[3],c2[3],s[4],c2[4]);
  fa f1_4(s1[5],c1[4],c2[4],s[5],c2[5]);
  fa f1_5(s1[6],c1[5],c2[5],s[6],c2[6]);
  fa f1_6(s1[7],c1[6],c2[6],s[7],c2[7]);
  fa f1_7(s1[8],c1[7],c2[7],s[8],c2[8]);
  fa f1_8(s1[9],c1[8],c2[8],s[9],c2[9]);
  fa f1_9(s1[10],c1[9],c2[9],s[10],c2[10]);
  fa f1_10(s1[11],c1[10],c2[10],s[11],c2[11]);
  fa f1_11(s1[12],c1[11],c2[11],s[12],c2[12]);
  fa f1_12(s1[13],c1[12],c2[12],s[13],c2[13]);
  fa f1_13(s1[14],c1[13],c2[13],s[14],c2[14]);
  fa f1_14(s1[15],c1[14],c2[14],s[15],c2[15]);
  fa f1_15(s1[16],c1[15],c2[15],s[16],c2[16]);
  fa f1_16(s1[17],c1[16],c2[16],s[17],c2[17]);
  fa f1_17(s1[18],c1[17],c2[17],s[18],c2[18]);
  fa f1_18(s1[19],c1[18],c2[18],s[19],c2[19]);
  fa f1_19(s1[20],c1[19],c2[19],s[20],c2[20]);
  fa f1_20(s1[21],c1[20],c2[20],s[21],c2[21]);
  fa f1_21(s1[22],c1[21],c2[21],s[22],c2[22]);
  fa f1_22(s1[23],c1[22],c2[22],s[23],c2[23]);
  fa f1_23(1'b0,c1[23],c2[23],c,cc);
  assign s[0]=s1[0];
endmodule 

module csa_16(x, y, s);
  input [15:0] x,y;
  wire [15:0] z;
  output [15:0] s;
  wire c,cc;
  wire [15:0] c1,s1,c2;
  assign z=0;
  fa f0(x[0],y[0],z[0],s1[0],c1[0]);
  fa f1(x[1],y[1],z[1],s1[1],c1[1]);
  fa f2(x[2],y[2],z[2],s1[2],c1[2]);
  fa f3(x[3],y[3],z[3],s1[3],c1[3]);
  fa f4(x[4],y[4],z[4],s1[4],c1[4]);
  fa f5(x[5],y[5],z[5],s1[5],c1[5]);
  fa f6(x[6],y[6],z[6],s1[6],c1[6]);
  fa f7(x[7],y[7],z[7],s1[7],c1[7]);
  fa f8(x[8],y[8],z[8],s1[8],c1[8]);
  fa f9(x[9],y[9],z[9],s1[9],c1[9]);
  fa f10(x[10],y[10],z[10],s1[10],c1[10]);
  fa f11(x[11],y[11],z[11],s1[11],c1[11]);
  fa f12(x[12],y[12],z[12],s1[12],c1[12]);
  fa f13(x[13],y[13],z[13],s1[13],c1[13]);
  fa f14(x[14],y[14],z[14],s1[14],c1[14]);
  fa f15(x[15],y[15],z[15],s1[15],c1[15]);
  assign c2[0]=1'b0;
  fa f1_0(s1[1],c1[0],c2[0],s[1],c2[1]);
  fa f1_1(s1[2],c1[1],c2[1],s[2],c2[2]);
  fa f1_2(s1[3],c1[2],c2[2],s[3],c2[3]);
  fa f1_3(s1[4],c1[3],c2[3],s[4],c2[4]);
  fa f1_4(s1[5],c1[4],c2[4],s[5],c2[5]);
  fa f1_5(s1[6],c1[5],c2[5],s[6],c2[6]);
  fa f1_6(s1[7],c1[6],c2[6],s[7],c2[7]);
  fa f1_7(s1[8],c1[7],c2[7],s[8],c2[8]);
  fa f1_8(s1[9],c1[8],c2[8],s[9],c2[9]);
  fa f1_9(s1[10],c1[9],c2[9],s[10],c2[10]);
  fa f1_10(s1[11],c1[10],c2[10],s[11],c2[11]);
  fa f1_11(s1[12],c1[11],c2[11],s[12],c2[12]);
  fa f1_12(s1[13],c1[12],c2[12],s[13],c2[13]);
  fa f1_13(s1[14],c1[13],c2[13],s[14],c2[14]);
  fa f1_14(s1[15],c1[14],c2[14],s[15],c2[15]);
  fa f1_15(1'b0,c1[15],c2[15],c,cc);
  assign s[0]=s1[0];
endmodule 


module csa_12(x, y, s);
  input [11:0] x,y;
  wire [11:0] z;
  output [11:0] s;
  wire c,cc;
  wire [11:0] c1,s1,c2;
  assign z=0;
  fa f0(x[0],y[0],z[0],s1[0],c1[0]);
  fa f1(x[1],y[1],z[1],s1[1],c1[1]);
  fa f2(x[2],y[2],z[2],s1[2],c1[2]);
  fa f3(x[3],y[3],z[3],s1[3],c1[3]);
  fa f4(x[4],y[4],z[4],s1[4],c1[4]);
  fa f5(x[5],y[5],z[5],s1[5],c1[5]);
  fa f6(x[6],y[6],z[6],s1[6],c1[6]);
  fa f7(x[7],y[7],z[7],s1[7],c1[7]);
  fa f8(x[8],y[8],z[8],s1[8],c1[8]);
  fa f9(x[9],y[9],z[9],s1[9],c1[9]);
  fa f10(x[10],y[10],z[10],s1[10],c1[10]);
  fa f11(x[11],y[11],z[11],s1[11],c1[11]);
  assign c2[0]=1'b0;
  fa f1_0(s1[1],c1[0],c2[0],s[1],c2[1]);
  fa f1_1(s1[2],c1[1],c2[1],s[2],c2[2]);
  fa f1_2(s1[3],c1[2],c2[2],s[3],c2[3]);
  fa f1_3(s1[4],c1[3],c2[3],s[4],c2[4]);
  fa f1_4(s1[5],c1[4],c2[4],s[5],c2[5]);
  fa f1_5(s1[6],c1[5],c2[5],s[6],c2[6]);
  fa f1_6(s1[7],c1[6],c2[6],s[7],c2[7]);
  fa f1_7(s1[8],c1[7],c2[7],s[8],c2[8]);
  fa f1_8(s1[9],c1[8],c2[8],s[9],c2[9]);
  fa f1_9(s1[10],c1[9],c2[9],s[10],c2[10]);
  fa f1_10(s1[11],c1[10],c2[10],s[11],c2[11]);
  fa f1_11(1'b0,c1[11],c2[11],c,cc);
  assign s[0]=s1[0];
endmodule 


module csa_8(x, y, s);
  input [7:0] x,y;
  wire [7:0] z;
  output [7:0] s;
  wire c,cc;
  wire [7:0] c1,s1,c2;
  assign z=0;
  fa f0(x[0],y[0],z[0],s1[0],c1[0]);
  fa f1(x[1],y[1],z[1],s1[1],c1[1]);
  fa f2(x[2],y[2],z[2],s1[2],c1[2]);
  fa f3(x[3],y[3],z[3],s1[3],c1[3]);
  fa f4(x[4],y[4],z[4],s1[4],c1[4]);
  fa f5(x[5],y[5],z[5],s1[5],c1[5]);
  fa f6(x[6],y[6],z[6],s1[6],c1[6]);
  fa f7(x[7],y[7],z[7],s1[7],c1[7]);
  assign c2[0]=1'b0;
  fa f1_0(s1[1],c1[0],c2[0],s[1],c2[1]);
  fa f1_1(s1[2],c1[1],c2[1],s[2],c2[2]);
  fa f1_2(s1[3],c1[2],c2[2],s[3],c2[3]);
  fa f1_3(s1[4],c1[3],c2[3],s[4],c2[4]);
  fa f1_4(s1[5],c1[4],c2[4],s[5],c2[5]);
  fa f1_5(s1[6],c1[5],c2[5],s[6],c2[6]);
  fa f1_6(s1[7],c1[6],c2[6],s[7],c2[7]);
  fa f1_7(1'b0,c1[7],c2[7],c,cc);
  assign s[0]=s1[0];
endmodule 


module csa_6(x, y, s);
  input [5:0] x,y;
  wire [5:0] z;
  output [5:0] s;
  wire c,cc;
  wire [5:0] c1,s1,c2;
  assign z=0;
  fa f0(x[0],y[0],z[0],s1[0],c1[0]);
  fa f1(x[1],y[1],z[1],s1[1],c1[1]);
  fa f2(x[2],y[2],z[2],s1[2],c1[2]);
  fa f3(x[3],y[3],z[3],s1[3],c1[3]);
  fa f4(x[4],y[4],z[4],s1[4],c1[4]);
  fa f5(x[5],y[5],z[5],s1[5],c1[5]);
  assign c2[0]=1'b0;
  fa f1_0(s1[1],c1[0],c2[0],s[1],c2[1]);
  fa f1_1(s1[2],c1[1],c2[1],s[2],c2[2]);
  fa f1_2(s1[3],c1[2],c2[2],s[3],c2[3]);
  fa f1_3(s1[4],c1[3],c2[3],s[4],c2[4]);
  fa f1_4(s1[5],c1[4],c2[4],s[5],c2[5]);
  fa f1_5(1'b0,c1[5],c2[5],c,cc);
  assign s[0]=s1[0];
endmodule 


module csa_4(x, y, s);
  input [3:0] x,y;
  output [3:0] s;
  wire [3:0] z;
  wire c,cc;
  wire [3:0] c1,s1,c2;
  assign z=0;
  fa f0(x[0],y[0],z[0],s1[0],c1[0]);
  fa f1(x[1],y[1],z[1],s1[1],c1[1]);
  fa f2(x[2],y[2],z[2],s1[2],c1[2]);
  fa f3(x[3],y[3],z[3],s1[3],c1[3]);
  assign c2[0]=1'b0;
  fa f1_0(s1[1],c1[0],c2[0],s[1],c2[1]);
  fa f1_1(s1[2],c1[1],c2[1],s[2],c2[2]);
  fa f1_2(s1[3],c1[2],c2[2],s[3],c2[3]);
  fa f1_3(1'b0,c1[3],c2[3],c,cc);
  assign s[0]=s1[0];
endmodule
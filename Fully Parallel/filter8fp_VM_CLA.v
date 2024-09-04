`timescale 1ns / 1ps

module filter8fp_VM_CLA
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
  input   signed [15:0] filter_in;
  output  signed [32:0] filter_out;

    parameter signed [15:0] coeff1 = 16'b1101110110111011;
    parameter signed [15:0] coeff2 = 16'b1110101010001110;
    parameter signed [15:0] coeff3 = 16'b0011001111011011;
    parameter signed [15:0] coeff4 = 16'b0110100000001000;
    parameter signed [15:0] coeff5 = 16'b0110100000001000;
    parameter signed [15:0] coeff6 = 16'b0011001111011011;
    parameter signed [15:0] coeff7 = 16'b1110101010001110;
    parameter signed [15:0] coeff8 = 16'b1101110110111011;

  reg  signed [15:0] delay_pipeline [0:7] ; 
  wire signed [31:0] product8; 
  wire signed [31:0] mul_temp;
  wire signed [31:0] product7; 
  wire signed [31:0] mul_temp_1; 
  wire signed [31:0] product6; 
  wire signed [31:0] mul_temp_2; 
  wire signed [31:0] product5; 
  wire signed [31:0] mul_temp_3; 
  wire signed [31:0] product4; 
  wire signed [31:0] mul_temp_4; 
  wire signed [31:0] product3; 
  wire signed [31:0] mul_temp_5;
  wire signed [31:0] product2;
  wire signed [31:0] mul_temp_6;
  wire signed [31:0] product1;
  wire signed [31:0] mul_temp_7; 
  wire signed [31:0] sum1; 
  wire signed [31:0] add_signext;
  wire signed [31:0] add_signext_1;
  wire signed [31:0] add_temp;
  wire signed [31:0] sum2;
  wire signed [31:0] add_signext_2;
  wire signed [31:0] add_signext_3;
  wire signed [31:0] add_temp_1; 
  wire signed [31:0] sum3;
  wire signed [31:0] add_signext_4;
  wire signed [31:0] add_signext_5;
  wire signed [31:0] add_temp_2; 
  wire signed [31:0] sum4;
  wire signed [31:0] add_signext_6; 
  wire signed [31:0] add_signext_7; 
  wire signed [31:0] add_temp_3;
  wire signed [31:0] sum5;
  wire signed [31:0] add_signext_8;
  wire signed [31:0] add_signext_9;
  wire signed [31:0] add_temp_4;
  wire signed [31:0] sum6; 
  wire signed [31:0] add_signext_10; 
  wire signed [31:0] add_signext_11; 
  wire signed [31:0] add_temp_5;
  wire signed [31:0] sum7;
  wire signed [31:0] add_signext_12;
  wire signed [31:0] add_signext_13;
  wire signed [31:0] add_temp_6;
  reg  signed [32:0] output_register;

  wire c0,c1,c2,c3,c4,c5,Cout;
  wire cin,e1,e2,e3,e4,e5,e6;

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
    end

      vedic_16x16 u1(delay_pipeline[7] , coeff8,mul_temp);
          assign product8 = mul_temp[31:0];
        vedic_16x16 u2(delay_pipeline[6] , coeff7,mul_temp_1);
          assign product7 = mul_temp_1[31:0];
         vedic_16x16 u3(delay_pipeline[5] , coeff6,mul_temp_2);
          assign product6 = mul_temp_2[31:0];
        vedic_16x16 u4(delay_pipeline[4] , coeff5,mul_temp_3);
          assign product5 = mul_temp_3[31:0];
         vedic_16x16 u5(delay_pipeline[3] , coeff4,mul_temp_4);
          assign product4 = mul_temp_4[31:0];
        vedic_16x16 u6(delay_pipeline[2] , coeff3,mul_temp_5);
          assign product3 = mul_temp_5[31:0];
        vedic_16x16 u7(delay_pipeline[1] , coeff2,mul_temp_6);
          assign product2 = mul_temp_6[31:0];
        vedic_16x16 u8(delay_pipeline[0] , coeff1,mul_temp_7);
      assign product1 = mul_temp_7[31:0];
  assign add_signext = product1;
  assign add_signext_1 = product2;
assign cin = 1'b0;
  carry_look_adder_32bit g1(add_temp,c0, add_signext,add_signext_1,cin);
  assign sum1 =  add_temp;
  assign add_signext_2 = sum1;
  assign add_signext_3 = product3;
 carry_look_adder_32bit g2(add_temp_1,c1, add_signext_2,add_signext_3,c0);
  assign sum2 = add_temp_1;

  assign add_signext_4 = sum2;
  assign add_signext_5 = product4;
  carry_look_adder_32bit g3(add_temp_2,c2, add_signext_4,add_signext_5,c1);
  assign sum3 = add_temp_2;

  assign add_signext_6 = sum3;
  assign add_signext_7 =  product5;
  carry_look_adder_32bit g4(add_temp_3,c3, add_signext_6,add_signext_7,c2);
  assign sum4 = add_temp_3;

  assign add_signext_8 = sum4;
  assign add_signext_9 =  product6;
  carry_look_adder_32bit g5(add_temp_4,c4, add_signext_8,add_signext_9,c3);
  assign sum5 = add_temp_4;

  assign add_signext_10 = sum5;
  assign add_signext_11 =  product7;
  carry_look_adder_32bit g6(add_temp_5,c5, add_signext_10,add_signext_11,c4);
  assign sum6 = add_temp_5;

  assign add_signext_12 = sum6;
  assign add_signext_13 =  product8;
  carry_look_adder_32bit g7(add_temp_6,Cout, add_signext_12,add_signext_13,c5);
  assign sum7 = add_temp_6;

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
    end 

  assign filter_out = output_register;
endmodule  // filter
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
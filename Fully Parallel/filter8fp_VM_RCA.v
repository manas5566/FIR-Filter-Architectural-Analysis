`timescale 1ns / 1ps

module filter8fp_VM_RCA
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
  ripple_carry_adder_32bit g1(add_temp,c0, add_signext,add_signext_1,cin);
  assign sum1 =  add_temp;
  assign add_signext_2 = sum1;
  assign add_signext_3 = product3;
 ripple_carry_adder_32bit g2(add_temp_1,c1, add_signext_2,add_signext_3,e1);
  assign sum2 = add_temp_1;

  assign add_signext_4 = sum2;
  assign add_signext_5 = product4;
  ripple_carry_adder_32bit g3(add_temp_2,c2, add_signext_4,add_signext_5,e2);
  assign sum3 = add_temp_2;

  assign add_signext_6 = sum3;
  assign add_signext_7 =  product5;
  ripple_carry_adder_32bit g4(add_temp_3,c3, add_signext_6,add_signext_7,e3);
  assign sum4 = add_temp_3;

  assign add_signext_8 = sum4;
  assign add_signext_9 =  product6;
  ripple_carry_adder_32bit g5(add_temp_4,c4, add_signext_8,add_signext_9,e4);
  assign sum5 = add_temp_4;

  assign add_signext_10 = sum5;
  assign add_signext_11 =  product7;
  ripple_carry_adder_32bit g6(add_temp_5,c5, add_signext_10,add_signext_11,e5);
  assign sum6 = add_temp_5;

  assign add_signext_12 = sum6;
  assign add_signext_13 =  product8;
  ripple_carry_adder_32bit g7(add_temp_6,Cout, add_signext_12,add_signext_13,e6);
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

ripple_carry_adder_16bit A3(temp1, temp2, q4);
ripple_carry_adder_24bit A4(temp3, temp4, q5);
ripple_carry_adder_24bit A5({8'b00000000,q4}, q5, q6);

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

ripple_carry_adder_8bit A3(temp1, temp2, q4);
ripple_carry_adder_12bit A4(temp3, temp4, q5);
ripple_carry_adder_12bit A5({4'b0000,q4}, q5, q6);

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
ripple_carry_adder_4bit A0(q1[3:0], temp1, q4);
assign temp2= {2'b00, q2[3:0]};
assign temp3= {q3[3:0], 2'b00};
ripple_carry_adder_6bit A1(temp2, temp3, q5);
assign temp4= {2'b00, q4[3:0]};
ripple_carry_adder_6bit A2(temp4, q5, q6);
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

module ripple_carry_adder_32bit(sum,Cout, A,B,cin);
input [31:0]A,B;
input cin;
output[31:0]sum;
output Cout;
wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31;

assign cin=1'b0;
RP_full_adder fa0(sum[0],c1,A[0],B[0],1'b0);
RP_full_adder fa1(sum[1],c2,A[1],B[1],c1);
RP_full_adder fa2(sum[2],c3,A[2],B[2],c2);
RP_full_adder fa3(sum[3],c4,A[3],B[3],c3);
RP_full_adder fa4(sum[4],c5,A[4],B[4],c4);
RP_full_adder fa5(sum[5],c6,A[5],B[5],c5);
RP_full_adder fa6(sum[6],c7,A[6],B[6],c6);
RP_full_adder fa7(sum[7],c8,A[7],B[7],c7);
RP_full_adder fa8(sum[8],c9,A[8],B[8],c8);
RP_full_adder fa9(sum[9],c10,A[9],B[9],c9);
RP_full_adder fa10(sum[10],c11,A[10],B[10],c10);
RP_full_adder fa11(sum[11],c12,A[11],B[11],c11);
RP_full_adder fa12(sum[12],c13,A[12],B[12],c12);
RP_full_adder fa13(sum[13],c14,A[13],B[13],c13);
RP_full_adder fa14(sum[14],c15,A[14],B[14],c14);
RP_full_adder fa15(sum[15],c16,A[15],B[15],c15);
RP_full_adder fa16(sum[16],c17,A[16],B[16],c16);
RP_full_adder fa17(sum[17],c18,A[17],B[17],c17);
RP_full_adder fa18(sum[18],c19,A[18],B[18],c18);
RP_full_adder fa19(sum[19],c20,A[19],B[19],c19);
RP_full_adder fa20(sum[20],c21,A[20],B[20],c20);
RP_full_adder fa21(sum[21],c22,A[21],B[21],c21);
RP_full_adder fa22(sum[22],c23,A[22],B[22],c22);
RP_full_adder fa23(sum[23],c24,A[23],B[23],c23);
RP_full_adder fa24(sum[24],c25,A[24],B[24],c24);
RP_full_adder fa25(sum[25],c26,A[25],B[25],c25);
RP_full_adder fa26(sum[26],c27,A[26],B[26],c26);
RP_full_adder fa27(sum[27],c28,A[27],B[27],c27);
RP_full_adder fa28(sum[28],c29,A[28],B[28],c28);
RP_full_adder fa29(sum[29],c30,A[29],B[29],c29);
RP_full_adder fa30(sum[30],c31,A[30],B[30],c30);
RP_full_adder fa31(sum[31],Cout,A[31],B[31],c31);

endmodule

module ripple_carry_adder_24bit(A,B,sum);
input [23:0]A,B;
output[23:0]sum;
wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24;

RP_full_adder fa0(sum[0],c1,A[0],B[0],1'b0);
RP_full_adder fa1(sum[1],c2,A[1],B[1],c1);
RP_full_adder fa2(sum[2],c3,A[2],B[2],c2);
RP_full_adder fa3(sum[3],c4,A[3],B[3],c3);
RP_full_adder fa4(sum[4],c5,A[4],B[4],c4);
RP_full_adder fa5(sum[5],c6,A[5],B[5],c5);
RP_full_adder fa6(sum[6],c7,A[6],B[6],c6);
RP_full_adder fa7(sum[7],c8,A[7],B[7],c7);
RP_full_adder fa8(sum[8],c9,A[8],B[8],c8);
RP_full_adder fa9(sum[9],c10,A[9],B[9],c9);
RP_full_adder fa10(sum[10],c11,A[10],B[10],c10);
RP_full_adder fa11(sum[11],c12,A[11],B[11],c11);
RP_full_adder fa12(sum[12],c13,A[12],B[12],c12);
RP_full_adder fa13(sum[13],c14,A[13],B[13],c13);
RP_full_adder fa14(sum[14],c15,A[14],B[14],c14);
RP_full_adder fa15(sum[15],c16,A[15],B[15],c15);
RP_full_adder fa16(sum[16],c17,A[16],B[16],c16);
RP_full_adder fa17(sum[17],c18,A[17],B[17],c17);
RP_full_adder fa18(sum[18],c19,A[18],B[18],c18);
RP_full_adder fa19(sum[19],c20,A[19],B[19],c19);
RP_full_adder fa20(sum[20],c21,A[20],B[20],c20);
RP_full_adder fa21(sum[21],c22,A[21],B[21],c21);
RP_full_adder fa22(sum[22],c23,A[22],B[22],c22);
RP_full_adder fa23(sum[23],c24,A[23],B[23],c23);
endmodule

module RP_full_adder(sum,Cout, A,B,cin );
input A ,B,cin;
output sum,Cout;
wire w;
    xor u1(w,A,B);
    xor u2(sum,w,cin);
    mux2_1 u3(Cout,w,A,cin);
endmodule

module mux2_1(Y,S,A,B);
input A,B,S;
output Y;
assign Y=((A&~S)|(B&S));
endmodule

module ripple_carry_adder_16bit(A,B,sum);
input [15:0]A,B;
output[15:0]sum;
wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16;

RP_full_adder fa0(sum[0],c1,A[0],B[0],1'b0);
RP_full_adder fa1(sum[1],c2,A[1],B[1],c1);
RP_full_adder fa2(sum[2],c3,A[2],B[2],c2);
RP_full_adder fa3(sum[3],c4,A[3],B[3],c3);
RP_full_adder fa4(sum[4],c5,A[4],B[4],c4);
RP_full_adder fa5(sum[5],c6,A[5],B[5],c5);
RP_full_adder fa6(sum[6],c7,A[6],B[6],c6);
RP_full_adder fa7(sum[7],c8,A[7],B[7],c7);
RP_full_adder fa8(sum[8],c9,A[8],B[8],c8);
RP_full_adder fa9(sum[9],c10,A[9],B[9],c9);
RP_full_adder fa10(sum[10],c11,A[10],B[10],c10);
RP_full_adder fa11(sum[11],c12,A[11],B[11],c11);
RP_full_adder fa12(sum[12],c13,A[12],B[12],c12);
RP_full_adder fa13(sum[13],c14,A[13],B[13],c13);
RP_full_adder fa14(sum[14],c15,A[14],B[14],c14);
RP_full_adder fa15(sum[15],c16,A[15],B[15],c15);
endmodule

module ripple_carry_adder_12bit(A,B,sum);
input [11:0]A,B;
output[11:0]sum;
wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12;

RP_full_adder fa0(sum[0],c1,A[0],B[0],1'b0);
RP_full_adder fa1(sum[1],c2,A[1],B[1],c1);
RP_full_adder fa2(sum[2],c3,A[2],B[2],c2);
RP_full_adder fa3(sum[3],c4,A[3],B[3],c3);
RP_full_adder fa4(sum[4],c5,A[4],B[4],c4);
RP_full_adder fa5(sum[5],c6,A[5],B[5],c5);
RP_full_adder fa6(sum[6],c7,A[6],B[6],c6);
RP_full_adder fa7(sum[7],c8,A[7],B[7],c7);
RP_full_adder fa8(sum[8],c9,A[8],B[8],c8);
RP_full_adder fa9(sum[9],c10,A[9],B[9],c9);
RP_full_adder fa10(sum[10],c11,A[10],B[10],c10);
RP_full_adder fa11(sum[11],c12,A[11],B[11],c11);
endmodule

module ripple_carry_adder_8bit(A,B,sum);
input [7:0]A,B;
output[7:0]sum;
wire c1,c2,c3,c4,c5,c6,c7,c8;

RP_full_adder fa0(sum[0],c1,A[0],B[0],1'b0);
RP_full_adder fa1(sum[1],c2,A[1],B[1],c1);
RP_full_adder fa2(sum[2],c3,A[2],B[2],c2);
RP_full_adder fa3(sum[3],c4,A[3],B[3],c3);
RP_full_adder fa4(sum[4],c5,A[4],B[4],c4);
RP_full_adder fa5(sum[5],c6,A[5],B[5],c5);
RP_full_adder fa6(sum[6],c7,A[6],B[6],c6);
RP_full_adder fa7(sum[7],c8,A[7],B[7],c7);
endmodule

module ripple_carry_adder_6bit(A,B,sum);
input [5:0]A,B;
output[5:0]sum;
wire c1,c2,c3,c4,c5,c6;

RP_full_adder fa0(sum[0],c1,A[0],B[0],1'b0);
RP_full_adder fa1(sum[1],c2,A[1],B[1],c1);
RP_full_adder fa2(sum[2],c3,A[2],B[2],c2);
RP_full_adder fa3(sum[3],c4,A[3],B[3],c3);
RP_full_adder fa4(sum[4],c5,A[4],B[4],c4);
RP_full_adder fa5(sum[5],c6,A[5],B[5],c5);
endmodule

module ripple_carry_adder_4bit(A,B,sum);
input [3:0]A,B;
output[3:0]sum;
wire c1,c2,c3,c4;

RP_full_adder fa0(sum[0],c1,A[0],B[0],1'b0);
RP_full_adder fa1(sum[1],c2,A[1],B[1],c1);
RP_full_adder fa2(sum[2],c3,A[2],B[2],c2);
RP_full_adder fa3(sum[3],c4,A[3],B[3],c3);
endmodule
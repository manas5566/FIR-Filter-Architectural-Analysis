`timescale 1 ns / 1 ns

module fully_serial_VM_RCA(
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
//Module Architecture: filter
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
  wire phase_7; // boolean
  wire phase_0; // boolean
  reg  signed [15:0] delay_pipeline [0:7] ; // sfix16_En15
  wire signed [15:0] inputmux_1; // sfix16_En15
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
  reg  signed [32:0] output_register; // sfix33_En31

  // Block Statements
  always @ (posedge clk or posedge reset)
    begin: Counter_process
      if (reset == 1'b1) begin
        cur_count <= 3'b111;
      end
      else begin
        if (clk_enable == 1'b1) begin
          if (cur_count >= 3'b111) begin
            cur_count <= 3'b000;
          end
          else begin
            cur_count <= cur_count + 3'b001;
          end
        end
      end
    end // Counter_process

  assign  phase_7 = (cur_count == 3'b111 && clk_enable == 1'b1) ? 1'b1 : 1'b0;

  assign  phase_0 = (cur_count == 3'b000 && clk_enable == 1'b1) ? 1'b1 : 1'b0;

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
        if (phase_7 == 1'b1) begin
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
                     (cur_count == 3'b011) ? delay_pipeline[3] :
                     (cur_count == 3'b100) ? delay_pipeline[4] :
                     (cur_count == 3'b101) ? delay_pipeline[5] :
                     (cur_count == 3'b110) ? delay_pipeline[6] :
                     delay_pipeline[7];

  //   ------------------ Serial partition # 1 ------------------

  assign product_1_mux = (cur_count == 3'b000) ? coeff1 :
                        (cur_count == 3'b001) ? coeff2 :
                        (cur_count == 3'b010) ? coeff3 :
                        (cur_count == 3'b011) ? coeff4 :
                        (cur_count == 3'b100) ? coeff5 :
                        (cur_count == 3'b101) ? coeff6 :
                        (cur_count == 3'b110) ? coeff7 :
                        coeff8;
  //assign mul_temp = inputmux_1 * product_1_mux;//////////////////multiplication
  vedic_16x16 m1(inputmux_1,product_1_mux,mul_temp);
  assign product_1 = mul_temp[30:0];
  assign prod_typeconvert_1 = $signed({{2{product_1[30]}}, product_1});
  assign add_signext = prod_typeconvert_1;
  assign add_signext_1 = acc_out_1;
 // assign add_temp = add_signext + add_signext_1;//////////////////addition
  wire c0,c1;
  assign c1=1'b0;
  ripple_carry_adder_32bit a1(add_temp,c0,add_signext,add_signext_1,c1);
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
        if (phase_7 == 1'b1) begin
          output_register <= acc_final;
        end
      end
    end // Output_Register_process

  // Assignment Statements
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

//addition

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
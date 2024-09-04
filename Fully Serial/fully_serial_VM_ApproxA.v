`timescale 1 ns / 1 ns

module fully_serial_VM_ApproxA(
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
  wire c0;
  Approx a1(add_signext,add_signext_1,add_temp,c0);
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

//sixteenbitmux_xor_fa16 A3(temp1, temp2, q4);
Approx_16bit A3(temp1,temp2,q4);

//sixteenbitmux_xor_fa24 A4(temp3, temp4, q5);
Approx_24bit A4(temp3,temp4,q5);

//sixteenbitmux_xor_fa24 A5({8'b00000000,q4}, q5, q6);
Approx_24bit A5({8'b00000000,q4}, q5, q6);

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

Approx_8bit A3(temp1, temp2, q4);
Approx_12bit A4(temp3, temp4, q5);
Approx_12bit A5({4'b0000,q4}, q5, q6);

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
Approx_4bit A0(q1[3:0], temp1, q4);
assign temp2= {2'b00, q2[3:0]};
assign temp3= {q3[3:0], 2'b00};
Approx_6bit A1(temp2, temp3, q5);
assign temp4= {2'b00, q4[3:0]};
Approx_6bit A2(temp4, q5, q6);
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

module Approx(A,B,S,Cout);
    input wire [31:0] A;
    input wire [31:0] B;
    output wire [31:0] S;
    output Cout;

// LSB 10 bits will have an approximate sum, the MSB 22 bits will be error free

    wire Accurate_in;
    wire C10, C11, C12, C13, C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25, C26, C27, C28, C29, C30, Cout;
    wire T9,T8,Mux_out;    
// 22 Bits of MSB being added in the ripple carry method to avoid Error in the
// sum
    
    assign Accurate_in = A[9]&B[9];
    assign T9 = A[9]&B[9];
    assign Mux_out = (Accurate_in) ? T9:0;
    assign T8 = A[8]&B[8];
    assign S[9] = Mux_out|T8;
    assign S[8] = A[8]|B[8];

    assign S[7] = 1;
    assign S[6] = 1;
    assign S[5] = 1;
    assign S[4] = 1;
    assign S[3] = 1;
    assign S[2] = 1;    
    assign S[1] = 1;
    assign S[0] = 1;


    Full_Adder i10(A[10], B[10], Accurate_in,S[10],C10);
    Full_Adder i11(A[11], B[11], C10, S[11], C11); 
    Full_Adder i12(A[12], B[12], C11, S[12], C12); 
    Full_Adder i13(A[13], B[13], C12, S[13], C13); 
    Full_Adder i14(A[14], B[14], C13, S[14], C14);
    Full_Adder i15(A[15], B[15], C14, S[15], C15);
    Full_Adder i16(A[16], B[16], C15, S[16], C16);
    Full_Adder i17(A[17], B[17], C16, S[17], C17);
    Full_Adder i18(A[18], B[18], C17, S[18], C18);
    Full_Adder i19(A[19], B[19], C18, S[19], C19);
    Full_Adder i20(A[20], B[20], C19, S[20], C20);
    Full_Adder i21(A[21], B[21], C20, S[21], C21);
    Full_Adder i22(A[22], B[22], C21, S[22], C22);
    Full_Adder i23(A[23], B[23], C22, S[23], C23);
    Full_Adder i24(A[24], B[24], C23, S[24], C24);
    Full_Adder i25(A[25], B[25], C24, S[25], C25);
    Full_Adder i26(A[26], B[26], C25, S[26], C26);
    Full_Adder i27(A[27], B[27], C26, S[27], C27);
    Full_Adder i28(A[28], B[28], C27, S[28], C28);
    Full_Adder i29(A[29], B[29], C28, S[29], C29);
    Full_Adder i30(A[30], B[30], C29, S[30], C30);
    Full_Adder i31(A[31], B[31], C30, S[31], Cout);
    
 endmodule
module Approx_24bit(A,B,S);
    input wire [23:0] A;
    input wire [23:0] B;
    output wire [23:0] S;
//    output Cout;
    
    wire Accurate_in;
    wire C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20,C21,C22,C23;

    assign Accurate_in = A[4]&B[4];
    assign S[5] = 0;
    assign S[4] = 1;
    assign S[3] = 1;    
    assign S[2] = 1;    
    assign S[1] = 0;
    assign S[0] = 0;


    Full_Adder i1(A[6], B[6], Accurate_in,S[6],C6);
    Full_Adder i2(A[7], B[7], C6, S[7], C7); 
    Full_Adder i3(A[8], B[8], C7, S[8], C8);    
    Full_Adder i4(A[9], B[9], C8, S[9], C9);
    Full_Adder i5(A[10], B[10], C9, S[10], C10);
    Full_Adder i6(A[11], B[11], C10, S[11], C11); 
    Full_Adder i7(A[12], B[12], C11, S[12], C12); 
    Full_Adder i8(A[13], B[13], C12, S[13], C13);     
    Full_Adder i9(A[14], B[14], C13, S[14], C14); 
    Full_Adder i10(A[15], B[15], C14, S[15], C15); 
    Full_Adder i11(A[16], B[16], C15, S[16], C16); 
    Full_Adder i12(A[17], B[17], C16, S[17], C17); 
    Full_Adder i13(A[18], B[18], C17, S[18], C18); 
    Full_Adder i14(A[19], B[19], C18, S[19], C19); 
    Full_Adder i15(A[20], B[20], C19, S[20], C20);
    Full_Adder i16(A[21], B[21], C20, S[21], C21);
    Full_Adder i17(A[22], B[22], C21, S[22], C22);
    Full_Adder i18(A[23], B[23], C22, S[23], C23);
    endmodule

module Approx_16bit(A,B,S);
    input wire [15:0] A;
    input wire [15:0] B;
    output wire [15:0] S;
    //output Cout;
    wire Accurate_in;
    wire C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16;
    assign Accurate_in = A[4]&B[4];
    assign S[4] = 0;
    assign S[3] = 1;    
    assign S[2] = 1;    
    assign S[1] = 0;
    assign S[0] = 0;


    Full_Adder i1(A[5], B[5], Accurate_in,S[5],C4);
    Full_Adder i3(A[6], B[6], C4, S[6], C6); 
    Full_Adder i4(A[7], B[7], C6, S[7], C7);    
    Full_Adder i5(A[8], B[8], C7, S[8], C9);
    Full_Adder i6(A[9], B[9], C9, S[9], C10);
    Full_Adder i7(A[10], B[10], C10, S[10], C11); 
    Full_Adder i8(A[11], B[11], C11, S[11], C12); 
    Full_Adder i9(A[12], B[12], C12, S[12], C13); 
    Full_Adder i10(A[13], B[13], C13, S[13], C14); 
    Full_Adder i11(A[14], B[14], C14, S[14], C15); 
    Full_Adder i12(A[15], B[15], C15, S[15], C16); 

    endmodule


module Approx_12bit(A,B,S);
    input wire [11:0] A;
    input wire [11:0] B;
    output wire [11:0] S;
//    output Cout;
// LSB 3 bits will have an approximate sum, the MSB 22 bits will be error free
                                                                             wire Accurate_in;
    wire C4,C5,C6,C7,C8,C9,C10,C11,C12;

    assign Accurate_in = A[3]&B[3];
// 22 Bits of MSB being added in the ripple carry method to avoid Error in the        
    assign S[3] = 0;    
    assign S[2] = 1;    
    assign S[1] = 0;
    assign S[0] = 0;


    Full_Adder i1(A[4], B[4], Accurate_in,S[4],C4);
    Full_Adder i3(A[5], B[5], C4, S[5], C6); 
    Full_Adder i4(A[6], B[6], C6, S[6], C7);    
    Full_Adder i5(A[7], B[7], C7, S[7], C8);
    Full_Adder i6(A[8], B[8], C8, S[8], C9);
    Full_Adder i7(A[9], B[9], C9, S[9], C10); 
    Full_Adder i8(A[10], B[10], C10, S[10], C11); 
    Full_Adder i9(A[11], B[11], C11, S[11], C12); 
    endmodule
 
module Approx_8bit(A,B,S);
    input wire [7:0] A;
    input wire [7:0] B;
    output wire [7:0] S;

    wire Accurate_in;
    wire C4,C5,C6,C7,C8;
    assign Accurate_in = A[2]&B[2];
    assign S[2] = 0;    
    assign S[1] = 0;
    assign S[0] = 0;

    Full_Adder i1(A[3], B[3], Accurate_in,S[3],C4);
    Full_Adder i2(A[4], B[4], C4, S[4], C5); 
    Full_Adder i3(A[5], B[5], C5, S[5], C6); 
    Full_Adder i4(A[6], B[6], C6, S[6], C7);
    Full_Adder i5(A[7], B[7], C7, S[7], C8);
    endmodule


module Approx_6bit(A,B,S);
    input wire [5:0] A;
    input wire [5:0] B;
    output wire [5:0] S;		
    wire Accurate_in;
    wire C2,C3,C4,C5;

    assign Accurate_in = A[1]&B[1];
    assign S[1] = 0;    
    assign S[0] = 1;    

    Full_Adder i1(A[2], B[2], Accurate_in,S[2],C2);
    Full_Adder i2(A[3], B[3], C2, S[3], C3); 
    Full_Adder i3(A[4], B[4], C3, S[4], C4);    
    Full_Adder i4(A[5], B[5], C4, S[5], C5);
    endmodule

module Approx_4bit(A,B,S);
    input wire [3:0] A;
    input wire [3:0] B;
    output wire [3:0] S;
    wire Accurate_in;
    wire C1,C2,C3;

    assign Accurate_in = A[0]&B[0];  
    assign S[0] = 1;    

    Full_Adder i1(A[1], B[1], Accurate_in,S[1],C1);
    Full_Adder i2(A[2], B[2], C1, S[2], C2); 
    Full_Adder i3(A[3], B[3], C2, S[3], C3);    
    endmodule


module Full_Adder(input a, input b, input cin, output sum, output cout);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (cin & (a ^ b));
endmodule
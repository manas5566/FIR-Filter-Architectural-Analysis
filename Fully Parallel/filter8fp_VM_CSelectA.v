
`timescale 1ns / 1ps

module filter8fp_VM_CSelectA
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
  wire cin;

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
  assign cin=1'b0;
  

  
  //module Carry_Select_32(S,Cout,A,B,Cin);
  Carry_Select_32 cs1(add_temp,c0,add_signext , add_signext_1,cin);
  assign sum1 =  add_temp;
  assign add_signext_2 = sum1;
  assign add_signext_3 = product3;
  Carry_Select_32 g2(add_temp_1,c1,add_signext_2 , add_signext_3,c0);
  assign sum2 = add_temp_1;

  assign add_signext_4 = sum2;
  assign add_signext_5 = product4;
  Carry_Select_32 g3(add_temp_2,c2,add_signext_4 , add_signext_5,c1);
  assign sum3 = add_temp_2;

  assign add_signext_6 = sum3;
  assign add_signext_7 =  product5;
  Carry_Select_32 g4(add_temp_3,c3,add_signext_6 ,add_signext_7,c2);
  assign sum4 = add_temp_3;

  assign add_signext_8 = sum4;
  assign add_signext_9 =  product6;
  Carry_Select_32 g5(add_temp_4,c4,add_signext_8 , add_signext_9,c3);
  assign sum5 = add_temp_4;

  assign add_signext_10 = sum5;
  assign add_signext_11 =  product7;
  Carry_Select_32 g6(add_temp_5,c5,add_signext_10 ,add_signext_11,c4);
  assign sum6 = add_temp_5;

  assign add_signext_12 = sum6;
  assign add_signext_13 =  product8;
  Carry_Select_32 g7(add_temp_6,Cout,add_signext_12 , add_signext_13,c5);
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

Carry_Select_16 A3(temp1, temp2, q4);
Carry_Select_24 A4(temp3, temp4, q5);
Carry_Select_24 A5({8'b00000000,q4}, q5, q6);

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

Carry_Select_8 A3(temp1, temp2, q4);
Carry_Select_12 A4(temp3, temp4, q5);
Carry_Select_12 A5({4'b0000,q4}, q5, q6);

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
Carry_Select_4 A0(q1[3:0], temp1, q4);
assign temp2= {2'b00, q2[3:0]};
assign temp3= {q3[3:0], 2'b00};
Carry_Select_6 A1(temp2, temp3, q5);
assign temp4= {2'b00, q4[3:0]};
Carry_Select_6 A2(temp4, q5, q6);
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

module Five_bit(A,B,Cin,S,Cout);
    input [4:0] A;
    input [4:0] B;
    input Cin;
    output [4:0] S;
    output Cout;  

    wire C1,C2,C3,C4;

    Full_Adder i1(A[0],B[0],Cin,S[0],C1);
    Full_Adder i2(A[1],B[1],C1,S[1],C2); 
    Full_Adder i3(A[2],B[2],C2,S[2],C3); 
    Full_Adder i4(A[3],B[3],C3,S[3],C4);
    Full_Adder i5(A[4],B[4],C4,S[4],Cout);

 endmodule

module Seven_bit(A,B,Cin,S,Cout);
    input [6:0] A;
    input [6:0] B;
    input Cin;
    output [6:0] S;
    output Cout;

    wire C1,C2,C3,C4,C5,C6,C7;

    Full_Adder i1(A[0],B[0],Cin,S[0],C1);
    Full_Adder i2(A[1],B[1],C1,S[1],C2); 
    Full_Adder i3(A[2],B[2],C2,S[2],C3); 
    Full_Adder i4(A[3],B[3],C3,S[3],C4);
    Full_Adder i5(A[4],B[4],C4,S[4],C5);
    Full_Adder i6(A[5],B[5],C5,S[5],C6);
    Full_Adder i7(A[6],B[6],C6,S[6],Cout);

 endmodule

module Nine_bit(A,B,Cin,S,Cout);
    input [8:0] A;
    input [8:0] B;
    input Cin;
    output [8:0] S;
    output Cout;   

    wire C1,C2,C3,C4,C5,C6,C7,C8;

    Full_Adder i1(A[0],B[0],Cin,S[0],C1);

    Full_Adder i2(A[1],B[1],C1,S[1],C2); 

    Full_Adder i3(A[2],B[2],C2,S[2],C3); 
    
    Full_Adder i4(A[3],B[3],C3,S[3],C4);
    
    Full_Adder i5(A[4],B[4],C4,S[4],C5);
    
    Full_Adder i6(A[5],B[5],C5,S[5],C6);
    
    Full_Adder i7(A[6],B[6],C6,S[6],C7);

    Full_Adder i8(A[7],B[7],C7,S[7],C8);
    
    Full_Adder i9(A[8],B[8],C8,S[8],Cout);
      
 endmodule

module Eleven_bit(A,B,Cin,S,Cout);
    input [10:0] A;
    input [10:0] B;
    input Cin;
    output [10:0] S;
    output Cout;

    wire C1,C2,C3,C4,C5,C6,C7,C8,C9,C10;

    Full_Adder i1(A[0],B[0],Cin,S[0],C1);

    Full_Adder i2(A[1],B[1],C1,S[1],C2); 

    Full_Adder i3(A[2],B[2],C2,S[2],C3); 
    
    Full_Adder i4(A[3],B[3],C3,S[3],C4);
    
    Full_Adder i5(A[4],B[4],C4,S[4],C5);
    
    Full_Adder i6(A[5],B[5],C5,S[5],C6);
    
    Full_Adder i7(A[6],B[6],C6,S[6],C7);

    Full_Adder i8(A[7],B[7],C7,S[7],C8);
    
    Full_Adder i9(A[8],B[8],C8,S[8],C9);

    Full_Adder i10(A[9],B[9],C9,S[9],C10);
    
    Full_Adder i11(A[10],B[10],C10,S[10],Cout);
    
 endmodule

module two_one_Mux_7(A,B,Cin1,Cin2,S,O,Cout);
    input [6:0] A;    
    input [6:0] B;
    input S;
    input Cin1,Cin2;
    output [6:0] O;    
    output Cout;
    assign O = (S==0) ? A:B;
    assign Cout = (S==0) ? Cin1:Cin2;
endmodule

module two_one_Mux_9(A,B,Cin1,Cin2,S,O,Cout); 
    input [8:0] A;
    input [8:0] B;   
    input S;        
    input Cin1,Cin2;
    output Cout;
    output [8:0] O;
    assign O = (S==0) ? A:B;
    assign Cout = (S==0) ? Cin1:Cin2;
endmodule

module two_one_Mux_11(A,B,Cin1,Cin2,S,O,Cout);
    input [10:0] A;
    input [10:0] B;
    input S;    
    input Cin1,Cin2;
    output Cout;
    output [10:0] O;
    assign O = (S==0) ? A:B;
    assign Cout = (S==0) ? Cin1:Cin2;
endmodule

module Full_Adder(A,B,Cin,S,Cout);

    input A;
    input B;
    input Cin;
    output S;
    output Cout;
    
    assign S = A^B^Cin;
    assign Cout = (A&B) | (A&Cin) | (B&Cin);
    
endmodule


module Carry_Select_32(S,Cout,A,B,Cin);
        
    input [31:0] A;
    input [31:0] B;
    input Cin;
    output [31:0] S;
    output Cout;
    
    wire SC1,SC2,SCC;
    
    wire [6:0] S1;
    wire [6:0] S2;

    wire [8:0] N1;
    wire [8:0] N2;

    wire [10:0] E1;
    wire [10:0] E2;
    
    //module Five_bit(A,B,Cin,S,Cout);
    Five_bit Fone(A[4:0],B[4:0],Cin,S[4:0],FC1);

    Seven_bit Sone(A[11:5],B[11:5],1'b0,S1,SC1); 
    Seven_bit Stwo(A[11:5],B[11:5],1'b1,S2,SC2);
    two_one_Mux_7 m1(S1,S2,SC1,SC2,FC1,S[11:5],SCC);

    wire NC1,NC2,NCC;
    Nine_bit None(A[20:12],B[20:12],1'b0,N1,NC1);  
    Nine_bit Ntwo(A[20:12],B[20:12],1'b1,N2,NC2);
    two_one_Mux_9 m2(N1,N2,NC1,NC2,SCC,S[20:12],NCC); 

    wire EC1,EC2,ECC;
    Eleven_bit Eone(A[31:21],B[31:21],1'b0,E1,EC1);
    Eleven_bit Etwo(A[31:21],B[31:21],1'b1,E2,EC2);
    two_one_Mux_11 m3(E1,E2,EC1,EC2,NCC,S[31:21],Cout);

endmodule

module Three_bit(A,B,Cin,S,Cout);
    input [2:0] A;
    input [2:0] B;
    input Cin;
    output [2:0] S;
    output Cout;

    wire C1,C2;

    Full_Adder i1(A[0],B[0],Cin,S[0],C1);

    Full_Adder i2(A[1],B[1],C1,S[1],C2); 

    Full_Adder i3(A[2],B[2],C2,S[2],Cout);    
 endmodule
 module two_one_Mux_5(A,B,Cin1,Cin2,S,O,Cout);
    input [4:0] A;
    input [4:0] B;
    input S;    
    input Cin1,Cin2;
    output Cout;
    output [4:0] O;
    assign O = (S==0) ? A:B;
    assign Cout = (S==0) ? Cin1:Cin2;
endmodule
module Carry_Select_24(A,B,S);
        
    input [23:0] A;
    input [23:0] B;    
    output [23:0] S;   
    
    wire SC1,SC2,SCC;
    
    wire [4:0] S1;
    wire [4:0] S2;

    wire [6:0] N1;
    wire [6:0] N2;

    wire [8:0] E1;
    wire [8:0] E2;
    wire x;    
    //module Five_bit(A,B,Cin,S,Cout);
    Three_bit Fone(A[2:0],B[2:0],0,S[2:0],FC1);

    Five_bit Sone(A[7:3],B[7:3],1'b0,S1,SC1); 
    Five_bit Stwo(A[7:3],B[7:3],1'b1,S2,SC2);

    two_one_Mux_5 m1(S1,S2,SC1,SC2,FC1,S[7:3],SCC);

    wire NC1,NC2,NCC;
    Seven_bit None(A[14:8],B[14:8],1'b0,N1,NC1);  
    Seven_bit Ntwo(A[14:8],B[14:8],1'b1,N2,NC2);

    two_one_Mux_7 m2(N1,N2,NC1,NC2,SCC,S[14:8],NCC); 
wire co;
    wire EC1,EC2,ECC;
    Nine_bit Eone(A[23:15],B[23:15],1'b0,E1,EC1);
    Nine_bit Etwo(A[23:15],B[23:15],1'b1,E2,EC2);

    two_one_Mux_9 m3(E1,E2,EC1,EC2,NCC,S[23:15],co);

endmodule
module Four_bit(A,B,Cin,S,Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire C1,C2,C3;

    Full_Adder i1(A[0],B[0],Cin,S[0],C1);
    Full_Adder i2(A[1],B[1],C1,S[1],C2); 
    Full_Adder i3(A[2],B[2],C2,S[2],C3); 
    Full_Adder i4(A[3],B[3],C3,S[3],Cout);

 endmodule
module two_one_Mux_4(A,B,Cin1,Cin2,S,O,Cout);
    input [3:0] A;    
    input [3:0] B;
    input S;
    input Cin1,Cin2;
    output [3:0] O;    
    output Cout;
    assign O = (S==0) ? A:B;
    assign Cout = (S==0) ? Cin1:Cin2;
endmodule
module Carry_Select_12(A,B,S);
        
    input [11:0] A;
    input [11:0] B;    
    output [11:0] S;    
    
    wire SC1,SC2,SCC;
    
    wire [3:0] S1;
    wire [3:0] S2;

    wire [4:0] N1;
    wire [4:0] N2;
    
    //module Five_bit(A,B,Cin,S,Cout);
    Three_bit Fone(A[2:0],B[2:0],0,S[2:0],FC1);

    Four_bit Sone(A[6:3],B[6:3],1'b0,S1,SC1); 
    Four_bit Stwo(A[6:3],B[6:3],1'b1,S2,SC2);

    two_one_Mux_4 m1(S1,S2,SC1,SC2,FC1,S[6:3],SCC);
    wire co;
    wire NC1,NC2,NCC;
    Five_bit None(A[11:7],B[11:7],1'b0,N1,NC1);  
    Five_bit Ntwo(A[11:7],B[11:7],1'b1,N2,NC2);
    two_one_Mux_5 m2(N1,N2,NC1,NC2,SCC,S[11:7],co); 
  

endmodule

module Carry_Select_16(A,B,S);
        
    input [15:0] A;
    input [15:0] B;    
    output [15:0] S;  
    
    wire SC1,SC2,SCC;
    
    wire [4:0] S1;
    wire [4:0] S2;

    wire [6:0] N1;
    wire [6:0] N2;
    wire FC1;
    
    //module Five_bit(A,B,Cin,S,Cout);
    Four_bit Fone(A[3:0],B[3:0],0,S[3:0],FC1);

    Five_bit Sone(A[8:4],B[8:4],1'b0,S1,SC1); 
    Five_bit Stwo(A[8:4],B[8:4],1'b1,S2,SC2);

    two_one_Mux_5 m1(S1,S2,SC1,SC2,FC1,S[8:4],SCC);

    wire NC1,NC2,NCC;
    wire co;
    Seven_bit None(A[15:9],B[15:9],1'b0,N1,NC1);  
    Seven_bit Ntwo(A[15:9],B[15:9],1'b1,N2,NC2);
    two_one_Mux_7 m2(N1,N2,NC1,NC2,SCC,S[15:9],co); 
  
endmodule

module Two_bit(A,B,Cin,S,Cout);
    input [1:0] A;
    input [1:0] B;
    input Cin;
    output [1:0] S;
    output Cout;

    wire C1;

    Full_Adder i1(A[0],B[0],Cin,S[0],C1);
    Full_Adder i2(A[1],B[1],C1,S[1],Cout); 

    endmodule
module two_one_Mux_3(A,B,Cin1,Cin2,S,O,Cout);
    input [2:0] A;    
    input [2:0] B;
    input S;
    input Cin1,Cin2;
    output [2:0] O;    
    output Cout;
    assign O = (S==0) ? A:B;
    assign Cout = (S==0) ? Cin1:Cin2;
endmodule
module Carry_Select_6(A,B,S);
        
    input [5:0] A;
    input [5:0] B;    
    output [5:0] S;   
    
    wire SC1,SC2,SCC;
    
    wire [1:0] S1;
    wire [1:0] S2;

    wire [2:0] N1;
    wire [2:0] N2;

    wire FC1;
    
    //module Five_bit(A,B,Cin,S,Cout);
    assign FC1 = A[0]&B[0];
    assign S[0] =A[0]^B[0];

    Two_bit Sone(A[2:1],B[2:1],1'b0,S1,SC1); 
    Two_bit Stwo(A[2:1],B[2:1],1'b1,S2,SC2);

    two_one_Mux_2 m1(S1,S2,SC1,SC2,FC1,S[2:1],SCC);

    wire NC1,NC2,NCC;
    wire co; 
    Three_bit None(A[5:3],B[5:3],1'b0,N1,NC1);  
    Three_bit Ntwo(A[5:3],B[5:3],1'b1,N2,NC2);

    two_one_Mux_3 m2(N1,N2,NC1,NC2,SCC,S[5:3],co); 
  
endmodule

module Carry_Select_4(A,B,S);
        
    input [3:0] A;
    input [3:0] B;    
    output [3:0] S;    
    
    wire SC1,SC2,SCC;
    
    wire [1:0] S1;
    wire [1:0] S2;

    wire FC1;
    

    Two_bit Sone(A[1:0],B[1:0],0,S[1:0],SCC);

    Two_bit Stwo(A[3:2],B[3:2],1'b0,S1,SC1);
    Two_bit Stwoo(A[3:2],B[3:2],1'b1,S2,SC2);

    two_one_Mux_2 m1(S1,S2,SC1,SC2,SCC,S[3:2],Cout); 
endmodule
module two_one_Mux_2(A,B,Cin1,Cin2,S,O,Cout);
    input [1:0] A;    
    input [1:0] B;
    input S;
    input Cin1,Cin2;
    output [1:0] O;    
    output Cout;
    assign O = (S==0) ? A:B;
    assign Cout = (S==0) ? Cin1:Cin2;
endmodule
module Carry_Select_8(A,B,S);
        
    input [7:0] A;
    input [7:0] B;   
    output [7:0] S;    
    
    wire SC1,SC2,SCC;
    
    wire [2:0] S1;
    wire [2:0] S2;

    wire [2:0] N1;
    wire [2:0] N2;
    wire FC1;
    
    //module Five_bit(A,B,Cin,S,Cout);
    Two_bit Fone(A[1:0],B[1:0],0,S[1:0],FC1);

    Three_bit Sone(A[4:2],B[4:2],1'b0,S1,SC1); 
    Three_bit Stwo(A[4:2],B[4:2],1'b1,S2,SC2);

    two_one_Mux_3 m1(S1,S2,SC1,SC2,FC1,S[4:2],SCC);
    wire co;
    wire NC1,NC2,NCC;
    Three_bit None(A[7:5],B[7:5],1'b0,N1,NC1);  
    Three_bit Ntwo(A[7:5],B[7:5],1'b1,N2,NC2);
    two_one_Mux_3 m2(N1,N2,NC1,NC2,SCC,S[7:5],co); 
  
endmodule
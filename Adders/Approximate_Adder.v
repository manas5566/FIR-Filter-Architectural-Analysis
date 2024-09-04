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

module FullAdder(input a, input b, input cin, output sum, output cout);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (cin & (a ^ b));
endmodule
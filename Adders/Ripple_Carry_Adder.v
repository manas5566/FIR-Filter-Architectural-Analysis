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
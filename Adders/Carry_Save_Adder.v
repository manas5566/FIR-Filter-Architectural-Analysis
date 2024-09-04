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
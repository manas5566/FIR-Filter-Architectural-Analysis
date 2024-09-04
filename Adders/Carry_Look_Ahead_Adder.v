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

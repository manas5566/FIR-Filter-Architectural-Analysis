module Carry_Select_32(A,B,Cin,S,Cout);
        
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




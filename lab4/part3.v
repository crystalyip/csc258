module lab4(SW, KEY, LEDR, Q, HEX0, HEX4, HEX5);
    input [9:0] SW;
    output [7:0] LEDR;
    input [0:0]KEY;
    //wire [7:0] b;
    output [7:0] Q;
     output [6:0] HEX0;
     output [6:0] HEX4;
     output [6:0] HEX5;
    ALU a(.A(SW[3:0]), .B(Q[3:0]), .KEY(SW[7:5]), .ALUout(LEDR[7:0]));
    flipflop F0(.d(LEDR[7:0]), .q(Q[7:0]), .clk(KEY[0:0]), .reset_n(SW[9:9]));
     hex H0(.a(SW[3]), .b(SW[2]), .c(SW[1]), .d(SW[0]), .h0(HEX0[6]), .h1(HEX0[5]), .h2(HEX0[4]), .h3(HEX0[3]), .h4(HEX0[2]), .h5(HEX0[1]), .h6(HEX0[0]));
     hex H4(.a(Q[3]), .b(Q[2]), .c(Q[1]), .d(Q[0]), .h0(HEX4[6]), .h1(HEX4[5]), .h2(HEX4[4]), .h3(HEX4[3]), .h4(HEX4[2]), .h5(HEX4[1]), .h6(HEX4[0]));
     hex H5(.a(Q[7]), .b(Q[6]), .c(Q[5]), .d(Q[4]), .h0(HEX5[6]), .h1(HEX5[5]), .h2(HEX5[4]), .h3(HEX5[3]), .h4(HEX5[2]), .h5(HEX5[1]), .h6(HEX5[0]));
endmodule

module flipflop(d, q, clk, reset_n);
    input [7:0]d;
    input clk, reset_n;
    output reg [7:0] q;
    always @(posedge clk)
    begin
        if (reset_n == 1'b0)
            q <= 0;
        else
            q <= d[7:0];
    end
endmodule

module ALU(A, B, KEY, ALUout);
    input [3:0] A;
    input [3:0] B;
    output reg [7:0] ALUout;
    input [2:0] KEY;
    //output cout;

    wire w;
    wire [3:0] add_One;
    adder_Mod add(.a(A[3:0]), .b(4'b0001), .cin(0), .s(add_One[3:0]), .cout(w));
  
    wire w2;
    wire [3:0] add_AB;
    adder_Mod addAB(.a(A[3:0]), .b(B[3:0]), .cin(0), .s(add_AB[3:0]), .cout(w));
  
    wire [7:0]concatenate;
    assign concatenate = {A, B};
  
    always @(*)
    begin
        case(KEY[2:0])
            0: ALUout = {4'b0000, add_One};
            1: ALUout = {4'b0000, add_AB};
            2: ALUout = {4'b0000, A+B};
            3: begin
                    ALUout[3:0] = A | B;
                    ALUout[7:4] = A^B;
                end
            4: begin
                    case(concatenate[7:0])
                        8'b00000000: ALUout = 8'b00000000;
                        default: ALUout = 8'b00000001;
                    endcase
                end
            5: ALUout = B << A;
            6: ALUout = B >> A;
            7: ALUout = A*B;
            default: ALUout = 4'b0000;
        endcase
    end

endmodule

module adder_Mod(a, b, cin, s, cout);
    input [3:0] a;
    input [3:0] b;
    input cin;
    output [3:0] s;
    output cout;
    wire W1;
    wire W2;
    wire W3;
    full_adder f0(.A(a[0]), .B(b[0]), .cin(cin), .s(s[0]), .cout(W1));
    full_adder f1(.A(a[1]), .B(b[1]), .cin(W1), .s(s[1]), .cout(W2));
    full_adder f2(.A(a[2]), .B(b[2]), .cin(W2), .s(s[2]), .cout(W3));
    full_adder f3(.A(a[3]), .B(b[3]), .cin(W3), .s(s[3]), .cout(cout));
endmodule
  
module full_adder (A, B, cin, s, cout);
    input A;
    input B;
    input cin;
    output s;
    output cout;
    assign s = (A&~B&~cin) | (~A&~B&cin) | (A&B&cin) | (~A&B&~cin);
    assign cout = (A&cin) | (A&B) | (B&cin);
endmodule

module hex(a, b, c, d, h0, h1, h2, h3, h4, h5, h6);
    input a, b, c, d;
    output h0, h1, h2, h3, h4, h5, h6;
    assign h0 = ~((~a & b & ~c & ~d) | (a & b & ~c & d) | (a & ~b & c & d) | (~a & ~b & ~c & d));
    assign h1 = ~((a & c & d) | (b & c & ~d) | (~a & b & ~c & d) | (a & b & ~c & ~d));
    assign h2 = ~((~a & ~b & c & ~d) | (a & b & ~c & ~d) | (a & b & c));
    assign h3 = ~((~a & b & ~c & ~d) | (b & c & d) | (a & ~b & c & ~d));
    assign h4 = ~((~a & d) | (~a & b & ~c & ~d) | (a & ~b & ~c & d));
    assign h5 = ~((~a & ~b & d) | (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & ~c & d));
    assign h6 = ~((~a & ~b & ~c) | (~a & b & c & d) | (a & b & ~c & ~d));

endmodule 
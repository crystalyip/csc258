module adder(SW, LEDR);
	input [9:0] SW;
	input [9:0] LEDR;	
	adder_Mod add(.a(SW[7:4]), .b(SW[3:0]), .cin(SW[8]), .s(LEDR[3:0]), .cout(LEDR[4]));
endmodule

module adder_Mod(a, b, cin, s, cout);
	input [3:0] a;
	input [3:0] b;
	input cin;
	output [3:0] s; // the sum
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
	output s; // the sum
	output cout; 
	assign s = (A&~B&~cin) | (~A&~B&cin) | (A&B&cin) | (~A&B&~cin); 
	assign cout = (A&cin) | (A&B) | (B&cin); 
endmodule

lab4(LoadVal, Q, ShiftRight, load_n, clk, reset_n, ASR);
    input [7:0]LoadVal;
    input ShiftRight, load_n, clk, reset_n, ASR;
    output [7:0]Q;
    reg w1;
    always @(*)
    begin
        case(ASR)
            0: w1 <= 1'b0;
            1: w1 <= LoadVal[7];
        endcase
    end
    ShifterBit s8(.load_val(LoadVal[0]), .load_n(load_n), .out(Q[0]), .clk(clk), .reset_n(reset_n), .shift(ShiftRight), .in(Q[1]));
    ShifterBit s7(.load_val(LoadVal[1]), .load_n(load_n), .out(Q[1]), .clk(clk), .reset_n(reset_n), .shift(ShiftRight), .in(Q[2]));
    ShifterBit s6(.load_val(LoadVal[2]), .load_n(load_n), .out(Q[2]), .clk(clk), .reset_n(reset_n), .shift(ShiftRight), .in(Q[3]));
    ShifterBit s5(.load_val(LoadVal[3]), .load_n(load_n), .out(Q[3]), .clk(clk), .reset_n(reset_n), .shift(ShiftRight), .in(Q[4]));
    ShifterBit s4(.load_val(LoadVal[4]), .load_n(load_n), .out(Q[4]), .clk(clk), .reset_n(reset_n), .shift(ShiftRight), .in(Q[5]));
    ShifterBit s3(.load_val(LoadVal[5]), .load_n(load_n), .out(Q[5]), .clk(clk), .reset_n(reset_n), .shift(ShiftRight), .in(Q[6]));
    ShifterBit s2(.load_val(LoadVal[6]), .load_n(load_n), .out(Q[6]), .clk(clk), .reset_n(reset_n), .shift(ShiftRight), .in(Q[7]));
    ShifterBit s1(.load_val(LoadVal[7]), .load_n(load_n), .out(Q[7]), .clk(clk), .reset_n(reset_n), .shift(ShiftRight), .in(w1));
endmodule
 
module ShifterBit(load_val, load_n, out, clk, reset_n, shift, in);
    input load_val, in, shift, load_n, clk, reset_n;
    output out;
    wire data_from_other_mux;
    wire data_to_dff;
    mux2to1 M1(.x(out), .y(in), .s(shift), .m(data_from_other_mux));
    mux2to1 M2(.x(load_val), .y(data_from_other_mux), .s(load_n), .m(data_to_dff));
    flipflop F0(.d(data_to_dff), .q(out), .clock(clk), .reset_n(reset_n));
endmodule
 
module flipflop(d, q, clock, reset_n);
    input d, clock, reset_n;
    output reg q;
    always @(posedge clock)
    begin
        if (reset_n == 1'b0)
            q <= 0;
        else
            q <= d;
    end
endmodule
 
module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
   
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;
 
endmodule


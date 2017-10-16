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
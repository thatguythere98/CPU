module alu(clk, rst, A, B, ld, opALU, done, Rout );
  input wire clk;
  input wire rst;
  input wire ld;

  input wire [15:0]A;
  input wire [15:0]B;
  input wire [1:0]opALU;

  output done;
  output reg [15:0]Rout;

  wire [15:0] O;

  multiplier U4 (A[7:0], B[7:0], rst, clk, ld, done, O);

  always @(*)
  begin
    case (opALU)
      2'b00  :
        Rout = A^B;// xor
      2'b01  :
        Rout = A+B;// add
      2'b10  :
        Rout = O; //use mul operation
      2'b11  :
        Rout = ~A; //use this wire A to input ACCreg to ALU in order to negate
      default :
        Rout = 16'd0;
    endcase
  end
endmodule

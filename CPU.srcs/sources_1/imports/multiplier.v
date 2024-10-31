module multiplier(input   [7:0]  A,
                    input   [7:0]  B,
                    input          rst,
                    input          clk,
                    input          ld,
                    output  reg        Done,
                    output  reg [15:0] O
                   );

  // regs and wires declaration
  reg  [1:0]  current_state, next_state;
  reg  [7:0]  in_A, in_B;
  reg  [2:0]  C;
  reg  [15:0] add_x, add_y; // adder input x, y
  wire [15:0] add_O; // adder output O
  reg  [15:0] temp_O; // register to store the global output
  reg  [15:0] shift_in; // shifter input in
  reg  [2:0]  shift_N;  // shifter input N
  wire [15:0] shift_O;  // shifter output O

  // module instantiation
  fulladder f(add_x, add_y, add_O);
  shifter   s(shift_in, shift_N, shift_O);

  // combinational
  always @(*)
  begin

    add_x   = temp_O;
    add_y   = shift_O;
    shift_in = 0;
    shift_N = C;
    Done = 0;

    case (current_state)
      2'd0:
      begin
        if (ld)
        begin
          Done = 0;
          next_state = 2'd1;
        end
        else
          next_state = 2'd0;
      end

      2'd1:
      begin
        next_state = 2'd2;
        if (B[C])
          shift_in = in_A;
        else
          add_y = 0;
      end

      2'd2:
      begin
        O = temp_O;
        if (C == 3'd7)
          next_state = 2'd3;
        else
          next_state = 2'd1;
      end

      2'd3:
      begin
        next_state = 2'd0;
        Done = 1;
      end
      default:
        next_state = 2'd0;

    endcase // current_state
  end

  // sequential
  always @(posedge clk)
  begin
    if (rst)
    begin
      current_state <= 2'd0;
      temp_O <= 16'd0;
    end
    else
      current_state <= next_state;

    case (current_state)
      2'd0:
      begin
        temp_O <= 16'd0;
        if (ld)
        begin
          in_A <= A;
          in_B <= B;
          C <= 3'b0;
        end
      end
      2'd1:
      begin
        C <= C + 3'b1;
        temp_O <= add_O;
      end
    endcase

  end
endmodule


module fulladder
  (
    input [15:0] x,
    input [15:0] y,

    output [15:0] O
  );

  assign O =   y + x;

endmodule

module shifter
  (
    input [15:0] in,
    input [2:0] N,
    output [15:0] O
  );
  reg [15:0] out_reg;
  assign O = out_reg;

  always @(N or in)
  begin
    case (N)
      7 :
        out_reg <= { in[7:0],7'b0};
      6 :
        out_reg <= { in[7:0],6'b0};
      5 :
        out_reg <= { in[7:0],5'b0};
      4 :
        out_reg <= { in[7:0],4'b0};
      3 :
        out_reg <= { in[7:0],3'b0};
      2 :
        out_reg <= { in[7:0],2'b0};
      1 :
        out_reg <= { in[7:0],1'b0};
      0 :
        out_reg <=   in[7:0];
    endcase
  end
endmodule


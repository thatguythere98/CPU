module  ram(
    we,
    d,
    q,
    addr
  );

  input wire we; //We => 1 bit read / write enable
  input wire [15:0]d; //D => 16 bit data input
  input wire  [7:0]addr; //Addr => 8 bit input address

  output reg  [15:0]q;  //Q => 16 bit data output

  reg [15:0] mem [255:0]; // memory

  always @(*)
  begin
    if (we)
    begin
      //write
      mem[addr] = d;
      q <= 0;
    end
    else
    begin
      //read
      q <= mem[addr];
    end
  end

endmodule




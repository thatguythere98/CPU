module proj1_tb;
  reg clk,rst;

  wire memrw;
  wire [7:0]memaddr;
  wire [15:0]memd;


  proj1 dut(clk, rst, memrw, memaddr, memd);

  always
    #5  clk =  !clk;

  initial
  begin
    clk=1'b0;
    rst=1'b1;
    $readmemh("memory.list", proj1_tb.dut.U1.mem);
    #20 rst=1'b0;
    #735
     $display("Final value\n");
    $display("0x000e %d\n",proj1_tb.dut.U1.mem[16'h000e]);
    $finish;
  end

endmodule






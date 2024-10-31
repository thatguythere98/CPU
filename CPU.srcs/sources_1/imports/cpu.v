module cpu(
    clk,
    rst,
    MemRW_IO,
    MemAddr_IO,
    MemD_IO
  );

  input clk;
  input rst;
  output MemRW_IO;
  output [7:0]MemAddr_IO;
  output [15:0]MemD_IO;


  wire we;
  wire [15:0]memd;
  wire [15:0]memq;
  wire [7:0]memaddr;

  wire zflag;
  wire [7:0]opcode;
  wire muxpc;
  wire muxmar;
  wire muxacc;
  wire loadmar;
  wire loadpc;
  wire loadacc;
  wire loadmdr;
  wire loadir;
  wire [1:0] opalu;
  wire done;
  wire ld;



  ram U1(we, memd, memq, memaddr);//one instance of memory

  ctr U2(clk, rst, zflag, opcode, done, muxpc, muxmar, muxacc, loadmar, loadpc, loadacc, loadmdr, loadir, opalu, we, ld);//one instance of controller

  datapath U3(clk, rst, muxpc, muxmar, muxacc, loadmar, loadpc, loadacc, loadmdr, loadir, opalu, ld, zflag, opcode, memaddr, memd, done, memq);//one instance of datapath1

  //these are just to observe the signals.
  assign MemAddr_IO = memaddr;
  assign MemD_IO = memd;
  assign MemRW_IO = we;

endmodule

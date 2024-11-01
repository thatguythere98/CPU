module datapath(
    clk,
    rst,
    muxPC,
    muxMAR,
    muxACC,
    loadMAR,
    loadPC,
    loadACC,
    loadMDR,
    loadIR,
    opALU,
    ld,
    zflag,
    opcode,
    MemAddr,
    MemD,
    done,
    MemQ
  );

  input clk;
  input  rst;
  input  muxPC;
  input  muxMAR;
  input  muxACC;
  input  loadMAR;
  input  loadPC;
  input  loadACC;
  input  loadMDR;
  input  loadIR;
  input  [1:0]opALU;
  input  ld;
  
  output   zflag;
  output   [7:0]opcode;
  output   [7:0]MemAddr;
  output   [15:0]MemD;
  output done;
  input   [15:0]MemQ;


  wire [7:0] PC_next;
  wire [15:0] IR_next;  
  wire [15:0] ACC_next;  
  wire [15:0] MDR_next;  
  wire [7:0] MAR_next;  
  wire zflag_next;

  wire  [7:0]PC_reg;
  wire  [15:0]IR_reg;
  wire  [15:0]ACC_reg;
  wire  [15:0]MDR_reg;
  wire  [7:0]MAR_reg;
  wire  zflag_reg;
  wire  [15:0]ALU_out;


  alu U1(clk, rst, ACC_reg, MDR_reg, ld, opALU, done, ALU_out); //one instance of ALU
  registers U2(clk, rst, PC_reg, PC_next, IR_reg, IR_next, ACC_reg, ACC_next, MDR_reg, MDR_next, MAR_reg, MAR_next, zflag_reg, zflag_next);// one instance of register.

  //Gets value of mdr_reg if loadir is set
  assign IR_next = loadIR ? MDR_reg : IR_reg;

  //Gets value from memeory,  if load mdr is set
  assign MDR_next = loadMDR ? MemQ : MDR_reg;

  assign zflag_next = (ACC_reg == 16'b0) ? 1'b1 : 1'b0;

  assign MAR_next = loadMAR ? (muxMAR ? IR_reg[15:8] : PC_reg) : MAR_reg;
  
  assign ACC_next = loadACC ? (muxACC ? MDR_reg : ALU_out) : ACC_reg;
  
  assign PC_next = loadPC ? (muxPC ? IR_reg[15:8] : (PC_reg + 1'b1)) : PC_reg;



  //outputs

  //output   zflag; => based on ACC reg
  assign zflag = zflag_reg;

  //output   [7:0]opcode; => based on IR_reg
  assign opcode = IR_reg[7:0];

  //output   [7:0]MemAddr => Same as MAR_reg
  assign MemAddr = MAR_reg;

  //output   [15:0]MemD => Same as ACC reg
  assign MemD = ACC_reg;

endmodule

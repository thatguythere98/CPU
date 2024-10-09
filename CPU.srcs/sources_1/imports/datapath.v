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
	   ld,//
           zflag,
           opcode,
           MemAddr,
           MemD,
	   done,//
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


reg  [7:0]PC_next;
wire  [15:0]IR_next;  
reg  [15:0]ACC_next;  
wire  [15:0]MDR_next;  
reg  [7:0]MAR_next;  
reg zflag_next;

wire  [7:0]PC_reg;
wire  [15:0]IR_reg;  
wire  [15:0]ACC_reg;  
wire  [15:0]MDR_reg;  
wire  [7:0]MAR_reg;  
wire zflag_reg;

wire  [15:0]ALU_out;  



alu U1(clk, rst, ACC_reg, MDR_reg, ld, opALU, done, ALU_out); //one instance of ALU
registers U2(clk, rst, PC_reg, PC_next, IR_reg, IR_next, ACC_reg, ACC_next, MDR_reg, MDR_next, MAR_reg, MAR_next, zflag_reg, zflag_next);// one instance of register.


//code to generate
//[7:0]PC_next;
//Only change if loadpc is enabled.
//Mux pc decides between pc+1 or branch address
//Reset address is 0, Hence nothing for the datapath to do at reset.

	//PC_next =  muxPC ? (PC_reg + 1'b1) : [7:0]IR_reg
	///PC_next = loadPC ? (muxPC ? (IR_reg[15:8]) : (PC_reg + 1'b1)): (PC_reg) ;


//[15:0]IR_next;  
//Gets value of mdr_reg if loadir is set

	assign IR_next = loadIR ? MDR_reg : IR_reg;


 //[15:0]ACC_next;  
//Only change when loaddacc is enabled.
//Muxacc decides between mdr_reg and alu out

	///ACC_next = loadACC ? muxACC ? MDR_reg : ALU_out : ACC_reg ;


 //[15:0]MDR_next;  
//Gets value from memeory,  if load mdr is set

	assign MDR_next = loadMDR ? MemQ : MDR_reg;


 //[7:0]MAR_next;  
//Only change if loadmar is enabled.
//Mux mar decides between  pcreg or IR[15:8]reg
	
	//assign MAR_next <= loadMAR ? PC_reg : [15:8]IR_reg;
	///MAR_next = loadMAR ? muxMAR ? IR_reg[15:8] : PC_reg : MAR_reg ;



 //zflag_next;
//Decide  based on the content of acc_reg
	///zflag_next = ACC_reg ? 1'b0 : 1'b1;

always @(*) begin
zflag_next = ACC_reg ? 1'b0 : 1'b1;
MAR_next = loadMAR ? muxMAR ? IR_reg[15:8] : PC_reg : MAR_reg ;
ACC_next = loadACC ? muxACC ? MDR_reg : ALU_out : ACC_reg ;
PC_next = loadPC ? (muxPC ? (IR_reg[15:8]) : (PC_reg + 1'b1)): (PC_reg) ;
end



//outputs 
//needs to generate the following outputs
//set this outputs based on the registered value and not the next value to prevent glitches.

   //output   zflag; => based on ACC reg
	assign zflag = zflag_next;

   //output   [7:0]opcode; => based on IR_reg
	assign opcode = IR_reg[7:0];

   //output   [7:0]MemAddr => Same as MAR_reg
	assign MemAddr = MAR_reg;

   //output   [15:0]MemD => Same as ACC reg
	assign MemD = ACC_reg;

endmodule
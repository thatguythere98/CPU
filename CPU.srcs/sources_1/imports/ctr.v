module ctr (
           clk,
           rst,
	zflag,
           opcode,
	   done,//
           muxPC,
           muxMAR,
           muxACC,
           loadMAR,
           loadPC,
           loadACC,
           loadMDR,
           loadIR,
           opALU,
           MemRW,
	   ld//
);

           input clk;
           input rst;
           input zflag;
           input [7:0]opcode;
	   input done;
           output reg muxPC;
           output reg muxMAR;
           output reg muxACC;
           output reg loadMAR;
           output reg loadPC;
           output reg loadACC;
           output reg loadMDR;
           output reg loadIR;
           output reg [1:0] opALU;
           output reg MemRW;
	   output reg ld;

parameter op_add=8'b001;//0x01  ADD
parameter op_xor= 8'b010;//0x02  XOR
parameter op_jump=8'b011;//0x3 JUMP
parameter op_jumpz=8'b100;//0x4 JUMPZ
parameter op_store=8'b101;//0x5 STORE
parameter op_load=8'b110;//0x6 LOAD
parameter op_mull=8'b1001;//0x09 MULL
parameter op_neg=8'b1010;//0x0A Neg

parameter Fetch_1=4'b0000;
parameter Fetch_2= 4'b0001;
parameter Fetch_3=4'b0010;
parameter Decode=4'b0011;
parameter ExecADD_1=4'b0100;
parameter ExecADD_2=4'b0101;
parameter ExecOR_1=4'b0110;
parameter ExecOR_2=4'b0111;
parameter ExecLoad_1=4'b1000;
parameter ExecLoad_2=4'b1001;
parameter ExecStore_1=4'b1010;
parameter ExecJump=4'b1011;
parameter ExecNEG=4'b1100;
parameter ExecMULL_1=4'b1101;
parameter ExecMULL_2=4'b1110;
parameter ExecMULL_3=4'b1111;





reg  [3:0] current_state, next_state;

always @(posedge clk) begin
	if (rst) 
		current_state <= Fetch_1;
	else 
		current_state <= next_state;
end

//inputs and next state machine
always @(*) begin //change to just current_state in sensitivity list
	case(current_state)
		Fetch_1: begin 
			next_state <= Fetch_2;
			end
		Fetch_2: begin  
			next_state <= Fetch_3;
			end
		Fetch_3: begin  
			next_state <= Decode;
			end
		Decode: begin 

			case(opcode)
			op_add: begin
				next_state <= ExecADD_1;
				end
			op_xor: begin
				next_state <= ExecOR_1;
				end
			op_load: begin
				next_state <= ExecLoad_1;
				end
			op_store: begin
				next_state <= ExecStore_1;
				end
			op_jump: begin //jmpz needs to go directly from decode to fetch1
				next_state <= ExecJump;
				end
			op_jumpz: begin //jmpz needs to go directly from decode to fetch1
				if(zflag) begin
					next_state <= ExecJump;
					end
				else begin
					next_state <= Fetch_1;
					end
				end
			op_neg: begin
				next_state <= ExecNEG;
				end
			op_mull: begin
				next_state <= ExecMULL_1;
				end
			default: next_state <= Fetch_1;
			endcase
			end
		ExecADD_1: begin 
			next_state <= ExecADD_2;
			end
		ExecADD_2: begin 
			next_state <= Fetch_1;
			end
		ExecOR_1: begin 
			next_state <= ExecOR_2;
			end
		ExecOR_2: begin 
			next_state <= Fetch_1;
			end
		ExecLoad_1: begin 
			next_state <= ExecLoad_2;
			end
		ExecLoad_2: begin 
			next_state <= Fetch_1;
			end
		ExecStore_1: begin 
			next_state <= Fetch_1;
			end
		ExecJump: begin 
			next_state <= Fetch_1;
			end
		ExecNEG: begin 
			next_state <= Fetch_1;
			end
		ExecMULL_1: begin 
			next_state <= ExecMULL_2;
			end
		ExecMULL_2: begin 
				if(done) begin
					next_state <= ExecMULL_3;
					end
				else begin
					next_state <= ExecMULL_2;
					end
			
			end
		ExecMULL_3: begin 
			next_state <= Fetch_1;
			end
		default: next_state <= Fetch_1;
	endcase // current_state
end

//outputs state machine
always @(*) begin
	if (rst) begin
		muxPC <= 0;
          	muxMAR <= 0;
           	muxACC <= 0;
          	loadMAR <= 0;
           	loadPC <= 0;
           	loadACC <= 0;
          	loadMDR <= 0;
           	loadIR <= 0;
           	opALU <= 0;
           	MemRW <= 0;
				ld <= 0;
		end
	else begin
		case(current_state)
			Fetch_1: begin 
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 1;
           			 loadPC <= 1;
           			 loadACC <= 0;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			Fetch_2: begin 
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 1;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			Fetch_3: begin  
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 0;
           			 loadIR <= 1;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			Decode:	begin  
				 muxPC <= 0;
          		 	 muxMAR <= 1;
           			 muxACC <= 0;
          			 loadMAR <= 1;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecADD_1: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 1;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecADD_2: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 1;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 2'd1;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecOR_1: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 1;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecOR_2: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 1;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecLoad_1: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 1;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecLoad_2: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 1;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 1;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecStore_1: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 1;
				 ld <= 0;
				end
			ExecJump: begin
				 muxPC <= 1;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 1;
           			 loadACC <= 0;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecNEG: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 1;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 2'd3;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecMULL_1: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 1;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 1;
				end
			ExecMULL_2: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 2'd2;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			ExecMULL_3: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 1;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 2'd2;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
			default: begin
				 muxPC <= 0;
          		 	 muxMAR <= 0;
           			 muxACC <= 0;
          			 loadMAR <= 0;
           			 loadPC <= 0;
           			 loadACC <= 0;
            			 loadMDR <= 0;
           			 loadIR <= 0;
           			 opALU <= 0;
           	  		 MemRW <= 0;
				 ld <= 0;
				end
		endcase 
	end
end

endmodule



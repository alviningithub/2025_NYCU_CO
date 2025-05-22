module PipelineCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// The rst signal is active low, which means the module will reset if the rst signal is zero.
// And you should follow this design.

// TODO: connect wire to realize PipelineCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

//PC output
wire [31:0] pc_o;

//Adder1 output 
wire [31:0] Four = 32'h00000004;
wire [31:0] pc_plus4;

//instruction memory output
wire [31:0] inst;

//m_reg output
wire [31:0]readData1 , readData2;

// Branch comp output
wire BrEq ,BrLT;

//imm Gen output
wire [31:0]imm;

//shift left 1 output
wire [31:0] sl_one;

//adder2 output
wire [31:0] adder2_out;

//mux3 pc output
wire [31:0] pc_next;

//mux2 output
wire [31:0] ALU_parm2;

//ALU output
wire [31:0] ALUOut;
wire  zero;

//Data mem output
wire [31:0] readData_Dmem;

//mux3 wrData output
wire [31:0] writeData_reg;

//control output
wire memRead , memWrite, ALUSrc,regWrite;
wire [1:0] memtoReg, PCSel,ALUOp;

//ALU control output
wire [3:0] ALUCtrl;

// IF_ID_Reg output
wire [31:0]pc_ID;
wire [31:0]pc_plus4_ID;
wire [31:0]inst_ID;
// ID_input
wire func7_ID = inst_ID[30];
wire [2:0]func3_ID = inst_ID[14:12];
wire [4:0] writeReg =  inst_ID [11:7];
wire [4:0] readReg1 = inst_ID[19:15];
wire [4:0] readReg2 = inst_ID[24:20];


// ID_EX_Reg
wire [31:0] readData1_EX, readData2_EX, pc_4_EX, imm_EX;
wire [4:0] writeReg_EX ; 
wire [2:0] func3_EX;
wire [1:0] memtoReg_EX , ALUOp_EX ;
wire regWrite_EX, memRead_EX, memWrite_EX,ALUSrc_EX,func7_EX ;

//EX_MEM_Reg
wire [31:0] ALUOut_MEM, readData2_MEM, pc_4_MEM;
wire [4:0] writeReg_MEM;
wire [1:0] memtoReg_MEM;
wire regWrite_MEM, memRead_MEM, memWrite_MEM;

//MEM_WB_Reg
wire [31:0] ALUOut_WB, readData_Dmem_WB, pc_4_WB;
wire [4:0] writeReg_WB;
wire [1:0] memtoreg_WB;
wire regWrite_WB;

PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_next),
    .pc_o(pc_o)
);


Adder m_Adder_1(
    .a(pc_o),
    .b(Four),
    .sum(pc_plus4)
);


InstructionMemory m_InstMem(
    .readAddr(pc_o),
    .inst(inst)
);

wire [6:0] opcode_ID = inst[6:0];



Control m_Control(
    .opcode(opcode_ID),
    .funct3(func3_ID),
    .BrEq(BrEq),
    .BrLT(BrLT),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite),
    .PCSel(PCSel)
);

// For Student:
// Do not change the Register instance name!
// Or you will fail validation.




Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite_WB),
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg_WB),
    .writeData(writeData_reg),
    .readData1(readData1),
    .readData2(readData2)
);

// ======= for validation =======
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

BranchComp m_BranchComp(
    .A(readData1),
    .B(readData2),
    .BrEq(BrEq),
    .BrLT(BrLT)
);

ImmGen m_ImmGen(
    .inst(inst_ID),
    .imm(imm)
);


ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(sl_one)
);

Adder m_Adder_2(
    .a(Pc_ID),
    .b(sl_one),
    .sum(adder2_out)
);

Mux3to1 #(.size(32)) m_Mux_PC(
    .sel(PCSel),
    .s0(pc_plus4),
    .s1(adder2_out),
    .s2(ALUOut),
    .out(pc_next)
);


Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc_EX),
    .s0(readData2_EX),
    .s1(imm_EX),
    .out(ALU_parm2)
);

//???
ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp_EX),
    .funct7(func7_EX),
    .funct3(func3_EX),
    .ALUCtl(ALUCtrl)
);
//??
ALU m_ALU(
    .ALUctl(ALUCtrl),
    .A(readData1_EX),
    .B(ALU_parm2),
    .ALUOut(ALUOut),
    .zero(zero)
);


DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite_MEM),
    .memRead(memRead_MEM),
    .address(ALUOut_MEM),
    .writeData(readData2_MEM),
    .readData(readData_Dmem)
);


Mux3to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg_WB),
    .s0(ALUOut_WB),
    .s1(readData_Dmem_WB),
    .s2(pc_4_WB),
    .out(writeData_reg)
);

//pipeline add
//miss writeReg pos


IF_ID_Reg m_IF_ID_Reg(
    .clk(clk),
    .rst(start),
    .pc_i(pc_o),
    .pc_4_i(pc_plus4),
    .inst_i(inst),
    .pc_o(pc_ID),
    .pc_4_o(pc_plus4_ID),
    .inst_o(inst_ID)
);




ID_EX_Reg m_ID_EX_Reg(
    .clk(clk),
    .rst(start),
    .readData1_i(readData1),
    .readData2_i(readData2),
    .pc_4_i(pc_plus4_ID),
    .imm_i(imm),
    .regWrite_i(regWrite),
    .memRead_i(memRead),
    .memWrite_i(memWrite),
    .ALUSrc_i(ALUSrc),
    .memtoreg_i(memtoReg),
    .ALUOp_i(ALUOp),
    .func3_i(func3_ID),
    .func7_i(func7_ID),
    .writeReg_i(writeReg),
    .readData1_o(readData1_EX),
    .readData2_o(readData2_EX),
    .pc_4_o(pc_4_EX),
    .imm_o(imm_EX),
    .regWrite_o(regWrite_EX),
    .memRead_o(memRead_EX),
    .memWrite_o(memWrite_EX),
    .ALUSrc_o(ALUSrc_EX),
    .memtoreg_o(memtoReg_EX),
    .ALUOp_o(ALUOp_EX),
    .func3_o(func3_EX),
    .func7_o(func7_EX),
    .writeReg_o(writeReg_EX)
);



EX_MEM_Reg m_EX_MEM_Reg(
    .rst(start),
    .clk(clk),
    .ALUresult_i(ALUOut),
    .readData_i(readData2_EX),
    .memtoreg_i(memtoReg_EX),
    .regWrite_i(regWrite_EX),
    .memRead_i(memRead_EX),
    .memWrite_i(memWrite_EX),
    .writeReg_i(writeReg_EX),
    .pc_4_i(pc_4_EX),
    .ALUresult_o(ALUOut_MEM),
    .readData2_o(readData2_MEM),
    .memtoreg_o(memtoReg_MEM),
    .regWrite_o(regWrite_MEM),
    .memRead_o(memRead_MEM),
    .memWrite_o(memWrite_MEM),
    .writeReg_o(writeReg_MEM),
    .pc_4_o(pc_4_MEM)
);



MEM_WB_Reg m_mem_wb_Reg(
    .clk(clk),
    .rst(start),
    .ALUresult_i(ALUOut_MEM),
    .readData_i(readData_Dmem),
    .memtoreg_i(memtoReg_MEM),
    .pc_4_i(pc_4_MEM),
    .regWrite_i(regWrite_MEM),
    .writeReg_i(writeReg_MEM),
    .ALUresult_o(ALUOut_WB),
    .readData_o(readData_Dmem_WB),
    .memtoreg_o(memtoreg_WB),
    .pc_4_o(pc_4_WB),
    .regWrite_o(regWrite_WB),
    .writeReg_o(writeReg_WB),
);

endmodule

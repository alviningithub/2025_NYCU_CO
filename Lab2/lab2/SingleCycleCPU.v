module SingleCycleCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// The rst signal is active low, which means the module will reset if the rst signal is zero.
// And you should follow this design.

// TODO: connect wire to realize SingleCycleCPU
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

wire [6:0] opcode = inst[6:0];
wire [2:0] funct3 = inst[14:12];


Control m_Control(
    .opcode(opcode),
    .funct3(funct3),
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

wire [4:0]readReg1 = inst[19:15];
wire [4:0]readReg2 = inst[24:20];
wire [4:0]writeReg = inst[11:7];


Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg),
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
    .inst(inst),
    .imm(imm)
);


ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(sl_one)
);

Adder m_Adder_2(
    .a(pc_o),
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
    .sel(ALUSrc),
    .s0(readData2),
    .s1(imm),
    .out(ALU_parm2)
);
wire funct7 = inst[30];

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(funct7),
    .funct3(funct3),
    .ALUCtl(ALUCtrl)
);

ALU m_ALU(
    .ALUctl(ALUCtrl),
    .A(readData1),
    .B(ALU_parm2),
    .ALUOut(ALUOut),
    .zero(zero)
);


DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(readData2),
    .readData(readData_Dmem)
);


Mux3to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(readData_Dmem),
    .s2(pc_plus4),
    .out(writeData_reg)
);

endmodule

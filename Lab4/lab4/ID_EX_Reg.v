module ID_EX_Reg (
    input clk,
    input rst,
    input Flush_HD,
    input stall,
    input [31:0]readData1_i,
    input [31:0]readData2_i,
    input [31:0]pc_4_i,
    input [31:0]imm_i,
    input [4:0] writeReg_i,
    input [4:0] readReg1_i,
    input [4:0] readReg2_i,
    input [2:0]func3_i,
    input [1:0] ALUOp_i,
    input [1:0] memtoreg_i,
    input func7_i,
    input regWrite_i,
    input memRead_i,
    input memWrite_i,
    input ALUSrc_i,
    output reg [31:0] readData1_o,
    output reg [31:0] readData2_o,
    output reg [31:0] pc_4_o,
    output reg [31:0] imm_o,
    output reg [1:0] ALUOp_o,
    output reg [2:0]func3_o,
    output reg func7_o,
    output reg regWrite_o,
    output reg memRead_o,
    output reg memWrite_o,
    output reg ALUSrc_o,
    output reg [1:0] memtoreg_o,
    output reg [4:0] writeReg_o,
    output reg [4:0] readReg1_o,
    output reg [4:0] readReg2_o 
);
    always @(posedge clk , negedge rst) begin
        if(~rst || Flush_HD) begin
            readData1_o <= 0;
            readData2_o <= 0;
            pc_4_o <=0;
            imm_o <= 0;
            regWrite_o <=0;
            memRead_o <= 0;
            memWrite_o <= 0;
            ALUSrc_o <= 0;
            memtoreg_o <= 0;
            ALUOp_o <= 0;
            func3_o <= 0;
            func7_o <= 0;
            writeReg_o <= 0;
            readReg1_o <= 0;
            readReg2_o <= 0;
        end else if(stall) begin 
            readData1_o <= readData1_o;
            readData2_o <= readData2_o;
            pc_4_o <=pc_4_o;
            imm_o <= imm_o;
            regWrite_o <=regWrite_o;
            memRead_o <= memRead_o;
            memWrite_o <= memWrite_o;
            ALUSrc_o <= ALUSrc_o;
            memtoreg_o <= memtoreg_o;
            ALUOp_o <= ALUOp_o;
            func3_o <= func3_o;
            func7_o <= func7_o;
            writeReg_o <= writeReg_o;
            readReg1_o <= readReg1_o;
            readReg2_o <= readReg2_o;
        end else begin
            readData1_o <= readData1_i;
            readData2_o <= readData2_i;
            pc_4_o <=pc_4_i;
            imm_o <= imm_i;
            regWrite_o <=regWrite_i;
            memRead_o <= memRead_i;
            memWrite_o <= memWrite_i;
            ALUSrc_o <= ALUSrc_i;
            memtoreg_o <= memtoreg_i;
            ALUOp_o <= ALUOp_i;
            func3_o <= func3_i;
            func7_o <= func7_i;
            writeReg_o <= writeReg_i;
            readReg1_o <= readReg1_i;
            readReg2_o <= readReg2_i;
        end 
    end
    
endmodule



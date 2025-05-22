module EX_MEM_Reg (
    input rst,
    input clk,
    input [31:0] ALUresult_i,
    input [31:0] readData2_i,
    input [31:0] pc_4_i,
    input [1:0] memtoreg_i,
    input [4:0] writeReg_i,
    input regWrite_i,
    input memRead_i,
    input memWrite_i,
    output reg [31:0] ALUresult_o,
    output reg [31:0] readData2_o,
    output reg [31:0] pc_4_o,
    output reg [1:0] memtoreg_o,
    output reg [4:0] writeReg_o,
    output reg regWrite_o,
    output reg memRead_o,
    output reg memWrite_o
);
    always @(posedge clk, negedge rst) begin
        if(~rst) begin
            ALUresult_o <= 0;
            readData2_o <= 0;
            regWrite_o <= 0;
            memRead_o <= 0;
            memWrite_o <= 0;
            memtoreg_o <= 0;
            writeReg_o <= 0;
            pc_4_o <= 0;
        end else begin
            ALUresult_o <= ALUresult_i;
            readData2_o <= readData2_i;
            regWrite_o <= regWrite_i;
            memRead_o <= memRead_i;
            memWrite_o <= memWrite_i;
            memtoreg_o <= memtoreg_i;
            writeReg_o <= writeReg_i;
            pc_4_o <= pc_4_i;
        end 
    end 
    
endmodule

module MEM_WB_Reg (
    input clk,
    input rst,
    input [31:0] ALUresult_i,
    input [31:0] readData_i,
    input [1:0] memtoreg_i,
    input [31:0] pc_4_i,
    input [4:0] writeReg_i,
    input regWrite_i,
    output reg [31:0]ALUresult_o,
    output reg [31:0]readData_o,
    output reg [1:0] memtoreg_o,
    output reg regWrite_o,
    output reg [31:0] pc_4_o,
    output reg [4:0] writeReg_o
);
    always@(posedge clk,negedge rst) begin
        if(~rst)begin
            ALUresult_o <= 0;
            readData_o <= 0;
            memtoreg_o <= 0;
            regWrite_o <=0;
            pc_4_o <= 0;
            writeReg_o <= 0;
        end else begin
            ALUresult_o <= ALUresult_i;
            readData_o <= readData_i;
            memtoreg_o <= memtoreg_i;
            regWrite_o <= regWrite_i;
            pc_4_o <= pc_4_i;
            writeReg_o <= writeReg_i;
        end
    
    end
    
endmodule


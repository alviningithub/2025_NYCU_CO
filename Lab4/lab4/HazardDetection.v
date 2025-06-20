module HazardDetection(
    input wire [6:0] id_opcode,
    input wire [1:0] mem_memtoReg,
    input wire [4:0] id_R1,      // Source register 1 in ID stage
    input wire [4:0] id_R2,      // Source register 2 in ID stage
    input wire [4:0] ex_Rd,       // Destination register in EX stage
    input wire [4:0] mem_Rd,       // Destination register in MEM stage
    input wire ex_MemRead,
    input wire mem_MemRead,       // lw
    output reg RePC,             // re-fetch the flushed instruction
    output reg Flush_HD    // flush IF/ID reg & ID/EX reg
);

    // This unit checks for potential data hazards that cannot be resolved by forwarding.

    // TODO: implement your hazard detection unit here

    // Hint:
    // You can design your own inputs and outputs as needed, as long as everything functions
    // correctly in the end.
    // Refer to the textbook for scenarios where forwarding cannot resolve data hazards,
    // for example, where using a stall might be necessary.

    // Be mindful of data hazards that may occur with branch instructions.
    // Data hazards can arise when a branch instruction depends on the result of previous instructions,
    // such as when the values being compared in a branch are not yet computed.
    // In such cases, if forwarding cannot resolve the hazard, you may need to insert a stall to avoid incorrect execution.

always @(*) begin
    if((ex_Rd == id_R1 || ex_Rd == id_R2 ) && (id_opcode == 7'b1100011|| id_opcode == 7'b1100111) && ex_Rd != 0) begin // branch and jalr @ id and data @ exe 
        RePC = 1'b1;
        Flush_HD = 1'b1;
    end else if( (ex_Rd == id_R1 || ex_Rd == id_R2 )&& ex_MemRead == 1 && ex_Rd != 0) begin //lw @ exe  and inst in id 
        RePC = 1'b1;
        Flush_HD = 1'b1;
    end else if((mem_Rd == id_R1 || mem_Rd == id_R2 ) && mem_MemRead == 1 && (id_opcode == 7'b1100011|| id_opcode == 7'b1100111) && mem_Rd != 0) begin //lw @ mem and branch jalr @ id
        RePC = 1'b1;
        Flush_HD = 1'b1;
    end else if( (mem_Rd == id_R1 || mem_Rd == id_R2) && mem_memtoReg == 2'b10 && (id_opcode == 7'b1100011|| id_opcode == 7'b1100111) && mem_Rd != 0)begin //pc+4 writeback @ mem and branch jalr @ id
        RePC = 1'b1;
        Flush_HD = 1'b1;
    end else begin
        RePC = 0;
        Flush_HD = 0;
    end
end


endmodule

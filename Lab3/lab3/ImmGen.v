module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] inst,
    output reg signed [31:0] imm
);
    // ImmGen generate imm value base opcode
    wire [6:0] opcode = inst[6:0];
    always @(*) begin
        case(opcode) 
            7'b0000011:
                imm = {{20{inst[31]}},inst[31:20]};
            7'b0010011:
                imm = {{20{inst[31]}},inst[31:20]};
            7'b1100111: //I-type
                imm = {{20{inst[31]}},inst[31:20]};
            7'b0100011: //S type
                imm = {{20{inst[31]}},inst[31:25],inst[11:7]};
            7'b1100011: //B type
                imm = {{20{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8]};
            7'b1101111: //J type
                imm = {{12{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21]};
            7'b0010111:
                imm = {inst[31:12],{12{1'b0}}};
            7'b0110111:
                imm = {inst[31:12],{12{1'b0}}};
            default: 
                imm = {32{1'b0}};
        endcase
    end

endmodule


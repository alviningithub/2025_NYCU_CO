module IF_ID_Reg (
    input wire clk,
    input wire rst,
    input wire [31:0] pc_i,
    input wire [31:0] pc_4_i,
    input wire [31:0] inst_i,
    output wire [31:0] pc_o,
    output wire [31:0] pc_4_o,
    output wire [31:0] inst_o
);
    // TODO:
    // Besides the IF/ID stage register provided in the template file,
    // you will also need to create other stage registers such as ID/EX, EX/MEM, MEM/WB, etc.

    // Hint:
    // There are two approaches to implement the stage registers:
    // 1. Use a generic Pipeline Register module to instantiate the registers for each stage,
    //    where each Pipeline Register handles only one type of data. This approach is modular,
    //    making it easy to modify later.
    // 2. Directly specialize the Pipeline Register into distinct modules for each stage,
    //    which makes the design more intuitive and easier to understand.
    // Choose the design approach that best suits your needs.
    reg [31:0]pc_reg;
    reg [31:0]pc_4_reg;
    reg [31:0]inst_reg;
    always @ (posedge clk,negedge rst ) begin
        if(~rst) begin
            pc_reg <= 0;
            pc_4_reg <= 0;
            inst_reg <= 0;
        end else begin
            pc_reg <= pc_i;
            pc_4_reg <= pc_4_i;
            inst_reg <= inst_i;
        end
    end
    assign pc_o = pc_reg;
    assign pc_4_o = pc_4_reg;
    assign inst_o = inst_reg;


endmodule



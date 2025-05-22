module BranchComp (
    input signed [31:0] A,B,
    output reg BrEq, BrLT
);
// BranchComp compares two inputs and then outputs BrEq and BrLT based on the result.
// TODO: implement your BranchComp here
// Hint: you can use operator to implement
    always@(*)begin
        if(A == B) begin
            BrEq = 1;
            BrLT = 0;
        end else if(A < B) begin
            BrEq = 0;
            BrLT = 1;
        end else begin
            BrEq = 0;
            BrLT = 0;
        end
    end
endmodule

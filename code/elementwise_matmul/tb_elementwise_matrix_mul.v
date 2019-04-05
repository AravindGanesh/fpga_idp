 module tb;

    // Inputs
    reg [71:0] A;
    reg [71:0] B;
    // Outputs
    wire [71:0] Res;

    // Instantiate the Unit Under Test (UUT)
    e_Mat_mult uut (
        .A(A), 
        .B(B), 
        .Res(Res)
    );

    initial begin
        // Apply Inputs
        A = 0;  B = 0;  #100;
        A = {8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7,8'd8,8'd9};
        B = {8'd10,8'd11,8'd12,8'd13,8'd14,8'd15,8'd16,8'd17,8'd18};
    end
      
endmodule
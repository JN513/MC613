module alu_tb ();

localparam AND = 2'b00;
localparam OR  = 2'b01;
localparam ADD = 2'b10;
localparam SUB = 2'b11;

reg [1:0] Alu_op;
reg [31:0] Alu_A, Alu_B;
wire [31:0] Alu_R;
wire Alu_Zero, Alu_Overflow, Alu_Cout;

Alu U1 (
    .ALUCtl   (Alu_op),
    .A        (Alu_A),
    .B        (Alu_B),
    .R        (Alu_R),
    .Zero     (Alu_Zero),
    .Overflow (Alu_Overflow),
    .Cout     (Alu_Cout)
);

initial begin
    $display("Inicio dos testes da ALU");
    
    // Teste AND
    Alu_op = AND; Alu_A = 32'hFFFFFFFF; Alu_B = 32'h0F0F0F0F;
    #10;
    $display("AND: A=%h, B=%h, R=%h, Zero=%b, Overflow=%b, Cout=%b", Alu_A, Alu_B, Alu_R, Alu_Zero, Alu_Overflow, Alu_Cout);
    if (Alu_R !== (Alu_A & Alu_B)) $display("ERRO AND");
    
    // Teste OR
    Alu_op = OR; Alu_A = 32'h00000000; Alu_B = 32'hF0F0F0F0;
    #10;
    $display("OR: A=%h, B=%h, R=%h, Zero=%b, Overflow=%b, Cout=%b", Alu_A, Alu_B, Alu_R, Alu_Zero, Alu_Overflow, Alu_Cout);
    if (Alu_R !== (Alu_A | Alu_B)) $display("ERRO OR");
    
    // Teste ADD sem overflow
    Alu_op = ADD; Alu_A = 32'h00000001; Alu_B = 32'h00000001;
    #10;
    $display("ADD: A=%h, B=%h, R=%h, Zero=%b, Overflow=%b, Cout=%b", Alu_A, Alu_B, Alu_R, Alu_Zero, Alu_Overflow, Alu_Cout);
    if (Alu_R !== (Alu_A + Alu_B)) $display("ERRO ADD");
    
    // Teste ADD com overflow
    Alu_op = ADD; Alu_A = 32'h7FFFFFFF; Alu_B = 32'h00000001;
    #10;
    $display("ADD Overflow: A=%h, B=%h, R=%h, Zero=%b, Overflow=%b, Cout=%b", Alu_A, Alu_B, Alu_R, Alu_Zero, Alu_Overflow, Alu_Cout);
    if (Alu_Overflow !== 1) $display("ERRO ADD Overflow");
    
    // Teste SUB sem overflow
    Alu_op = SUB; Alu_A = 32'h00000002; Alu_B = 32'h00000001;
    #10;
    $display("SUB: A=%h, B=%h, R=%h, Zero=%b, Overflow=%b, Cout=%b", Alu_A, Alu_B, Alu_R, Alu_Zero, Alu_Overflow, Alu_Cout);
    if (Alu_R !== (Alu_A - Alu_B)) $display("ERRO SUB");
    
    // Teste SUB com overflow
    Alu_op = SUB; Alu_A = 32'h80000000; Alu_B = 32'h00000001;
    #10;
    $display("SUB Overflow: A=%h, B=%h, R=%h, Zero=%b, Overflow=%b, Cout=%b", Alu_A, Alu_B, Alu_R, Alu_Zero, Alu_Overflow, Alu_Cout);
    if (Alu_Overflow !== 1) $display("ERRO SUB Overflow");
    
    // Teste Zero flag
    Alu_op = SUB; Alu_A = 32'h12345678; Alu_B = 32'h12345678;
    #10;
    $display("Zero Flag Test: A=%h, B=%h, R=%h, Zero=%b, Overflow=%b, Cout=%b", Alu_A, Alu_B, Alu_R, Alu_Zero, Alu_Overflow, Alu_Cout);
    if (Alu_Zero !== 1) $display("ERRO Zero Flag");
    
    $display("Fim dos testes");
    $finish;
end

endmodule
`timescale 1ns/1ps
//`define SINGLE_CYCLE 1 // Descomente para testar modo single-cycle

module multiplier_tb;

    parameter N = 4;

    reg clk;
    reg rst_n;
    reg set;
    reg [N-1:0] a, b;
    wire [2*N-1:0] r;
    wire ready;

    multiplier #(.N(N)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .set(set),
        .ready(ready),
        .a(a),
        .b(b),
        .r(r)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    reg ready_last;
    wire ready_posedge = ready && !ready_last;

    always @(posedge clk)
        ready_last <= ready;

    integer test_num;
    reg [2*N-1:0] expected;
    reg [7:0] timeout;
    reg match;

    initial begin
        // VCD
        $dumpfile("dump.vcd");
        $dumpvars(0, multiplier_tb);

        // Inicialização
        rst_n = 0;
        set   = 0;
        a     = 0;
        b     = 0;
        expected = 0;
        ready_last = 0;

        repeat (2) @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        // === TESTE 1 ===
        test_num = 1;
        a = 4; b = 3; expected = 12;
        set = 1; @(posedge clk); set = 0;
        timeout = 100; match = 0;
        while (!match && timeout > 0) begin
            @(posedge clk);
            if (ready_posedge) begin
                if (r !== expected)
                    $display("ERRO [teste %0d]: a=%0d, b=%0d, esperado=%0d, obtido=%0d", test_num, a, b, expected, r);
                else
                    $display("OK   [teste %0d]: a=%0d, b=%0d, resultado=%0d", test_num, a, b, r);
                match = 1;
            end
            timeout = timeout - 1;
        end
        if (!match)
            $fatal(1, "Timeout no teste %0d", test_num);

        // === TESTE 2 ===
        test_num = 2;
        a = 0; b = 7; expected = 0;
        set = 1; @(posedge clk); set = 0;
        timeout = 100; match = 0;
        while (!match && timeout > 0) begin
            @(posedge clk);
            if (ready_posedge) begin
                if (r !== expected)
                    $display("ERRO [teste %0d]: a=%0d, b=%0d, esperado=%0d, obtido=%0d", test_num, a, b, expected, r);
                else
                    $display("OK   [teste %0d]: a=%0d, b=%0d, resultado=%0d", test_num, a, b, r);
                match = 1;
            end
            timeout = timeout - 1;
        end
        if (!match)
            $fatal(1, "Timeout no teste %0d", test_num);

        // === TESTE 3 ===
        test_num = 3;
        a = 15; b = 15; expected = 225;
        set = 1; 
        @(posedge clk);
        @(posedge clk); 
        set = 0;
        timeout = 100; match = 0;
        while (!match && timeout > 0) begin
            @(posedge clk);
            if (ready_posedge) begin
                if (r !== expected)
                    $display("ERRO [teste %0d]: a=%0d, b=%0d, esperado=%0d, obtido=%0d", test_num, a, b, expected, r);
                else
                    $display("OK   [teste %0d]: a=%0d, b=%0d, resultado=%0d", test_num, a, b, r);
                match = 1;
            end
            timeout = timeout - 1;
        end
        if (!match)
            $fatal(1, "Timeout no teste %0d", test_num);

        // === TESTE 4 ===
        test_num = 4;
        a = 2; b = 5; expected = 10;
        set = 1;
        @(posedge clk);
        @(posedge clk);
         set = 0;
        timeout = 100; match = 0;
        while (!match && timeout > 0) begin
            @(posedge clk);
            if (ready_posedge) begin
                if (r !== expected)
                    $display("ERRO [teste %0d]: a=%0d, b=%0d, esperado=%0d, obtido=%0d", test_num, a, b, expected, r);
                else
                    $display("OK   [teste %0d]: a=%0d, b=%0d, resultado=%0d", test_num, a, b, r);
                match = 1;
            end
            timeout = timeout - 1;
        end
        if (!match)
            $fatal(1, "Timeout no teste %0d", test_num);

        // === TESTE 5 ===
        test_num = 5;
        a = 1; b = 0; expected = 0;
        set = 1; 
        @(posedge clk);
        @(posedge clk); 
        set = 0;
        timeout = 100; match = 0;
        while (!match && timeout > 0) begin
            @(posedge clk);
            if (ready_posedge) begin
                if (r !== expected)
                    $display("ERRO [teste %0d]: a=%0d, b=%0d, esperado=%0d, obtido=%0d", test_num, a, b, expected, r);
                else
                    $display("OK   [teste %0d]: a=%0d, b=%0d, resultado=%0d", test_num, a, b, r);
                match = 1;
            end
            timeout = timeout - 1;
        end
        if (!match)
            $fatal(1, "Timeout no teste %0d", test_num);

        $display("Todos os testes concluídos.");
        $finish;
    end

endmodule

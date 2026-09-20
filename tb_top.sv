module tb_top;

    parameter AXI_ID_SIZE = 2;
    parameter ROT_DEPTH   = 8;
    parameter ROB_DEPTH   = 16;
    parameter ROT_INDEX_WIDTH = 3;

    logic clk;
    logic reset;
    logic request;
    logic response;
    logic [31 : 0] data_in;
    logic [AXI_ID_SIZE - 1 : 0] axi_id;
    logic [AXI_ID_SIZE - 1 : 0] axi_id_response;
    logic [ROT_INDEX_WIDTH - 1 : 0] rot_index_response;
    logic[31 : 0] data_out;

    top_ROB dut (.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        request = 0;
        response = 0;
        data_in = 0;
        axi_id = 0;
        axi_id_response = 0;
        rot_index_response = 3'b111;
        reset = 1;
        repeat(2)@(posedge clk);
        reset = 0;

        request = 1;
        axi_id = 2'b00;
        @(posedge clk);
        request = 0;

        @(posedge clk);

        request = 1;
        axi_id = 2'b00;
        @(posedge clk);
        request = 0;

        @(posedge clk);

        request = 1;
        axi_id = 2'b00;
        @(posedge clk);
        request = 0;

        @(posedge clk);

        response = 1;
        axi_id_response = 2'b00;
        rot_index_response = 2'b10;
        data_in = 32'h0000_000F;
        @(posedge clk);
        response = 0;

        @(posedge clk);
        
        response = 1;
        axi_id_response = 2'b00;
        rot_index_response = 2'b00;
        data_in = 32'h0000_000E;
        @(posedge clk);
        response = 0;

        @(posedge clk);
        
        response = 1;
        axi_id_response = 2'b00;
        rot_index_response = 2'b01;
        data_in = 32'h0000_000D;
        @(posedge clk);
        response = 0;

        @(posedge clk);

        request = 1;
        axi_id = 2'b00;
        @(posedge clk);
        request = 0;

        @(posedge clk);

        request = 1;
        axi_id = 2'b00;
        @(posedge clk);
        request = 0;

        @(posedge clk);

        request = 1;
        axi_id = 2'b00;
        @(posedge clk);
        request = 0;

        @(posedge clk);

        response = 1;
        axi_id_response = 2'b00;
        rot_index_response = 2'b10;
        data_in = 32'h0000_000A;
        @(posedge clk);
        response = 0;

        @(posedge clk);
        
        response = 1;
        axi_id_response = 2'b00;
        rot_index_response = 2'b00;
        data_in = 32'h0000_000B;
        @(posedge clk);
        response = 0;

        @(posedge clk);
        
        response = 1;
        axi_id_response = 2'b00;
        rot_index_response = 2'b01;
        data_in = 32'h0000_000C;
        @(posedge clk);
        response = 0;

        @(posedge clk);

        @(posedge clk);

        request = 1;
        axi_id = 2'b00;
        @(posedge clk);
        request = 0;

        @(posedge clk);

        //request and response together
        response = 1;
        request = 1;
        axi_id_response = 2'b00;
        rot_index_response = 2'b00;
        data_in = 32'h0000_0009;
        axi_id = 2'b00;
        @(posedge clk);
        request = 0;
        response = 0;

        @(posedge clk);


        repeat(5)@(posedge clk);
        $finish;
    end

endmodule
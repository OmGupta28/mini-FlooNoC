//ill not test the ROB full mechanism 
module ROB #(
    parameter AXI_ID_SIZE = 2,
    parameter ROT_DEPTH   = 8,
    parameter ROB_DEPTH   = 16,
    parameter ROT_INDEX_WIDTH = 3
) (
    input logic clk,
    input logic reset,
    input logic [31 : 0] data_in, //some random data
    input logic request,
    input logic response,
    input logic pop,
    input logic[ROT_INDEX_WIDTH - 1 : 0] rot_index_rot,
    input logic[ROT_INDEX_WIDTH - 1 : 0] rot_index_response,
    output logic set_rot,
    output logic [ROT_INDEX_WIDTH - 1 : 0] rot_index_rob,
    output logic [31 : 0] data_out
);

logic [31 : 0] REORDER_BUFFER [0 : ROB_DEPTH - 1];
logic VALID [0 : ROB_DEPTH - 1];

always_ff @(posedge clk) begin 
    if (reset) begin
        rot_index_rob <= 0;
        data_out <= 0;
        set_rot <= 0;
        for (integer i = 0; i < ROB_DEPTH; i++) begin
            REORDER_BUFFER[i] <= 0;
            VALID[i] <= 0;
        end
    end
    else if (request) begin
        automatic logic valid_found = 0;
        for (integer i = 0; i < ROB_DEPTH; i++) begin
            if (VALID[i] == 0 && !valid_found) begin
                rot_index_rob <= i;
                VALID[i] <= 1;
                valid_found = 1;
                set_rot <= 1;
            end
        end
    end
    else begin
        set_rot <= 0;
    end
    if (response) begin
        REORDER_BUFFER[rot_index_response] <= data_in;
    end
    if (pop) begin
        data_out <= REORDER_BUFFER[rot_index_rot];
        VALID[rot_index_rot] <= 0; 
    end
end
    
endmodule
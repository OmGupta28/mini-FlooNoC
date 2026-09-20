//ill skip the full fifo testing
//cause its scope is limited and im too tired to work on it
module ROT #(
    parameter AXI_ID_SIZE = 2,
    parameter ROT_DEPTH   = 8,
    parameter ROT_INDEX_WIDTH = 3
) (
    input logic clk,
    input logic reset,
    input logic request,
    input logic response,
    input logic set_rot,
    input logic [AXI_ID_SIZE - 1 : 0] axi_id,
    input logic [AXI_ID_SIZE - 1 : 0] axi_id_response,
    input logic [ROT_INDEX_WIDTH - 1 : 0] rot_index_rob,
    input logic [ROT_INDEX_WIDTH - 1 : 0] rot_index_response,
    output logic pop,
    output logic [ROT_INDEX_WIDTH - 1 : 0] rot_index_rot 
);

logic [ROT_INDEX_WIDTH : 0] REORDER_TABLE [0 : ROT_DEPTH - 1]; //value 4 will be invalid
logic RECEIVED [0 : ROT_DEPTH - 1];
logic [2 : 0] read_pointer;
logic [2 : 0] write_pointer;

always_ff @(posedge clk) begin
    pop <= 0;
    if (reset) begin
        for (integer i = 0; i < ROT_DEPTH; i++) begin
            REORDER_TABLE[i] <= 3'b100;
            RECEIVED[i] <= 0;
        end
        rot_index_rot <= 0;
        pop <= 0;
        write_pointer <= 0;
        read_pointer  <= 0;
    end
    if (set_rot) begin
        if (axi_id == 2'b00) begin
            REORDER_TABLE[write_pointer] <= rot_index_rob;
            write_pointer <= write_pointer + 1;
            pop <= 0;
        end
    end
    if (axi_id_response == 2'b00 && (REORDER_TABLE[read_pointer] == rot_index_response)) begin
        rot_index_rot <= REORDER_TABLE[read_pointer];
        read_pointer <= read_pointer + 1;
        pop <= 1;
        REORDER_TABLE[read_pointer] <= 3'b100;
    end
    else if (RECEIVED[read_pointer]) begin
        rot_index_rot <= REORDER_TABLE[read_pointer];
        read_pointer <= read_pointer + 1;
        pop <= 1;
        REORDER_TABLE[read_pointer] <= 3'b100;
        RECEIVED[read_pointer] <= 0;
    end
    else if (response && axi_id_response == 2'b00) begin
        for (integer i = 0; i < ROT_DEPTH; i++) begin
           if (REORDER_TABLE[i] == rot_index_response) begin
                RECEIVED[i] <= 1;
           end 
        end
    end
end
endmodule
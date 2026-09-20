module top_ROB #(
    parameter AXI_ID_SIZE = 2,
    parameter ROT_DEPTH   = 8,
    parameter ROB_DEPTH   = 16,
    parameter ROT_INDEX_WIDTH = 3
) (
    input logic clk,
    input logic reset,
    input logic request,
    input logic response,
    input logic [31 : 0] data_in,
    input logic [AXI_ID_SIZE - 1 : 0] axi_id,
    input logic [AXI_ID_SIZE - 1 : 0] axi_id_response,
    input logic [ROT_INDEX_WIDTH - 1 : 0] rot_index_response,
    output logic[31 : 0] data_out
);

logic set_rot;
logic pop;
logic[ROT_INDEX_WIDTH - 1 : 0] rot_index_rot;
logic [ROT_INDEX_WIDTH - 1 : 0] rot_index_rob;

ROT rot_dut (
    .clk(clk),
    .reset(reset),
    .request(request),
    .response(response),
    .set_rot(set_rot),
    .axi_id(axi_id),
    .axi_id_response(axi_id_response),
    .rot_index_rob(rot_index_rob),
    .rot_index_response(rot_index_response),
    .pop(pop),
    .rot_index_rot(rot_index_rot)
);

ROB rob_dut (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .request(request),
    .response(response),
    .pop(pop),
    .rot_index_rot(rot_index_rot),
    .rot_index_response(rot_index_response),
    .set_rot(set_rot),
    .rot_index_rob(rot_index_rob),
    .data_out(data_out)
);

endmodule
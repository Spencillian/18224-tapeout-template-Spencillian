`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
    RangeFinder #(.WIDTH(8)) r0(.clock, .reset, 
                   .go(io_in[0]), .finish(io_out[0]), 
                   .data_in(io_in[11:4]), 
                   .range(io_out[11:4]), 
                   .debug_error(io_out[1]));

endmodule

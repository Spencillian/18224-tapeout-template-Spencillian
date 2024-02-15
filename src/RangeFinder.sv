`default_nettype none

module RangeFinder
    #(parameter WIDTH=16)
    (input logic [WIDTH-1:0] data_in,
    input logic clock, reset,
    input logic go, finish,
    output logic [WIDTH-1:0] range,
    output logic debug_error);

    enum logic { WAIT, WORKING } state, next;
    logic [WIDTH-1:0] min, max;

    always_comb begin
        case(state)
            WAIT: begin
                if(go && !finish) next = WORKING;
                else next = WAIT;
            end
            WORKING: begin
                if(finish) next = WAIT;
                else next = WORKING;
            end
            default: next = WAIT;
        endcase
    end

    assign range = max - min;

    always_ff @(posedge clock) begin
        if(finish && go) debug_error <= '1;
        else if (finish && state == WAIT) debug_error <= '1;
        else if (go && state == WAIT) debug_error <= '0;
    end

    always_ff @(posedge clock, posedge reset) begin
        if(reset) begin
            state <= WAIT;
            min <= '1;
            max <= '0;
        end else begin
            state <= next;

            if(state == WORKING) begin
                if(data_in > max) max <= data_in;
                if(data_in < min) min <= data_in;
            end
        end
    end

endmodule: RangeFinder

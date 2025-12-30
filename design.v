module spi_master_duplex #(
    parameter DATA_WIDTH = 8,
    parameter CLK_DIV = 4
)(
    input  wire clk,                       // system clock
    input  wire rst,                       // active-high reset
    input  wire start,                     // start signal
    input  wire [DATA_WIDTH-1:0] data_in,  // data to transmit
    input  reg miso,                      // master in, slave out

    output reg  mosi,                      // master out, slave in
    output reg  sclk,                      // SPI clock
    output reg  ss,                        // active-low chip select
    output reg  [DATA_WIDTH-1:0] data_out, // received data
    output reg  done                       // transfer complete
);

    // Internal registers
    reg [DATA_WIDTH-1:0] shift_tx;
    reg [DATA_WIDTH-1:0] shift_rx;
    reg [7:0] clk_count;
    reg [3:0] bit_count;
    reg spi_clk_en;

    // SPI FSM
    localparam IDLE = 2'b00,
               LOAD = 2'b01,
               TRANSFER = 2'b10,
               DONE = 2'b11;

    reg [1:0] state, next_state;

    // Clock Divider for SCLK
  always @(posedge clk or posedge rst) begin
    if (rst || !start) begin
            clk_count <= 0;
            sclk <= 0;
        end else if (spi_clk_en) begin
            if (clk_count == (CLK_DIV - 1)) begin
                clk_count <= 0;
                sclk <= ~sclk;
            end else begin
                clk_count <= clk_count + 1;
            end
        end else begin
            sclk <= 0;
            clk_count <= 0;
        end
    end

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE:     next_state = start ? LOAD : IDLE;
            LOAD:     next_state = TRANSFER;
            TRANSFER: next_state = (bit_count == DATA_WIDTH && sclk == 1'b1) ? DONE : TRANSFER;
            DONE:     next_state = IDLE;
            default:  next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_tx <= 0;
            shift_rx <= 0;
            bit_count <= 0;
            ss <= 1;
            mosi <= 0;
            data_out <= 0;
            spi_clk_en <= 0;
            done <= 0;
          	sclk<=0;
        end else begin
            case (state)
                IDLE: begin                 	
                    ss <= 1;
                    done <= 0;
                    spi_clk_en <= 0;
                  	sclk<=0;
                  	mosi<=0;
                  	shift_tx<='0;
                  
                end
             

                LOAD: begin
                    ss <= 0;
                    shift_tx <= data_in;
                    shift_rx <= 0;
                    bit_count <= 0;
                    spi_clk_en <= 1;
                end

                TRANSFER: begin
                    // On falling edge of SCLK: send MOSI bit
                    if (sclk == 0 && clk_count == 0) begin
                        mosi <= shift_tx[DATA_WIDTH-1];
                    end
                    // On rising edge of SCLK: sample MISO and shift TX
                    if (sclk == 1 && clk_count == 0) begin
                        shift_tx <= {shift_tx[DATA_WIDTH-2:0], 1'b0};
                        shift_rx <= {shift_rx[DATA_WIDTH-2:0], miso};
                        bit_count <= bit_count + 1;
                    end
                end

                DONE: begin
                    ss <= 1;
                    spi_clk_en <= 0;
                    data_out <= shift_rx;
                  	mosi<=0;
                    done <= 1;
                end
            endcase
        end
    end
endmodule

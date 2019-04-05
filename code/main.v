module top(clk_100mhz, rpi_sck, rpi_cs, rpi_mosi);

parameter ClkFreq = 50000000; // Hz

input clk_100mhz;
input rpi_sck, rpi_cs, rpi_mosi;

// Clock Generator
wire clk_50mhz;
wire pll_locked;

SB_PLL40_PAD #(
  .FEEDBACK_PATH("SIMPLE"),
  .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
  .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
  .PLLOUT_SELECT("GENCLK"),
  .FDA_FEEDBACK(4'b1111),
  .FDA_RELATIVE(4'b1111),
  .DIVR(4'b0000),
  .DIVF(7'b0000111),
  .DIVQ(3'b100),
  .FILTER_RANGE(3'b101)
) pll (
  .PACKAGEPIN(clk_100mhz),
  .PLLOUTGLOBAL(clk_50mhz),
  .LOCK(pll_locked),
  .BYPASS(1'b0),
  .RESETB(1'b1)
);

wire clk = clk_50mhz;

// Reset Generator
reg [3:0] resetn_gen = 0;
reg reset;

always @(posedge clk) begin
  reset <= !&resetn_gen;
  resetn_gen <= {resetn_gen, pll_locked};
end

// SPI Clock Generator
localparam SpiDesiredFreq = 6250000; // Hz
localparam SpiPeriod = (ClkFreq + (SpiDesiredFreq * 2) - 1) / (SpiDesiredFreq * 2);
localparam SpiFreq = ClkFreq / (SpiPeriod * 2);

wire spi_clk, spi_reset;
clock_generator #(SpiPeriod) spi_clkgen(clk, reset, spi_clk, spi_reset);


wire frame_begin, sending_pixels, sample_pixel;
wire [12:0] pixel_index;
wire [15:0] pixel_data, ram_pixel_data;
wire [6:0] x;
wire [5:0] y;

wire ram_wr;
wire [12:0] ram_addr;
wire [15:0] ram_data;

coordinate_decoder coordinate_decoder(spi_clk, sending_pixels, sample_pixel,
  x, y);

spi_ram_slave spi_ram_slave(clk, rpi_sck, rpi_cs, rpi_mosi,
  ram_addr, ram_data, ram_wr);

ram_source ram_source(spi_clk, spi_reset, frame_begin, sample_pixel,
  pixel_index, ram_pixel_data, clk, ram_wr, ram_addr, ram_data);


always @(*) begin
  pixel_data = ram_pixel_data;
end

endmodule

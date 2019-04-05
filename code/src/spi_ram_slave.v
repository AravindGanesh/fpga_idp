/**
 * A SPI receive-only slave with a RAM interface as an output. The RAM can be
 * asynchronously rewritten by a random-access write-only interface.
 *
 * The module uses 24x iCE40 block-RAMs internally. In the iCE40, block-RAMs
 * have two independently clocked ports, with one read-only port and one
 * write-only port. Therefore, the read-port is clocked by the pixel clock,
 * while the read-port
 */
module spi_ram_slave(clk, sck, cs, mosi, ram_addr, ram_data, ram_wr);
localparam WordWidth = 16;
localparam WordCount = 64 * 96;

input clk, sck, cs, mosi;
output [$clog2(WordCount)-1:0] ram_addr;
output [WordWidth-1:0] ram_data;
output ram_wr;

reg [2:0] sckr, csr;
reg [1:0] mosir;

always @(negedge clk) sckr <= {sckr[1:0], sck};
wire sck_rising = sckr[2:1] == 2'b01;

always @(negedge clk) csr <= {csr[1:0], cs};
wire cs_active = !csr[1];

always @(negedge clk) mosir <= {mosir[0], mosi};
wire mosi_data = mosir[1];

reg word_received;
reg [$clog2(WordWidth)-1:0] bits_remain;
reg [$clog2(WordCount)-1:0] addr;
reg [WordWidth-1:0] data;

assign ram_addr = addr;
assign ram_data = {data[7:0], data[15:8]};
assign ram_wr = word_received;

always @(negedge clk) begin
  if(!cs_active) begin
    bits_remain <= WordWidth - 1;
    addr <= 0;
    data <= 0;
  end else if(sck_rising) begin
    data <= {data[WordWidth-2:0], mosi_data};
    bits_remain <= (bits_remain == 0) ? WordWidth - 1 : bits_remain - 1;
  end

  word_received <= (cs_active && sck_rising && bits_remain == 0);

  if (word_received)
      addr <= addr + 1;
end

endmodule

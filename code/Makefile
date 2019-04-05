.PHONY: synthesize
synthesize: $(v_fname).bin

src=\
	src/clock_generator.v \
	src/coordinate_decoder.v \
	src/ram_source.v \
	src/spi_ram_slave.v

$(img_fname).hex: $(img_fname).jpg
	ffmpeg -i $< -f rawvideo -pix_fmt rgb565 - | od -An -vtx2 -w2 > $@

$(v_fname).blif: $(v_fname).v $(src) src/ram_template.hex
	yosys -q -p "synth_ice40 -blif $(v_fname).blif" $(v_fname).v $(src)

$(v_fname).asc.template: $(v_fname).blif $(v_fname).pcf
	arachne-pnr -d 8k -p $(v_fname).pcf $< -o $@
	icetime -d hx8k -c 50 $@

$(v_fname).asc: $(v_fname).asc.template src/ram_template.hex $(img_fname).hex
	icebram src/ram_template.hex $(img_fname).hex < $< > $@

$(v_fname).bin: $(v_fname).asc
	icepack $< $@

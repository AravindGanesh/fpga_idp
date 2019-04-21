.PHONY: default
default: prog_sram

$(v_fname).blif: $(v_fname).v clock_generator.v sobel_filter.v
	yosys -p 'synth_ice40 -blif $(v_fname).blif' $(v_fname).v clock_generator.v sobel_filter.v

$(v_fname).asc: $(v_fname).blif
	arachne-pnr -d 8k -o $(v_fname).asc $(v_fname).blif

$(v_fname).bin: $(v_fname).asc
	#icetime -d hx8k -c 25 $(v_fname).asc
	icepack $(v_fname).asc $(v_fname).bin

prog_sram: $(v_fname).bin
	icoprog -p < $(v_fname).bin

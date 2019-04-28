.PHONY: default initialize 
default:  prog_sram 

$(v_fname).blif: $(v_fname).v conv.v
	yosys -p 'synth_ice40 -blif $(v_fname).blif' $(v_fname).v conv.v

$(v_fname).asc: $(v_fname).blif $(v_fname).pcf
	arachne-pnr -d 8k -p $(v_fname).pcf -o $(v_fname).asc $(v_fname).blif

$(v_fname).bin: $(v_fname).asc
	icetime -d hx8k -c 25 $(v_fname).asc
	icepack $(v_fname).asc $(v_fname).bin

prog_sram: $(v_fname).bin
	icoprog -p < $(v_fname).bin

initialize:
	python image_initialization.py

receive:
	python receive_img.py

clean:
	rm -r *.asc *.blif *.bin

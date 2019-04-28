# Sobel Filter for edge detection 
Semester Project on FPGA - Verilog implementation on Sobel Filter for Edge detection on icoboard FPGA

The project folder `src/` contains the following folders
`blink_example`
`elementwise_matrix_mul`
`sobel_flter`

### Make 
Use `make v_fname=<filename>` to compile and upload binary file to icoboard. 

### contents
`src/sobel_filter/` containts the following codes

`image_initialization.py` : read image and initialize it in `sobel_uart.v`
`conv.v` : verlog code for convolution of 28x28(5 bit) image with 3x3(3 bit signed) filter. Gives the out put 26x26(8 bit) image
`sobel_uart.v` : uses the `conv` module to apply the horizontal/vertical mask to the image and sends the output to PI using UART protocol. Since Icoboard is connected to Pi using GPIO pins, we are sending the data back using FTDI.

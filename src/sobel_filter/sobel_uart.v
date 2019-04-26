////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	helloworld.v
//
// Project:	ICO Zip, iCE40 ZipCPU demonsrtation project
//
// Purpose:	To create a *very* simple UART test program, which can be used
//		as the top level design file of any FPGA program.
//
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2015-2017, Gisselquist Technology, LLC
//
// This program is free software (firmware): you can redistribute it and/or
// modify it under the terms of  the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
// target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
//
module	sobel_uart(i_clk,
			o_ledg,
			i_rts, i_uart_rx, o_cts,
			o_uart_tx);
	//
	input		i_clk;
	output	wire	o_ledg;
	input		i_rts, i_uart_rx;
	output		o_cts;
	output	wire	o_uart_tx;

	assign	o_cts = 1'b1;

	// If i_setup isnt set up as an input parameter, it needs to be set.
	// We do so here, to a setting appropriate to create a 115200 Baud
	// comms system from a 100MHz clock.  This also sets us to an 8-bit
	// data word, 1-stop bit, and no parity.
	wire	[29:0]	i_setup;
	assign		i_setup = 30'd868;	// 115200 Baud, if clk @ 100MHz

	reg	pwr_reset;
	initial	pwr_reset = 1'b1;
	always @(posedge i_clk)
		pwr_reset <= 1'b0;

	reg	[24:0]	ledctr;
	initial	ledctr = 0;
	always @(posedge i_clk)
		if (!o_uart_tx)
			ledctr <= 0;
		else if (ledctr != {(25){1'b1}})
			ledctr <= ledctr + 1'b1;
	assign	o_ledg = !ledctr[24];
	
	reg	[7:0]	message	[0:675];
	
	// Inputs
    reg [6271:0] A;
    reg [71:0] B;
    // Outputs
    reg [5407:0] Res;
    // Instantiate the convolution module
    conv filter (
        .A(A), 
        .B(B), 
        .Res(Res)
    );

    initial begin
        // Apply Inputs
        //vertical sobel filter
        B <= {8'd1,8'd0,-8'd1,8'd2,8'd0,-8'd2,8'd1,8'd0,-8'd1};
        // horizantal sobel filter
        //B <= {8'd1,8'd2,8'd1,8'd0,8'd0,8'd0,-8'd1,-8'd2,-8'd1};
A <= {5'd0,5'd2,5'd1,5'd0,5'd4,5'd2,5'd0,5'd0,5'd2,5'd0,5'd3,5'd9,5'd0,5'd0,5'd6,5'd0,5'd0,5'd0,5'd9,5'd0,5'd0,5'd8,5'd0,5'd1,5'd0,5'd0,5'd0,5'd0,5'd5,5'd6,5'd0,5'd0,5'd1,5'd5,5'd3,5'd7,5'd0,5'd11,5'd0,5'd0,5'd4,5'd0,5'd0,5'd4,5'd0,5'd0,5'd0,5'd0,5'd13,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd5,5'd7,5'd3,5'd1,5'd0,5'd0,5'd0,5'd0,5'd4,5'd0,5'd0,5'd4,5'd6,5'd0,5'd2,5'd5,5'd9,5'd0,5'd0,5'd14,5'd0,5'd0,5'd6,5'd0,5'd0,5'd0,5'd0,5'd3,5'd4,5'd0,5'd0,5'd1,5'd1,5'd4,5'd17,5'd1,5'd0,5'd16,5'd14,5'd0,5'd0,5'd11,5'd0,5'd0,5'd0,5'd14,5'd0,5'd2,5'd0,5'd4,5'd2,5'd0,5'd0,5'd0,5'd0,5'd10,5'd1,5'd0,5'd0,5'd10,5'd5,5'd0,5'd0,5'd8,5'd26,5'd101,5'd183,5'd225,5'd246,5'd220,5'd153,5'd42,5'd0,5'd7,5'd1,5'd0,5'd5,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd2,5'd5,5'd7,5'd5,5'd0,5'd0,5'd14,5'd91,5'd208,5'd255,5'd242,5'd180,5'd127,5'd159,5'd254,5'd185,5'd46,5'd0,5'd3,5'd0,5'd4,5'd0,5'd4,5'd0,5'd0,5'd0,5'd0,5'd0,5'd6,5'd5,5'd0,5'd0,5'd0,5'd41,5'd94,5'd247,5'd206,5'd81,5'd0,5'd0,5'd0,5'd10,5'd79,5'd255,5'd149,5'd0,5'd0,5'd0,5'd0,5'd0,5'd12,5'd0,5'd0,5'd0,5'd0,5'd1,5'd0,5'd0,5'd1,5'd5,5'd0,5'd0,5'd4,5'd0,5'd3,5'd0,5'd0,5'd9,5'd0,5'd0,5'd32,5'd237,5'd196,5'd0,5'd0,5'd3,5'd0,5'd1,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd8,5'd0,5'd0,5'd0,5'd12,5'd4,5'd3,5'd76,5'd255,5'd112,5'd0,5'd6,5'd1,5'd0,5'd0,5'd4,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd12,5'd10,5'd0,5'd0,5'd0,5'd68,5'd231,5'd218,5'd19,5'd0,5'd13,5'd5,5'd0,5'd11,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd21,5'd0,5'd0,5'd2,5'd15,5'd108,5'd228,5'd254,5'd83,5'd0,5'd14,5'd0,5'd2,5'd4,5'd6,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd1,5'd58,5'd165,5'd228,5'd255,5'd246,5'd140,5'd4,5'd0,5'd0,5'd0,5'd4,5'd6,5'd0,5'd12,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd9,5'd0,5'd62,5'd176,5'd164,5'd173,5'd255,5'd255,5'd222,5'd100,5'd0,5'd0,5'd4,5'd2,5'd0,5'd1,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd22,5'd0,5'd0,5'd15,5'd0,5'd32,5'd162,5'd255,5'd241,5'd138,5'd16,5'd0,5'd0,5'd19,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd7,5'd1,5'd0,5'd2,5'd3,5'd0,5'd8,5'd15,5'd178,5'd255,5'd144,5'd4,5'd0,5'd2,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd8,5'd0,5'd8,5'd1,5'd0,5'd11,5'd0,5'd0,5'd0,5'd34,5'd191,5'd255,5'd50,5'd14,5'd0,5'd1,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd6,5'd0,5'd0,5'd2,5'd6,5'd0,5'd0,5'd3,5'd5,5'd0,5'd0,5'd0,5'd1,5'd1,5'd6,5'd0,5'd56,5'd255,5'd164,5'd1,5'd0,5'd2,5'd0,5'd0,5'd0,5'd0,5'd2,5'd5,5'd0,5'd6,5'd20,5'd0,5'd0,5'd1,5'd0,5'd2,5'd6,5'd0,5'd0,5'd0,5'd2,5'd1,5'd0,5'd15,5'd4,5'd243,5'd186,5'd0,5'd17,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd6,5'd0,5'd0,5'd0,5'd15,5'd0,5'd11,5'd2,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd8,5'd0,5'd87,5'd250,5'd127,5'd0,5'd3,5'd6,5'd0,5'd0,5'd0,5'd0,5'd19,5'd1,5'd0,5'd0,5'd6,5'd224,5'd64,5'd0,5'd8,5'd0,5'd0,5'd3,5'd10,5'd2,5'd0,5'd8,5'd0,5'd35,5'd229,5'd224,5'd47,5'd10,5'd0,5'd3,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd6,5'd6,5'd0,5'd255,5'd122,5'd0,5'd0,5'd5,5'd13,5'd1,5'd0,5'd0,5'd2,5'd0,5'd98,5'd223,5'd244,5'd106,5'd0,5'd9,5'd0,5'd3,5'd0,5'd0,5'd0,5'd0,5'd16,5'd6,5'd4,5'd0,5'd7,5'd192,5'd224,5'd140,5'd76,5'd7,5'd0,5'd11,5'd8,5'd0,5'd92,5'd226,5'd250,5'd241,5'd120,5'd13,5'd0,5'd0,5'd10,5'd3,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd10,5'd0,5'd0,5'd52,5'd200,5'd254,5'd230,5'd255,5'd255,5'd203,5'd186,5'd222,5'd244,5'd231,5'd145,5'd55,5'd5,5'd3,5'd1,5'd4,5'd2,5'd0,5'd0,5'd0,5'd0,5'd0,5'd12,5'd0,5'd0,5'd3,5'd0,5'd0,5'd36,5'd113,5'd178,5'd222,5'd225,5'd181,5'd167,5'd171,5'd115,5'd30,5'd0,5'd12,5'd0,5'd0,5'd0,5'd0,5'd13,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0,5'd0};
    end
	

initial begin // assign output pixel values to message array
message[0 ] <= Res[5407:5400];
message[1 ] <= Res[5399:5392];
message[2 ] <= Res[5391:5384];
message[3 ] <= Res[5383:5376];
message[4 ] <= Res[5375:5368];
message[5 ] <= Res[5367:5360];
message[6 ] <= Res[5359:5352];
message[7 ] <= Res[5351:5344];
message[8 ] <= Res[5343:5336];
message[9 ] <= Res[5335:5328];
message[10 ] <= Res[5327:5320];
message[11 ] <= Res[5319:5312];
message[12 ] <= Res[5311:5304];
message[13 ] <= Res[5303:5296];
message[14 ] <= Res[5295:5288];
message[15 ] <= Res[5287:5280];
message[16 ] <= Res[5279:5272];
message[17 ] <= Res[5271:5264];
message[18 ] <= Res[5263:5256];
message[19 ] <= Res[5255:5248];
message[20 ] <= Res[5247:5240];
message[21 ] <= Res[5239:5232];
message[22 ] <= Res[5231:5224];
message[23 ] <= Res[5223:5216];
message[24 ] <= Res[5215:5208];
message[25 ] <= Res[5207:5200];
message[26 ] <= Res[5199:5192];
message[27 ] <= Res[5191:5184];
message[28 ] <= Res[5183:5176];
message[29 ] <= Res[5175:5168];
message[30 ] <= Res[5167:5160];
message[31 ] <= Res[5159:5152];
message[32 ] <= Res[5151:5144];
message[33 ] <= Res[5143:5136];
message[34 ] <= Res[5135:5128];
message[35 ] <= Res[5127:5120];
message[36 ] <= Res[5119:5112];
message[37 ] <= Res[5111:5104];
message[38 ] <= Res[5103:5096];
message[39 ] <= Res[5095:5088];
message[40 ] <= Res[5087:5080];
message[41 ] <= Res[5079:5072];
message[42 ] <= Res[5071:5064];
message[43 ] <= Res[5063:5056];
message[44 ] <= Res[5055:5048];
message[45 ] <= Res[5047:5040];
message[46 ] <= Res[5039:5032];
message[47 ] <= Res[5031:5024];
message[48 ] <= Res[5023:5016];
message[49 ] <= Res[5015:5008];
message[50 ] <= Res[5007:5000];
message[51 ] <= Res[4999:4992];
message[52 ] <= Res[4991:4984];
message[53 ] <= Res[4983:4976];
message[54 ] <= Res[4975:4968];
message[55 ] <= Res[4967:4960];
message[56 ] <= Res[4959:4952];
message[57 ] <= Res[4951:4944];
message[58 ] <= Res[4943:4936];
message[59 ] <= Res[4935:4928];
message[60 ] <= Res[4927:4920];
message[61 ] <= Res[4919:4912];
message[62 ] <= Res[4911:4904];
message[63 ] <= Res[4903:4896];
message[64 ] <= Res[4895:4888];
message[65 ] <= Res[4887:4880];
message[66 ] <= Res[4879:4872];
message[67 ] <= Res[4871:4864];
message[68 ] <= Res[4863:4856];
message[69 ] <= Res[4855:4848];
message[70 ] <= Res[4847:4840];
message[71 ] <= Res[4839:4832];
message[72 ] <= Res[4831:4824];
message[73 ] <= Res[4823:4816];
message[74 ] <= Res[4815:4808];
message[75 ] <= Res[4807:4800];
message[76 ] <= Res[4799:4792];
message[77 ] <= Res[4791:4784];
message[78 ] <= Res[4783:4776];
message[79 ] <= Res[4775:4768];
message[80 ] <= Res[4767:4760];
message[81 ] <= Res[4759:4752];
message[82 ] <= Res[4751:4744];
message[83 ] <= Res[4743:4736];
message[84 ] <= Res[4735:4728];
message[85 ] <= Res[4727:4720];
message[86 ] <= Res[4719:4712];
message[87 ] <= Res[4711:4704];
message[88 ] <= Res[4703:4696];
message[89 ] <= Res[4695:4688];
message[90 ] <= Res[4687:4680];
message[91 ] <= Res[4679:4672];
message[92 ] <= Res[4671:4664];
message[93 ] <= Res[4663:4656];
message[94 ] <= Res[4655:4648];
message[95 ] <= Res[4647:4640];
message[96 ] <= Res[4639:4632];
message[97 ] <= Res[4631:4624];
message[98 ] <= Res[4623:4616];
message[99 ] <= Res[4615:4608];
message[100 ] <= Res[4607:4600];
message[101 ] <= Res[4599:4592];
message[102 ] <= Res[4591:4584];
message[103 ] <= Res[4583:4576];
message[104 ] <= Res[4575:4568];
message[105 ] <= Res[4567:4560];
message[106 ] <= Res[4559:4552];
message[107 ] <= Res[4551:4544];
message[108 ] <= Res[4543:4536];
message[109 ] <= Res[4535:4528];
message[110 ] <= Res[4527:4520];
message[111 ] <= Res[4519:4512];
message[112 ] <= Res[4511:4504];
message[113 ] <= Res[4503:4496];
message[114 ] <= Res[4495:4488];
message[115 ] <= Res[4487:4480];
message[116 ] <= Res[4479:4472];
message[117 ] <= Res[4471:4464];
message[118 ] <= Res[4463:4456];
message[119 ] <= Res[4455:4448];
message[120 ] <= Res[4447:4440];
message[121 ] <= Res[4439:4432];
message[122 ] <= Res[4431:4424];
message[123 ] <= Res[4423:4416];
message[124 ] <= Res[4415:4408];
message[125 ] <= Res[4407:4400];
message[126 ] <= Res[4399:4392];
message[127 ] <= Res[4391:4384];
message[128 ] <= Res[4383:4376];
message[129 ] <= Res[4375:4368];
message[130 ] <= Res[4367:4360];
message[131 ] <= Res[4359:4352];
message[132 ] <= Res[4351:4344];
message[133 ] <= Res[4343:4336];
message[134 ] <= Res[4335:4328];
message[135 ] <= Res[4327:4320];
message[136 ] <= Res[4319:4312];
message[137 ] <= Res[4311:4304];
message[138 ] <= Res[4303:4296];
message[139 ] <= Res[4295:4288];
message[140 ] <= Res[4287:4280];
message[141 ] <= Res[4279:4272];
message[142 ] <= Res[4271:4264];
message[143 ] <= Res[4263:4256];
message[144 ] <= Res[4255:4248];
message[145 ] <= Res[4247:4240];
message[146 ] <= Res[4239:4232];
message[147 ] <= Res[4231:4224];
message[148 ] <= Res[4223:4216];
message[149 ] <= Res[4215:4208];
message[150 ] <= Res[4207:4200];
message[151 ] <= Res[4199:4192];
message[152 ] <= Res[4191:4184];
message[153 ] <= Res[4183:4176];
message[154 ] <= Res[4175:4168];
message[155 ] <= Res[4167:4160];
message[156 ] <= Res[4159:4152];
message[157 ] <= Res[4151:4144];
message[158 ] <= Res[4143:4136];
message[159 ] <= Res[4135:4128];
message[160 ] <= Res[4127:4120];
message[161 ] <= Res[4119:4112];
message[162 ] <= Res[4111:4104];
message[163 ] <= Res[4103:4096];
message[164 ] <= Res[4095:4088];
message[165 ] <= Res[4087:4080];
message[166 ] <= Res[4079:4072];
message[167 ] <= Res[4071:4064];
message[168 ] <= Res[4063:4056];
message[169 ] <= Res[4055:4048];
message[170 ] <= Res[4047:4040];
message[171 ] <= Res[4039:4032];
message[172 ] <= Res[4031:4024];
message[173 ] <= Res[4023:4016];
message[174 ] <= Res[4015:4008];
message[175 ] <= Res[4007:4000];
message[176 ] <= Res[3999:3992];
message[177 ] <= Res[3991:3984];
message[178 ] <= Res[3983:3976];
message[179 ] <= Res[3975:3968];
message[180 ] <= Res[3967:3960];
message[181 ] <= Res[3959:3952];
message[182 ] <= Res[3951:3944];
message[183 ] <= Res[3943:3936];
message[184 ] <= Res[3935:3928];
message[185 ] <= Res[3927:3920];
message[186 ] <= Res[3919:3912];
message[187 ] <= Res[3911:3904];
message[188 ] <= Res[3903:3896];
message[189 ] <= Res[3895:3888];
message[190 ] <= Res[3887:3880];
message[191 ] <= Res[3879:3872];
message[192 ] <= Res[3871:3864];
message[193 ] <= Res[3863:3856];
message[194 ] <= Res[3855:3848];
message[195 ] <= Res[3847:3840];
message[196 ] <= Res[3839:3832];
message[197 ] <= Res[3831:3824];
message[198 ] <= Res[3823:3816];
message[199 ] <= Res[3815:3808];
message[200 ] <= Res[3807:3800];
message[201 ] <= Res[3799:3792];
message[202 ] <= Res[3791:3784];
message[203 ] <= Res[3783:3776];
message[204 ] <= Res[3775:3768];
message[205 ] <= Res[3767:3760];
message[206 ] <= Res[3759:3752];
message[207 ] <= Res[3751:3744];
message[208 ] <= Res[3743:3736];
message[209 ] <= Res[3735:3728];
message[210 ] <= Res[3727:3720];
message[211 ] <= Res[3719:3712];
message[212 ] <= Res[3711:3704];
message[213 ] <= Res[3703:3696];
message[214 ] <= Res[3695:3688];
message[215 ] <= Res[3687:3680];
message[216 ] <= Res[3679:3672];
message[217 ] <= Res[3671:3664];
message[218 ] <= Res[3663:3656];
message[219 ] <= Res[3655:3648];
message[220 ] <= Res[3647:3640];
message[221 ] <= Res[3639:3632];
message[222 ] <= Res[3631:3624];
message[223 ] <= Res[3623:3616];
message[224 ] <= Res[3615:3608];
message[225 ] <= Res[3607:3600];
message[226 ] <= Res[3599:3592];
message[227 ] <= Res[3591:3584];
message[228 ] <= Res[3583:3576];
message[229 ] <= Res[3575:3568];
message[230 ] <= Res[3567:3560];
message[231 ] <= Res[3559:3552];
message[232 ] <= Res[3551:3544];
message[233 ] <= Res[3543:3536];
message[234 ] <= Res[3535:3528];
message[235 ] <= Res[3527:3520];
message[236 ] <= Res[3519:3512];
message[237 ] <= Res[3511:3504];
message[238 ] <= Res[3503:3496];
message[239 ] <= Res[3495:3488];
message[240 ] <= Res[3487:3480];
message[241 ] <= Res[3479:3472];
message[242 ] <= Res[3471:3464];
message[243 ] <= Res[3463:3456];
message[244 ] <= Res[3455:3448];
message[245 ] <= Res[3447:3440];
message[246 ] <= Res[3439:3432];
message[247 ] <= Res[3431:3424];
message[248 ] <= Res[3423:3416];
message[249 ] <= Res[3415:3408];
message[250 ] <= Res[3407:3400];
message[251 ] <= Res[3399:3392];
message[252 ] <= Res[3391:3384];
message[253 ] <= Res[3383:3376];
message[254 ] <= Res[3375:3368];
message[255 ] <= Res[3367:3360];
message[256 ] <= Res[3359:3352];
message[257 ] <= Res[3351:3344];
message[258 ] <= Res[3343:3336];
message[259 ] <= Res[3335:3328];
message[260 ] <= Res[3327:3320];
message[261 ] <= Res[3319:3312];
message[262 ] <= Res[3311:3304];
message[263 ] <= Res[3303:3296];
message[264 ] <= Res[3295:3288];
message[265 ] <= Res[3287:3280];
message[266 ] <= Res[3279:3272];
message[267 ] <= Res[3271:3264];
message[268 ] <= Res[3263:3256];
message[269 ] <= Res[3255:3248];
message[270 ] <= Res[3247:3240];
message[271 ] <= Res[3239:3232];
message[272 ] <= Res[3231:3224];
message[273 ] <= Res[3223:3216];
message[274 ] <= Res[3215:3208];
message[275 ] <= Res[3207:3200];
message[276 ] <= Res[3199:3192];
message[277 ] <= Res[3191:3184];
message[278 ] <= Res[3183:3176];
message[279 ] <= Res[3175:3168];
message[280 ] <= Res[3167:3160];
message[281 ] <= Res[3159:3152];
message[282 ] <= Res[3151:3144];
message[283 ] <= Res[3143:3136];
message[284 ] <= Res[3135:3128];
message[285 ] <= Res[3127:3120];
message[286 ] <= Res[3119:3112];
message[287 ] <= Res[3111:3104];
message[288 ] <= Res[3103:3096];
message[289 ] <= Res[3095:3088];
message[290 ] <= Res[3087:3080];
message[291 ] <= Res[3079:3072];
message[292 ] <= Res[3071:3064];
message[293 ] <= Res[3063:3056];
message[294 ] <= Res[3055:3048];
message[295 ] <= Res[3047:3040];
message[296 ] <= Res[3039:3032];
message[297 ] <= Res[3031:3024];
message[298 ] <= Res[3023:3016];
message[299 ] <= Res[3015:3008];
message[300 ] <= Res[3007:3000];
message[301 ] <= Res[2999:2992];
message[302 ] <= Res[2991:2984];
message[303 ] <= Res[2983:2976];
message[304 ] <= Res[2975:2968];
message[305 ] <= Res[2967:2960];
message[306 ] <= Res[2959:2952];
message[307 ] <= Res[2951:2944];
message[308 ] <= Res[2943:2936];
message[309 ] <= Res[2935:2928];
message[310 ] <= Res[2927:2920];
message[311 ] <= Res[2919:2912];
message[312 ] <= Res[2911:2904];
message[313 ] <= Res[2903:2896];
message[314 ] <= Res[2895:2888];
message[315 ] <= Res[2887:2880];
message[316 ] <= Res[2879:2872];
message[317 ] <= Res[2871:2864];
message[318 ] <= Res[2863:2856];
message[319 ] <= Res[2855:2848];
message[320 ] <= Res[2847:2840];
message[321 ] <= Res[2839:2832];
message[322 ] <= Res[2831:2824];
message[323 ] <= Res[2823:2816];
message[324 ] <= Res[2815:2808];
message[325 ] <= Res[2807:2800];
message[326 ] <= Res[2799:2792];
message[327 ] <= Res[2791:2784];
message[328 ] <= Res[2783:2776];
message[329 ] <= Res[2775:2768];
message[330 ] <= Res[2767:2760];
message[331 ] <= Res[2759:2752];
message[332 ] <= Res[2751:2744];
message[333 ] <= Res[2743:2736];
message[334 ] <= Res[2735:2728];
message[335 ] <= Res[2727:2720];
message[336 ] <= Res[2719:2712];
message[337 ] <= Res[2711:2704];
message[338 ] <= Res[2703:2696];
message[339 ] <= Res[2695:2688];
message[340 ] <= Res[2687:2680];
message[341 ] <= Res[2679:2672];
message[342 ] <= Res[2671:2664];
message[343 ] <= Res[2663:2656];
message[344 ] <= Res[2655:2648];
message[345 ] <= Res[2647:2640];
message[346 ] <= Res[2639:2632];
message[347 ] <= Res[2631:2624];
message[348 ] <= Res[2623:2616];
message[349 ] <= Res[2615:2608];
message[350 ] <= Res[2607:2600];
message[351 ] <= Res[2599:2592];
message[352 ] <= Res[2591:2584];
message[353 ] <= Res[2583:2576];
message[354 ] <= Res[2575:2568];
message[355 ] <= Res[2567:2560];
message[356 ] <= Res[2559:2552];
message[357 ] <= Res[2551:2544];
message[358 ] <= Res[2543:2536];
message[359 ] <= Res[2535:2528];
message[360 ] <= Res[2527:2520];
message[361 ] <= Res[2519:2512];
message[362 ] <= Res[2511:2504];
message[363 ] <= Res[2503:2496];
message[364 ] <= Res[2495:2488];
message[365 ] <= Res[2487:2480];
message[366 ] <= Res[2479:2472];
message[367 ] <= Res[2471:2464];
message[368 ] <= Res[2463:2456];
message[369 ] <= Res[2455:2448];
message[370 ] <= Res[2447:2440];
message[371 ] <= Res[2439:2432];
message[372 ] <= Res[2431:2424];
message[373 ] <= Res[2423:2416];
message[374 ] <= Res[2415:2408];
message[375 ] <= Res[2407:2400];
message[376 ] <= Res[2399:2392];
message[377 ] <= Res[2391:2384];
message[378 ] <= Res[2383:2376];
message[379 ] <= Res[2375:2368];
message[380 ] <= Res[2367:2360];
message[381 ] <= Res[2359:2352];
message[382 ] <= Res[2351:2344];
message[383 ] <= Res[2343:2336];
message[384 ] <= Res[2335:2328];
message[385 ] <= Res[2327:2320];
message[386 ] <= Res[2319:2312];
message[387 ] <= Res[2311:2304];
message[388 ] <= Res[2303:2296];
message[389 ] <= Res[2295:2288];
message[390 ] <= Res[2287:2280];
message[391 ] <= Res[2279:2272];
message[392 ] <= Res[2271:2264];
message[393 ] <= Res[2263:2256];
message[394 ] <= Res[2255:2248];
message[395 ] <= Res[2247:2240];
message[396 ] <= Res[2239:2232];
message[397 ] <= Res[2231:2224];
message[398 ] <= Res[2223:2216];
message[399 ] <= Res[2215:2208];
message[400 ] <= Res[2207:2200];
message[401 ] <= Res[2199:2192];
message[402 ] <= Res[2191:2184];
message[403 ] <= Res[2183:2176];
message[404 ] <= Res[2175:2168];
message[405 ] <= Res[2167:2160];
message[406 ] <= Res[2159:2152];
message[407 ] <= Res[2151:2144];
message[408 ] <= Res[2143:2136];
message[409 ] <= Res[2135:2128];
message[410 ] <= Res[2127:2120];
message[411 ] <= Res[2119:2112];
message[412 ] <= Res[2111:2104];
message[413 ] <= Res[2103:2096];
message[414 ] <= Res[2095:2088];
message[415 ] <= Res[2087:2080];
message[416 ] <= Res[2079:2072];
message[417 ] <= Res[2071:2064];
message[418 ] <= Res[2063:2056];
message[419 ] <= Res[2055:2048];
message[420 ] <= Res[2047:2040];
message[421 ] <= Res[2039:2032];
message[422 ] <= Res[2031:2024];
message[423 ] <= Res[2023:2016];
message[424 ] <= Res[2015:2008];
message[425 ] <= Res[2007:2000];
message[426 ] <= Res[1999:1992];
message[427 ] <= Res[1991:1984];
message[428 ] <= Res[1983:1976];
message[429 ] <= Res[1975:1968];
message[430 ] <= Res[1967:1960];
message[431 ] <= Res[1959:1952];
message[432 ] <= Res[1951:1944];
message[433 ] <= Res[1943:1936];
message[434 ] <= Res[1935:1928];
message[435 ] <= Res[1927:1920];
message[436 ] <= Res[1919:1912];
message[437 ] <= Res[1911:1904];
message[438 ] <= Res[1903:1896];
message[439 ] <= Res[1895:1888];
message[440 ] <= Res[1887:1880];
message[441 ] <= Res[1879:1872];
message[442 ] <= Res[1871:1864];
message[443 ] <= Res[1863:1856];
message[444 ] <= Res[1855:1848];
message[445 ] <= Res[1847:1840];
message[446 ] <= Res[1839:1832];
message[447 ] <= Res[1831:1824];
message[448 ] <= Res[1823:1816];
message[449 ] <= Res[1815:1808];
message[450 ] <= Res[1807:1800];
message[451 ] <= Res[1799:1792];
message[452 ] <= Res[1791:1784];
message[453 ] <= Res[1783:1776];
message[454 ] <= Res[1775:1768];
message[455 ] <= Res[1767:1760];
message[456 ] <= Res[1759:1752];
message[457 ] <= Res[1751:1744];
message[458 ] <= Res[1743:1736];
message[459 ] <= Res[1735:1728];
message[460 ] <= Res[1727:1720];
message[461 ] <= Res[1719:1712];
message[462 ] <= Res[1711:1704];
message[463 ] <= Res[1703:1696];
message[464 ] <= Res[1695:1688];
message[465 ] <= Res[1687:1680];
message[466 ] <= Res[1679:1672];
message[467 ] <= Res[1671:1664];
message[468 ] <= Res[1663:1656];
message[469 ] <= Res[1655:1648];
message[470 ] <= Res[1647:1640];
message[471 ] <= Res[1639:1632];
message[472 ] <= Res[1631:1624];
message[473 ] <= Res[1623:1616];
message[474 ] <= Res[1615:1608];
message[475 ] <= Res[1607:1600];
message[476 ] <= Res[1599:1592];
message[477 ] <= Res[1591:1584];
message[478 ] <= Res[1583:1576];
message[479 ] <= Res[1575:1568];
message[480 ] <= Res[1567:1560];
message[481 ] <= Res[1559:1552];
message[482 ] <= Res[1551:1544];
message[483 ] <= Res[1543:1536];
message[484 ] <= Res[1535:1528];
message[485 ] <= Res[1527:1520];
message[486 ] <= Res[1519:1512];
message[487 ] <= Res[1511:1504];
message[488 ] <= Res[1503:1496];
message[489 ] <= Res[1495:1488];
message[490 ] <= Res[1487:1480];
message[491 ] <= Res[1479:1472];
message[492 ] <= Res[1471:1464];
message[493 ] <= Res[1463:1456];
message[494 ] <= Res[1455:1448];
message[495 ] <= Res[1447:1440];
message[496 ] <= Res[1439:1432];
message[497 ] <= Res[1431:1424];
message[498 ] <= Res[1423:1416];
message[499 ] <= Res[1415:1408];
message[500 ] <= Res[1407:1400];
message[501 ] <= Res[1399:1392];
message[502 ] <= Res[1391:1384];
message[503 ] <= Res[1383:1376];
message[504 ] <= Res[1375:1368];
message[505 ] <= Res[1367:1360];
message[506 ] <= Res[1359:1352];
message[507 ] <= Res[1351:1344];
message[508 ] <= Res[1343:1336];
message[509 ] <= Res[1335:1328];
message[510 ] <= Res[1327:1320];
message[511 ] <= Res[1319:1312];
message[512 ] <= Res[1311:1304];
message[513 ] <= Res[1303:1296];
message[514 ] <= Res[1295:1288];
message[515 ] <= Res[1287:1280];
message[516 ] <= Res[1279:1272];
message[517 ] <= Res[1271:1264];
message[518 ] <= Res[1263:1256];
message[519 ] <= Res[1255:1248];
message[520 ] <= Res[1247:1240];
message[521 ] <= Res[1239:1232];
message[522 ] <= Res[1231:1224];
message[523 ] <= Res[1223:1216];
message[524 ] <= Res[1215:1208];
message[525 ] <= Res[1207:1200];
message[526 ] <= Res[1199:1192];
message[527 ] <= Res[1191:1184];
message[528 ] <= Res[1183:1176];
message[529 ] <= Res[1175:1168];
message[530 ] <= Res[1167:1160];
message[531 ] <= Res[1159:1152];
message[532 ] <= Res[1151:1144];
message[533 ] <= Res[1143:1136];
message[534 ] <= Res[1135:1128];
message[535 ] <= Res[1127:1120];
message[536 ] <= Res[1119:1112];
message[537 ] <= Res[1111:1104];
message[538 ] <= Res[1103:1096];
message[539 ] <= Res[1095:1088];
message[540 ] <= Res[1087:1080];
message[541 ] <= Res[1079:1072];
message[542 ] <= Res[1071:1064];
message[543 ] <= Res[1063:1056];
message[544 ] <= Res[1055:1048];
message[545 ] <= Res[1047:1040];
message[546 ] <= Res[1039:1032];
message[547 ] <= Res[1031:1024];
message[548 ] <= Res[1023:1016];
message[549 ] <= Res[1015:1008];
message[550 ] <= Res[1007:1000];
message[551 ] <= Res[999:992];
message[552 ] <= Res[991:984];
message[553 ] <= Res[983:976];
message[554 ] <= Res[975:968];
message[555 ] <= Res[967:960];
message[556 ] <= Res[959:952];
message[557 ] <= Res[951:944];
message[558 ] <= Res[943:936];
message[559 ] <= Res[935:928];
message[560 ] <= Res[927:920];
message[561 ] <= Res[919:912];
message[562 ] <= Res[911:904];
message[563 ] <= Res[903:896];
message[564 ] <= Res[895:888];
message[565 ] <= Res[887:880];
message[566 ] <= Res[879:872];
message[567 ] <= Res[871:864];
message[568 ] <= Res[863:856];
message[569 ] <= Res[855:848];
message[570 ] <= Res[847:840];
message[571 ] <= Res[839:832];
message[572 ] <= Res[831:824];
message[573 ] <= Res[823:816];
message[574 ] <= Res[815:808];
message[575 ] <= Res[807:800];
message[576 ] <= Res[799:792];
message[577 ] <= Res[791:784];
message[578 ] <= Res[783:776];
message[579 ] <= Res[775:768];
message[580 ] <= Res[767:760];
message[581 ] <= Res[759:752];
message[582 ] <= Res[751:744];
message[583 ] <= Res[743:736];
message[584 ] <= Res[735:728];
message[585 ] <= Res[727:720];
message[586 ] <= Res[719:712];
message[587 ] <= Res[711:704];
message[588 ] <= Res[703:696];
message[589 ] <= Res[695:688];
message[590 ] <= Res[687:680];
message[591 ] <= Res[679:672];
message[592 ] <= Res[671:664];
message[593 ] <= Res[663:656];
message[594 ] <= Res[655:648];
message[595 ] <= Res[647:640];
message[596 ] <= Res[639:632];
message[597 ] <= Res[631:624];
message[598 ] <= Res[623:616];
message[599 ] <= Res[615:608];
message[600 ] <= Res[607:600];
message[601 ] <= Res[599:592];
message[602 ] <= Res[591:584];
message[603 ] <= Res[583:576];
message[604 ] <= Res[575:568];
message[605 ] <= Res[567:560];
message[606 ] <= Res[559:552];
message[607 ] <= Res[551:544];
message[608 ] <= Res[543:536];
message[609 ] <= Res[535:528];
message[610 ] <= Res[527:520];
message[611 ] <= Res[519:512];
message[612 ] <= Res[511:504];
message[613 ] <= Res[503:496];
message[614 ] <= Res[495:488];
message[615 ] <= Res[487:480];
message[616 ] <= Res[479:472];
message[617 ] <= Res[471:464];
message[618 ] <= Res[463:456];
message[619 ] <= Res[455:448];
message[620 ] <= Res[447:440];
message[621 ] <= Res[439:432];
message[622 ] <= Res[431:424];
message[623 ] <= Res[423:416];
message[624 ] <= Res[415:408];
message[625 ] <= Res[407:400];
message[626 ] <= Res[399:392];
message[627 ] <= Res[391:384];
message[628 ] <= Res[383:376];
message[629 ] <= Res[375:368];
message[630 ] <= Res[367:360];
message[631 ] <= Res[359:352];
message[632 ] <= Res[351:344];
message[633 ] <= Res[343:336];
message[634 ] <= Res[335:328];
message[635 ] <= Res[327:320];
message[636 ] <= Res[319:312];
message[637 ] <= Res[311:304];
message[638 ] <= Res[303:296];
message[639 ] <= Res[295:288];
message[640 ] <= Res[287:280];
message[641 ] <= Res[279:272];
message[642 ] <= Res[271:264];
message[643 ] <= Res[263:256];
message[644 ] <= Res[255:248];
message[645 ] <= Res[247:240];
message[646 ] <= Res[239:232];
message[647 ] <= Res[231:224];
message[648 ] <= Res[223:216];
message[649 ] <= Res[215:208];
message[650 ] <= Res[207:200];
message[651 ] <= Res[199:192];
message[652 ] <= Res[191:184];
message[653 ] <= Res[183:176];
message[654 ] <= Res[175:168];
message[655 ] <= Res[167:160];
message[656 ] <= Res[159:152];
message[657 ] <= Res[151:144];
message[658 ] <= Res[143:136];
message[659 ] <= Res[135:128];
message[660 ] <= Res[127:120];
message[661 ] <= Res[119:112];
message[662 ] <= Res[111:104];
message[663 ] <= Res[103:96];
message[664 ] <= Res[95:88];
message[665 ] <= Res[87:80];
message[666 ] <= Res[79:72];
message[667 ] <= Res[71:64];
message[668 ] <= Res[63:56];
message[669 ] <= Res[55:48];
message[670 ] <= Res[47:40];
message[671 ] <= Res[39:32];
message[672 ] <= Res[31:24];
message[673 ] <= Res[23:16];
message[674 ] <= Res[15:8];
message[675 ] <= Res[7:0];



end




reg	[27:0]	counter;
	initial	counter = 28'hffffff0;
	always @(posedge i_clk)
		counter <= counter + 1'b1;

	wire		tx_break, tx_busy;
	reg		tx_stb;
	reg	[10:0]	tx_index;
	reg	[7:0]	tx_data;

	assign	tx_break = 1'b0;

	initial	tx_index = 10'h0;
	always @(posedge i_clk)
		if ((tx_stb)&&(!tx_busy))
			tx_index <= tx_index + 1'b1;
	always @(posedge i_clk)
		tx_data <= message[tx_index];

	initial	tx_stb = 1'b0;
	always @(posedge i_clk)
		if (&counter)
			tx_stb <= 1'b1;
		else if ((tx_stb)&&(!tx_busy)&&(tx_index==4'hf))
			tx_stb <= 1'b0;

	// 868 is 115200 Baud, based upon a 100MHz clock
	txuartlite #(.TIMING_BITS(10), .CLOCKS_PER_BAUD(868))
		transmitter(i_clk, tx_stb, tx_data, o_uart_tx, tx_busy);

endmodule
////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	txuartlite.v
//
// Project:	wbuart32, a full featured UART with simulator
//
// Purpose:	Transmit outputs over a single UART line.  This particular UART
//		implementation has been extremely simplified: it does not handle
//	generating break conditions, nor does it handle anything other than the
//	8N1 (8 data bits, no parity, 1 stop bit) UART sub-protocol.
//
//	To interface with this module, connect it to your system clock, and
//	pass it the byte of data you wish to transmit.  Strobe the i_wr line
//	high for one cycle, and your data will be off.  Wait until the 'o_busy'
//	line is low before strobing the i_wr line again--this implementation
//	has NO BUFFER, so strobing i_wr while the core is busy will just
//	get ignored.  The output will be placed on the o_txuart output line.
//
//	(I often set both data and strobe on the same clock, and then just leave
//	them set until the busy line is low.  Then I move on to the next piece
//	of data.)
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2015-2017, Gisselquist Technology, LLC
//
// This program is free software (firmware): you can redistribute it and/or
// modify it under the terms of  the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
// target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype	none
//
`define	TXUL_BIT_ZERO	4'h0
`define	TXUL_BIT_ONE	4'h1
`define	TXUL_BIT_TWO	4'h2
`define	TXUL_BIT_THREE	4'h3
`define	TXUL_BIT_FOUR	4'h4
`define	TXUL_BIT_FIVE	4'h5
`define	TXUL_BIT_SIX	4'h6
`define	TXUL_BIT_SEVEN	4'h7
`define	TXUL_STOP	4'h8
`define	TXUL_IDLE	4'hf
//
//
module txuartlite(i_clk, i_wr, i_data, o_uart_tx, o_busy);
	parameter	[4:0]	TIMING_BITS = 5'd24;
	localparam		TB = TIMING_BITS;
	parameter	[(TB-1):0]	CLOCKS_PER_BAUD = 8; // 24'd868;
	parameter	[0:0]	F_OPT_CLK2FFLOGIC = 1'b0;
	input	wire		i_clk;
	input	wire		i_wr;
	input	wire	[7:0]	i_data;
	// And the UART input line itself
	output	reg		o_uart_tx;
	// A line to tell others when we are ready to accept data.  If
	// (i_wr)&&(!o_busy) is ever true, then the core has accepted a byte
	// for transmission.
	output	wire		o_busy;

	reg	[(TB-1):0]	baud_counter;
	reg	[3:0]	state;
	reg	[7:0]	lcl_data;
	reg		r_busy, zero_baud_counter;

	initial	r_busy = 1'b1;
	initial	state  = `TXUL_IDLE;
	always @(posedge i_clk)
	begin
		if (!zero_baud_counter)
			// r_busy needs to be set coming into here
			r_busy <= 1'b1;
		else if (state > `TXUL_STOP)	// STATE_IDLE
		begin
			state <= `TXUL_IDLE;
			r_busy <= 1'b0;
			if ((i_wr)&&(!r_busy))
			begin	// Immediately start us off with a start bit
				r_busy <= 1'b1;
				state <= `TXUL_BIT_ZERO;
			end
		end else begin
			// One clock tick in each of these states ...
			r_busy <= 1'b1;
			if (state <=`TXUL_STOP) // start bit, 8-d bits, stop-b
				state <= state + 1'b1;
			else
				state <= `TXUL_IDLE;
		end
	end

	// o_busy
	//
	// This is a wire, designed to be true is we are ever busy above.
	// originally, this was going to be true if we were ever not in the
	// idle state.  The logic has since become more complex, hence we have
	// a register dedicated to this and just copy out that registers value.
	assign	o_busy = (r_busy);


	// lcl_data
	//
	// This is our working copy of the i_data register which we use
	// when transmitting.  It is only of interest during transmit, and is
	// allowed to be whatever at any other time.  Hence, if r_busy isn't
	// true, we can always set it.  On the one clock where r_busy isn't
	// true and i_wr is, we set it and r_busy is true thereafter.
	// Then, on any zero_baud_counter (i.e. change between baud intervals)
	// we simple logically shift the register right to grab the next bit.
	initial	lcl_data = 8'hff;
	always @(posedge i_clk)
		if ((i_wr)&&(!r_busy))
			lcl_data <= i_data;
		else if (zero_baud_counter)
			lcl_data <= { 1'b1, lcl_data[7:1] };

	// o_uart_tx
	//
	// This is the final result/output desired of this core.  It's all
	// centered about o_uart_tx.  This is what finally needs to follow
	// the UART protocol.
	//
	initial	o_uart_tx = 1'b1;
	always @(posedge i_clk)
		if ((i_wr)&&(!r_busy))
			o_uart_tx <= 1'b0;	// Set the start bit on writes
		else if (zero_baud_counter)	// Set the data bit.
			o_uart_tx <= lcl_data[0];


	// All of the above logic is driven by the baud counter.  Bits must last
	// CLOCKS_PER_BAUD in length, and this baud counter is what we use to
	// make certain of that.
	//
	// The basic logic is this: at the beginning of a bit interval, start
	// the baud counter and set it to count CLOCKS_PER_BAUD.  When it gets
	// to zero, restart it.
	//
	// However, comparing a 28'bit number to zero can be rather complex--
	// especially if we wish to do anything else on that same clock.  For
	// that reason, we create "zero_baud_counter".  zero_baud_counter is
	// nothing more than a flag that is true anytime baud_counter is zero.
	// It's true when the logic (above) needs to step to the next bit.
	// Simple enough?
	//
	// I wish we could stop there, but there are some other (ugly)
	// conditions to deal with that offer exceptions to this basic logic.
	//
	// 1. When the user has commanded a BREAK across the line, we need to
	// wait several baud intervals following the break before we start
	// transmitting, to give any receiver a chance to recognize that we are
	// out of the break condition, and to know that the next bit will be
	// a stop bit.
	//
	// 2. A reset is similar to a break condition--on both we wait several
	// baud intervals before allowing a start bit.
	//
	// 3. In the idle state, we stop our counter--so that upon a request
	// to transmit when idle we can start transmitting immediately, rather
	// than waiting for the end of the next (fictitious and arbitrary) baud
	// interval.
	//
	// When (i_wr)&&(!r_busy)&&(state == `TXUL_IDLE) then we're not only in
	// the idle state, but we also just accepted a command to start writing
	// the next word.  At this point, the baud counter needs to be reset
	// to the number of CLOCKS_PER_BAUD, and zero_baud_counter set to zero.
	//
	// The logic is a bit twisted here, in that it will only check for the
	// above condition when zero_baud_counter is false--so as to make
	// certain the STOP bit is complete.
	initial	zero_baud_counter = 1'b1;
	initial	baud_counter = 0;
	always @(posedge i_clk)
	begin
		zero_baud_counter <= (baud_counter == 24'h01);
		if (state == `TXUL_IDLE)
		begin
			baud_counter <= 24'h0;
			zero_baud_counter <= 1'b1;
			if ((i_wr)&&(!r_busy))
			begin
				baud_counter <= CLOCKS_PER_BAUD - 24'h01;
				zero_baud_counter <= 1'b0;
			end
		end else if ((zero_baud_counter)&&(state == 4'h9))
		begin
			baud_counter <= 0;
			zero_baud_counter <= 1'b1;
		end else if (!zero_baud_counter)
			baud_counter <= baud_counter - 24'h01;
		else
			baud_counter <= CLOCKS_PER_BAUD - 24'h01;
	end

//
//
// FORMAL METHODS
//
//
//
`ifdef	FORMAL

`ifdef	TXUARTLITE
`define	ASSUME	assume
`else
`define	ASSUME	assert
`endif

	// Setup

	reg	f_past_valid, f_last_clk;

	generate if (F_OPT_CLK2FFLOGIC)
	begin

		always @($global_clock)
		begin
			restrict(i_clk == !f_last_clk);
			f_last_clk <= i_clk;
			if (!$rose(i_clk))
			begin
				`ASSUME($stable(i_wr));
				`ASSUME($stable(i_data));
			end
		end

	end endgenerate

	initial	f_past_valid = 1'b0;
	always @(posedge i_clk)
		f_past_valid <= 1'b1;

	initial	`ASSUME(!i_wr);
	always @(posedge i_clk)
		if ((f_past_valid)&&($past(i_wr))&&($past(o_busy)))
		begin
			`ASSUME(i_wr   == $past(i_wr));
			`ASSUME(i_data == $past(i_data));
		end

	// Check the baud counter
	always @(posedge i_clk)
		assert(zero_baud_counter == (baud_counter == 0));

	always @(posedge i_clk)
		if ((f_past_valid)&&($past(baud_counter != 0))&&($past(state != `TXUL_IDLE)))
			assert(baud_counter == $past(baud_counter - 1'b1));

	always @(posedge i_clk)
		if ((f_past_valid)&&(!$past(zero_baud_counter))&&($past(state != `TXUL_IDLE)))
			assert($stable(o_uart_tx));

	reg	[(TB-1):0]	f_baud_count;
	initial	f_baud_count = 1'b0;
	always @(posedge i_clk)
		if (zero_baud_counter)
			f_baud_count <= 0;
		else
			f_baud_count <= f_baud_count + 1'b1;

	always @(posedge i_clk)
		assert(f_baud_count < CLOCKS_PER_BAUD);

	always @(posedge i_clk)
		if (baud_counter != 0)
			assert(o_busy);

	reg	[9:0]	f_txbits;
	initial	f_txbits = 0;
	always @(posedge i_clk)
		if (zero_baud_counter)
			f_txbits <= { o_uart_tx, f_txbits[9:1] };

	always @(posedge i_clk)
	if ((f_past_valid)&&(!$past(zero_baud_counter))
			&&(!$past(state==`TXUL_IDLE)))
		assert(state == $past(state));

	reg	[3:0]	f_bitcount;
	initial	f_bitcount = 0;
	always @(posedge i_clk)
		if ((!f_past_valid)||(!$past(f_past_valid)))
			f_bitcount <= 0;
		else if ((state == `TXUL_IDLE)&&(zero_baud_counter))
			f_bitcount <= 0;
		else if (zero_baud_counter)
			f_bitcount <= f_bitcount + 1'b1;

	always @(posedge i_clk)
		assert(f_bitcount <= 4'ha);

	reg	[7:0]	f_request_tx_data;
	always @(posedge i_clk)
		if ((i_wr)&&(!o_busy))
			f_request_tx_data <= i_data;

	wire	[3:0]	subcount;
	assign	subcount = 10-f_bitcount;
	always @(posedge i_clk)
		if (f_bitcount > 0)
			assert(!f_txbits[subcount]);

	always @(posedge i_clk)
		if (f_bitcount == 4'ha)
		begin
			assert(f_txbits[8:1] == f_request_tx_data);
			assert( f_txbits[9]);
		end

	always @(posedge i_clk)
		assert((state <= `TXUL_STOP + 1'b1)||(state == `TXUL_IDLE));

	always @(posedge i_clk)
	if ((f_past_valid)&&($past(f_past_valid))&&($past(o_busy)))
		cover(!o_busy);

`endif	// FORMAL
`ifdef	VERIFIC_SVA
	reg	[7:0]	fsv_data;

	//
	// Grab a copy of the data any time we are sent a new byte to transmit
	// We'll use this in a moment to compare the item transmitted against
	// what is supposed to be transmitted
	//
	always @(posedge i_clk)
		if ((i_wr)&&(!o_busy))
			fsv_data <= i_data;

	//
	// One baud interval
	//
	// 1. The UART output is constant at DAT
	// 2. The internal state remains constant at ST
	// 3. CKS = the number of clocks per bit.
	//
	// Everything stays constant during the CKS clocks with the exception
	// of (zero_baud_counter), which is *only* raised on the last clock
	// interval
	sequence	BAUD_INTERVAL(CKS, DAT, SR, ST);
		((o_uart_tx == DAT)&&(state == ST)
			&&(lcl_data == SR)
			&&(!zero_baud_counter))[*(CKS-1)]
		##1 (o_uart_tx == DAT)&&(state == ST)
			&&(lcl_data == SR)
			&&(zero_baud_counter);
	endsequence

	//
	// One byte transmitted
	//
	// DATA = the byte that is sent
	// CKS  = the number of clocks per bit
	//
	sequence	SEND(CKS, DATA);
		BAUD_INTERVAL(CKS, 1'b0, DATA, 4'h0)
		##1 BAUD_INTERVAL(CKS, DATA[0], {{(1){1'b1}},DATA[7:1]}, 4'h1)
		##1 BAUD_INTERVAL(CKS, DATA[1], {{(2){1'b1}},DATA[7:2]}, 4'h2)
		##1 BAUD_INTERVAL(CKS, DATA[2], {{(3){1'b1}},DATA[7:3]}, 4'h3)
		##1 BAUD_INTERVAL(CKS, DATA[3], {{(4){1'b1}},DATA[7:4]}, 4'h4)
		##1 BAUD_INTERVAL(CKS, DATA[4], {{(5){1'b1}},DATA[7:5]}, 4'h5)
		##1 BAUD_INTERVAL(CKS, DATA[5], {{(6){1'b1}},DATA[7:6]}, 4'h6)
		##1 BAUD_INTERVAL(CKS, DATA[6], {{(7){1'b1}},DATA[7:7]}, 4'h7)
		##1 BAUD_INTERVAL(CKS, DATA[7], 8'hff, 4'h8)
		##1 BAUD_INTERVAL(CKS, 1'b1, 8'hff, 4'h9);
	endsequence

	//
	// Transmit one byte
	//
	// Once the byte is transmitted, make certain we return to
	// idle
	//
	assert property (
		@(posedge i_clk)
		(i_wr)&&(!o_busy)
		|=> ((o_busy) throughout SEND(CLOCKS_PER_BAUD,fsv_data))
		##1 (!o_busy)&&(o_uart_tx)&&(zero_baud_counter));

	assume property (
		@(posedge i_clk)
		(i_wr)&&(o_busy) |=>
			(i_wr)&&(o_busy)&&($stable(i_data)));

	//
	// Make certain that o_busy is true any time zero_baud_counter is
	// non-zero
	//
	always @(*)
		assert((o_busy)||(zero_baud_counter) );

	// If and only if zero_baud_counter is true, baud_counter must be zero
	// Insist on that relationship here.
	always @(*)
		assert(zero_baud_counter == (baud_counter == 0));

	// To make certain baud_counter stays below CLOCKS_PER_BAUD
	always @(*)
		assert(baud_counter < CLOCKS_PER_BAUD);

	//
	// Insist that we are only ever in a valid state
	always @(*)
		assert((state <= `TXUL_STOP+1'b1)||(state == `TXUL_IDLE));

`endif // Verific SVA
endmodule


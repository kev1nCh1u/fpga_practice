/* Quartus Prime Version 20.1.1 Build 720 11/11/2020 SJ Standard Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Ign)
		Device PartName(5CSEBA6U23) MfrSpec(OpMask(0) FullPath("/home/kevin/src/fpga_practice/src/blink_test/output_files/blink.sof"));
	P ActionCode(Ign)
		Device PartName(5CSEBA6) MfrSpec(OpMask(0) SEC_Device(EPCS64) Child_OpMask(1 0) FullPath("/home/kevin/src/fpga_practice/src/blink_test/output_file.jic"));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;

-- megafunction wizard: %RAM: 2-PORT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: altdpram 

-- ============================================================
-- File Name: RamTCPIPHd.vhd
-- Megafunction Name(s):
-- 			altdpram
--
-- Simulation Library Files(s):
-- 			altera_mf
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 17.1.0 Build 590 10/25/2017 SJ Lite Edition
-- ************************************************************


--Copyright (C) 2017  Intel Corporation. All rights reserved.
--Your use of Intel Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Intel Program License 
--Subscription Agreement, the Intel Quartus Prime License Agreement,
--the Intel FPGA IP License Agreement, or other applicable license
--agreement, including, without limitation, that your use is for
--the sole purpose of programming logic devices manufactured by
--Intel and sold by Intel or its authorized distributors.  Please
--refer to the applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY RamTCPIPHd IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END RamTCPIPHd;


ARCHITECTURE SYN OF ramtcpiphd IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
	q    <= sub_wire0(7 DOWNTO 0);

	altdpram_component : altdpram
	GENERIC MAP (
		indata_aclr => "OFF",
		indata_reg => "INCLOCK",
		intended_device_family => "Cyclone V",
		lpm_type => "altdpram",
		outdata_aclr => "OFF",
		outdata_reg => "UNREGISTERED",
		rdaddress_aclr => "OFF",
		rdaddress_reg => "INCLOCK",
		rdcontrol_aclr => "OFF",
		rdcontrol_reg => "UNREGISTERED",
		read_during_write_mode_mixed_ports => "DONT_CARE",
		use_eab => "OFF",
		width => 8,
		widthad => 6,
		width_byteena => 1,
		wraddress_aclr => "OFF",
		wraddress_reg => "INCLOCK",
		wrcontrol_aclr => "OFF",
		wrcontrol_reg => "INCLOCK"
	)
	PORT MAP (
		data => data,
		inclock => clock,
		outclock => clock,
		rdaddress => rdaddress,
		wraddress => wraddress,
		wren => wren,
		q => sub_wire0
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: ADDRESSSTALL_A NUMERIC "0"
-- Retrieval info: PRIVATE: ADDRESSSTALL_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTEENA_ACLR_A NUMERIC "0"
-- Retrieval info: PRIVATE: BYTEENA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_ENABLE_A NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_ENABLE_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "8"
-- Retrieval info: PRIVATE: BlankMemory NUMERIC "1"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_B NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_B NUMERIC "0"
-- Retrieval info: PRIVATE: CLRdata NUMERIC "0"
-- Retrieval info: PRIVATE: CLRq NUMERIC "0"
-- Retrieval info: PRIVATE: CLRrdaddress NUMERIC "0"
-- Retrieval info: PRIVATE: CLRrren NUMERIC "0"
-- Retrieval info: PRIVATE: CLRwraddress NUMERIC "0"
-- Retrieval info: PRIVATE: CLRwren NUMERIC "0"
-- Retrieval info: PRIVATE: Clock NUMERIC "0"
-- Retrieval info: PRIVATE: Clock_A NUMERIC "0"
-- Retrieval info: PRIVATE: Clock_B NUMERIC "0"
-- Retrieval info: PRIVATE: IMPLEMENT_IN_LES NUMERIC "0"
-- Retrieval info: PRIVATE: INDATA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: INDATA_REG_B NUMERIC "0"
-- Retrieval info: PRIVATE: INIT_FILE_LAYOUT STRING "PORT_B"
-- Retrieval info: PRIVATE: INIT_TO_SIM_X NUMERIC "0"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
-- Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
-- Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
-- Retrieval info: PRIVATE: MAXIMUM_DEPTH NUMERIC "0"
-- Retrieval info: PRIVATE: MEMSIZE NUMERIC "512"
-- Retrieval info: PRIVATE: MEM_IN_BITS NUMERIC "0"
-- Retrieval info: PRIVATE: MIFfilename STRING ""
-- Retrieval info: PRIVATE: OPERATION_MODE NUMERIC "2"
-- Retrieval info: PRIVATE: OUTDATA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: OUTDATA_REG_B NUMERIC "0"
-- Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "5"
-- Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_MIXED_PORTS NUMERIC "2"
-- Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_PORT_A NUMERIC "3"
-- Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_PORT_B NUMERIC "3"
-- Retrieval info: PRIVATE: REGdata NUMERIC "1"
-- Retrieval info: PRIVATE: REGq NUMERIC "1"
-- Retrieval info: PRIVATE: REGrdaddress NUMERIC "1"
-- Retrieval info: PRIVATE: REGrren NUMERIC "1"
-- Retrieval info: PRIVATE: REGwraddress NUMERIC "1"
-- Retrieval info: PRIVATE: REGwren NUMERIC "1"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
-- Retrieval info: PRIVATE: USE_DIFF_CLKEN NUMERIC "0"
-- Retrieval info: PRIVATE: UseDPRAM NUMERIC "1"
-- Retrieval info: PRIVATE: VarWidth NUMERIC "0"
-- Retrieval info: PRIVATE: WIDTH_READ_A NUMERIC "8"
-- Retrieval info: PRIVATE: WIDTH_READ_B NUMERIC "8"
-- Retrieval info: PRIVATE: WIDTH_WRITE_A NUMERIC "8"
-- Retrieval info: PRIVATE: WIDTH_WRITE_B NUMERIC "8"
-- Retrieval info: PRIVATE: WRADDR_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: WRADDR_REG_B NUMERIC "0"
-- Retrieval info: PRIVATE: WRCTRL_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: enable NUMERIC "0"
-- Retrieval info: PRIVATE: rden NUMERIC "0"
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: CONSTANT: INDATA_ACLR STRING "OFF"
-- Retrieval info: CONSTANT: INDATA_REG STRING "INCLOCK"
-- Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "altdpram"
-- Retrieval info: CONSTANT: OUTDATA_ACLR STRING "OFF"
-- Retrieval info: CONSTANT: OUTDATA_REG STRING "UNREGISTERED"
-- Retrieval info: CONSTANT: RDADDRESS_ACLR STRING "OFF"
-- Retrieval info: CONSTANT: RDADDRESS_REG STRING "INCLOCK"
-- Retrieval info: CONSTANT: RDCONTROL_ACLR STRING "OFF"
-- Retrieval info: CONSTANT: RDCONTROL_REG STRING "UNREGISTERED"
-- Retrieval info: CONSTANT: READ_DURING_WRITE_MODE_MIXED_PORTS STRING "DONT_CARE"
-- Retrieval info: CONSTANT: USE_EAB STRING "OFF"
-- Retrieval info: CONSTANT: WIDTH NUMERIC "8"
-- Retrieval info: CONSTANT: WIDTHAD NUMERIC "6"
-- Retrieval info: CONSTANT: WIDTH_BYTEENA NUMERIC "1"
-- Retrieval info: CONSTANT: WRADDRESS_ACLR STRING "OFF"
-- Retrieval info: CONSTANT: WRADDRESS_REG STRING "INCLOCK"
-- Retrieval info: CONSTANT: WRCONTROL_ACLR STRING "OFF"
-- Retrieval info: CONSTANT: WRCONTROL_REG STRING "INCLOCK"
-- Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
-- Retrieval info: USED_PORT: data 0 0 8 0 INPUT NODEFVAL "data[7..0]"
-- Retrieval info: USED_PORT: q 0 0 8 0 OUTPUT NODEFVAL "q[7..0]"
-- Retrieval info: USED_PORT: rdaddress 0 0 6 0 INPUT NODEFVAL "rdaddress[5..0]"
-- Retrieval info: USED_PORT: wraddress 0 0 6 0 INPUT NODEFVAL "wraddress[5..0]"
-- Retrieval info: USED_PORT: wren 0 0 0 0 INPUT GND "wren"
-- Retrieval info: CONNECT: @data 0 0 8 0 data 0 0 8 0
-- Retrieval info: CONNECT: @inclock 0 0 0 0 clock 0 0 0 0
-- Retrieval info: CONNECT: @outclock 0 0 0 0 clock 0 0 0 0
-- Retrieval info: CONNECT: @rdaddress 0 0 6 0 rdaddress 0 0 6 0
-- Retrieval info: CONNECT: @wraddress 0 0 6 0 wraddress 0 0 6 0
-- Retrieval info: CONNECT: @wren 0 0 0 0 wren 0 0 0 0
-- Retrieval info: CONNECT: q 0 0 8 0 @q 0 0 8 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL RamTCPIPHd.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RamTCPIPHd.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RamTCPIPHd.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RamTCPIPHd.bsf FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL RamTCPIPHd_inst.vhd FALSE
-- Retrieval info: LIB_FILE: altera_mf

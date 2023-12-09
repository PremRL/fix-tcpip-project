----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     PkSigTbTOE.vhd
-- Title        Signal declaration for TbTOE
-- 
-- Author       L.Ratchanon
-- Date         2020/11/10
-- Syntax       VHDL
-- Description      
--
----------------------------------------------------------------------------------
-- Note
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.MATH_REAL.all;
USE STD.TEXTIO.ALL;
use work.PkTbTOE.all;

Package PkSigTbTOE Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------

	constant	tClk				: time 	  := 10 ns;
	
----------------------------------------------------------------------------------
-- Signal declaration																
----------------------------------------------------------------------------------
	
	signal	TM						: integer	range 0 to 65535;
	signal	TT						: integer	range 0 to 65535;
	
	signal	RstB					: std_logic;
	signal	Clk						: std_logic;
	signal  MacRstB					: std_logic;
	signal  RxMacClk				: std_logic;
	signal  rDelay					: std_logic;
	
	-- Input 
	signal  User2TOEConnectReq		: std_logic;
	signal  User2TOETerminateReq    : std_logic;
	signal  User2TOERxReq        	: std_logic;
	signal  UNG2TOESenderMACAddr 	: std_logic_vector(47 downto 0 );
	signal  UNG2TOETargetMACAddr	: std_logic_vector(47 downto 0 );
	signal  UNG2TOESenderIpAddr	    : std_logic_vector(31 downto 0 );
	signal  UNG2TOETargetIpAddr	    : std_logic_vector(31 downto 0 );
	signal  UNG2TOESrcPort     	    : std_logic_vector(15 downto 0 );
	signal  UNG2TOEDesPort     	    : std_logic_vector(15 downto 0 );
	signal  UNG2TOEAddrVal		 	: std_logic;
	signal  EMAC2TOETxReady      	: std_logic;
	
	signal  User2TOEConnectReq_t	: std_logic;
	signal  User2TOETerminateReq_t  : std_logic;
	signal  User2TOETxDataVal_t		: std_logic;
	signal  User2TOETxDataSop_t	    : std_logic;
	signal  User2TOETxDataEop_t	    : std_logic;
	signal  User2TOETxDataIn_t	    : std_logic_vector( 7 downto 0 );
	signal  User2TOETxDataLen_t	    : std_logic_vector(15 downto 0 );
	signal  User2TOERxReq_t        	: std_logic;
	signal  UNG2TOESenderMACAddr_t 	: std_logic_vector(47 downto 0 );
	signal  UNG2TOETargetMACAddr_t	: std_logic_vector(47 downto 0 );
	signal  UNG2TOESenderIpAddr_t   : std_logic_vector(31 downto 0 );
	signal  UNG2TOETargetIpAddr_t	: std_logic_vector(31 downto 0 );
	signal  UNG2TOESrcPort_t     	: std_logic_vector(15 downto 0 );
	signal  UNG2TOEDesPort_t     	: std_logic_vector(15 downto 0 );
	signal  UNG2TOEAddrVal_t		: std_logic;
	signal  EMAC2TOETxReady_t      	: std_logic;
	signal  EMAC2TOERxSOP_t	    	: std_logic;
	signal  EMAC2TOERxValid_t	    : std_logic;
	signal  EMAC2TOERxEOP_t	    	: std_logic;
	signal  EMAC2TOERxData_t	    : std_logic_vector( 7 downto 0 );
	signal  EMAC2TOERxError_t	    : std_logic_vector( 1 downto 0 );

	-- Output 
	signal	TOE2UserStatus			: std_logic_vector( 3 downto 0 );	
	signal  TOE2UserPSHFlagset	    : std_logic;
	signal  TOE2UserFINFlagset 	    : std_logic;
	signal  TOE2UserRSTFlagset	    : std_logic;
	signal  TOE2UserTxMemAlFull  	: std_logic;
	signal  TOE2UserRxSOP		 	: std_logic;
	signal  TOE2UserRxEOP		    : std_logic;
	signal  TOE2UserRxValid		    : std_logic;
	signal  TOE2UserRxData		    : std_logic_vector( 7 downto 0 );
	signal  TOE2EMACTxReq		 	: std_logic;
	signal  TOE2EMACTxDataOut	 	: std_logic_vector( 7 downto 0 );
	signal  TOE2EMACTxDataOutVal    : std_logic;
	signal  TOE2EMACTxDataOutSop    : std_logic;
	signal  TOE2EMACTxDataOutEop    : std_logic;
	
	signal	TOE2UserStatus_t		: std_logic_vector( 3 downto 0 );	
	signal  TOE2UserPSHFlagset_t    : std_logic;
	signal  TOE2UserFINFlagset_t 	: std_logic;
	signal  TOE2UserRSTFlagset_t    : std_logic;
	signal  TOE2UserTxMemAlFull_t   : std_logic;
	signal  TOE2UserRxSOP_t		    : std_logic;
	signal  TOE2UserRxEOP_t		    : std_logic;
	signal  TOE2UserRxValid_t		: std_logic;
	signal  TOE2UserRxData_t	    : std_logic_vector( 7 downto 0 );
	signal  TOE2EMACTxReq_t		    : std_logic;
	signal  TOE2EMACTxDataOut_t	    : std_logic_vector( 7 downto 0 );
	signal  TOE2EMACTxDataOutVal_t  : std_logic;
	signal  TOE2EMACTxDataOutSop_t  : std_logic;
	signal  TOE2EMACTxDataOutEop_t  : std_logic;

	-- Control
	signal  TOE2EMACTxDataOutFF		: std_logic_vector(47 downto 0 );
	
	-- Record 
	signal  TCPDataRecOut			: TCPDataRecord; 
	signal  ExpDataRecIn			: ExpDataRecord;
	signal  DataGenRecOut			: DataGenRecord;
	signal  RxDataGenRecOut			: RxDataGenRecord;
	signal  PktTCPIPRecIn			: PktTCPIPRecord;
	
End Package PkSigTbTOE;		
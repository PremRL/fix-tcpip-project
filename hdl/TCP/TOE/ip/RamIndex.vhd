-- RamIndex
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE STD.TEXTIO.ALL;

Entity RamIndex Is
	Port 
	(
		Clk			: in	std_logic;
		RstB		: in	std_logic;

		WrAddr		: in 	std_logic_vector( 3 downto 0 );
		WrData		: in	std_logic_vector(16 downto 0 );
		WrEn		: in 	std_logic := '0';

		Init		: in	std_logic; 
		AckVal		: in	std_logic; 
		AckNum		: in	std_logic_vector(31 downto 0 );
		RefAddr 	: out	std_logic_vector( 3 downto 0 );
		
		RdAddr		: in 	std_logic_vector( 3 downto 0 );
		RdData		: out	std_logic_vector(16 downto 0 )
	);
End Entity RamIndex;

Architecture rtl Of RamIndex Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	
	constant RAM_DEPTH : integer := 16;
	constant RAM_WIDTH : integer := 17;

	type array16ofu16 is array (0 to RAM_DEPTH - 1) of std_logic_vector( RAM_WIDTH-1 downto 0);
	

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	signal RAM 					: array16ofu16;
	
	signal rRefData				: std_logic_vector(16 downto 0 );
	signal rRefAddrEn  			: std_logic_vector( 4 downto 0 );
	signal rRefAddr 			: std_logic_vector( 3 downto 0 );

	signal rRdData				: std_logic_vector(16 downto 0 );

	signal rIndexAckedCal		: std_logic_vector(16 downto 0 );
	signal rIndexAddrCal		: std_logic_vector( 3 downto 0 );
	
Begin 
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	
	RdData	<= rRdData;		
	RefAddr	<= rRefAddr - 1;
	
----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------
-- control signal 

	u_rRefAddrEn : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( RstB='0' ) then 
				rRefAddrEn( 4 downto 0 )	<= (others=>'0');
			else 
				rRefAddrEn(2)	<= rRefAddrEn(1); 
				rRefAddrEn(1)	<= rRefAddrEn(0); 
				if ( rRefAddrEn(3)='1' or rRefAddrEn(4)='1' ) then 
					rRefAddrEn(0)	<= '0';
				elsif ( rIndexAddrCal/=0 and AckVal='1' ) then 
					rRefAddrEn(0)	<= '1';
				else 
					rRefAddrEn(0)	<= rRefAddrEn(0);
				end if;
				
				rRefAddrEn(4)	<= rRefAddrEn(3); 
				if ( rRefAddrEn(3 downto 0)="0111" and rIndexAckedCal(16)='0' ) then 
					rRefAddrEn(3)	<= '1';
				else 
					rRefAddrEn(3)	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRefAddrEn;
	
	u_rRefAddr : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( Init='1' ) then 
				rRefAddr(3 downto 0)	<= x"1";
			elsif ( rRefAddrEn(3)='1' ) then 
				rRefAddr(3 downto 0)	<= rRefAddr(3 downto 0) + 1;
			else 
				rRefAddr(3 downto 0)	<= rRefAddr(3 downto 0);
			end if;
		end if;
	End Process u_rRefAddr; 
	
	u_rDataCal : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rIndexAckedCal(16 downto 0 )	<= AckNum(16 downto 0 ) - rRefData(16 downto 0 );
			rIndexAddrCal( 3 downto 0 )		<= rRefAddr( 3 downto 0 ) - WrAddr( 3 downto 0 ); 
		end if;
	End Process u_rDataCal; 

----------------------------------------------------------------------------------
-- RAM 

	u_WriteOp : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			if ( WrEn='1' ) then 
				RAM(conv_integer(WrAddr))	<= WrData;
			else 
				RAM(conv_integer(WrAddr))	<= RAM(conv_integer(WrAddr));
			end if;
		end if;
	End Process u_WriteOp;

	u_rq1 : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRdData	<= RAM(conv_integer(RdAddr));
		end if;
	End Process u_rq1;
	
	u_rq2 : Process (Clk) Is 
	Begin 
		if ( rising_edge(Clk) ) then 
			rRefData	<= RAM(conv_integer(rRefAddr));
		end if;
	End Process u_rq2;

End Architecture rtl;
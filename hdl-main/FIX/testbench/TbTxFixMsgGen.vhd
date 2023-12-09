----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TbTxFixMsgGen.vhd
-- Title        Testbench of FIX message generator 
-- 
-- Author       L.Ratchanon
-- Date         2021/02/12
-- Syntax       VHDL
-- Remark       New Creation
-- Description    
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use STD.textio.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_textio.all;
USE work.PkSigTbTxFixMsgGen.all;
 
Entity TbTxFixMsgGen Is
End Entity TbTxFixMsgGen;

Architecture HTWTestBench Of TbTxFixMsgGen Is

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
	Component PkMapTbTxFixMsgGen Is 
	End Component PkMapTbTxFixMsgGen;
	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------

	u_PkMapTbTxFixMsgGen : PkMapTbTxFixMsgGen; 

-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------
	
	u_Test : Process
	Begin
		-------------------------------------------
		-- TM=0 : Initialization  
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 

		TxCtrl2GenReq					<= '0';
		TxCtrl2GenMsgType( 2 downto 0 )	<= (others=>'0');
		MrketDataEn( 2 downto 0 )		<= (others=>'0');
	
		wait for 20*tClk;
		-------------------------------------------
		-- TM=1 : Genvalidation 
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		For i in 0 to 9 loop 
		
			MrketData0		<= conv_std_logic_vector(0+i*60, 10);
			MrketData1		<= conv_std_logic_vector(12+i*60, 10);
			MrketData2		<= conv_std_logic_vector(24+i*60, 10);
			MrketData3		<= conv_std_logic_vector(36+i*60, 10);
			MrketData4		<= conv_std_logic_vector(48+i*60, 10);
			MrketDataEn		<= "101"; --5 
			wait until rising_edge(Clk);
			TxCtrl2GenReq	<= '1';
			wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
			TxCtrl2GenReq	<= '0';
			wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
			
			-- Drop valid 
			TxCtrl2GenReq		<= '1';
			TxCtrl2GenMsgType	<= "111";
			wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
			TxCtrl2GenReq		<= '0';
			TxCtrl2GenMsgType	<= "000";
			wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		End loop;
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=2 : Generate Log on  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Log on with Username and password 
		TxCtrl2GenTag98		  <= x"30"; -- 0
		TxCtrl2GenTag108	  <= x"3330"; -- 30
		TxCtrl2GenTag141	  <= x"59"; -- Y
		TxCtrl2GenTag553	  <= x"4d445f4649585f414c4c"&x"000000000000"; -- MD_FIX_ALL
		TxCtrl2GenTag554	  <= x"6162636431323321"&x"0000000000000000"; -- abcd123!
		TxCtrl2GenTag1137	  <= x"39";
		TxCtrl2GenTag553Len	  <= '0'&x"A";
		TxCtrl2GenTag554Len	  <= '0'&x"8";
		TxCtrl2GenReq		  <= '1';
		TxCtrl2GenMsgType	  <= "001";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq	<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		wait for 10*tClk;
		
		-- Log on with Username while not generating password 
		TxCtrl2GenTag554Len	  <= (others=>'0');
		TxCtrl2GenReq		  <= '1';
		TxCtrl2GenMsgType	  <= "001";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq	<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		wait for 10*tClk;
		
		-- Log on with password while not generating Username 
		TxCtrl2GenTag553Len	  <= (others=>'0');
		TxCtrl2GenTag554Len	  <= '0'&x"8";
		TxCtrl2GenReq		  <= '1';
		TxCtrl2GenMsgType	  <= "001";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq	<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		wait for 10*tClk;
		
		-- Log on without both Username and password 
		TxCtrl2GenTag553Len	  <= (others=>'0');
		TxCtrl2GenTag554Len	  <= (others=>'0');
		TxCtrl2GenReq		  <= '1';
		TxCtrl2GenMsgType	  <= "001";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq	<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=3 : Generate Heartbeat 
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		TxCtrl2GenTag112		<= x"54657374416c6976653132333421"&x"0000"; -- TestAlive1234!
		TxCtrl2GenTag112Len		<= '0'&x"E"; --14
		TxCtrl2GenReq		  	<= '1';
		TxCtrl2GenMsgType	  	<= "010";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq	<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=4 : Generate MkrDataReq  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		TxCtrl2GenTag262		<= x"4d41"; -- MA 
		TxCtrl2GenTag263	    <= x"31"; -- 1
		TxCtrl2GenTag264	    <= x"31"; -- 1
		TxCtrl2GenTag265	    <= x"30"; -- 0
		TxCtrl2GenTag266	    <= x"59"; -- Y
		TxCtrl2GenTag146	    <= x"5"; -- 5 Number 
		TxCtrl2GenTag22		    <= x"38";
		TxCtrl2GenTag267	    <= "010";
		TxCtrl2GenTag269	    <= x"3031";
		
		For i in 0 to 9 loop 
			
			-- Gen Valid 
			MrketData0			<= conv_std_logic_vector(0+i*60, 10);
			MrketData1			<= conv_std_logic_vector(12+i*60, 10);
			MrketData2			<= conv_std_logic_vector(24+i*60, 10);
			MrketData3			<= conv_std_logic_vector(36+i*60, 10);
			MrketData4			<= conv_std_logic_vector(48+i*60, 10);
			MrketDataEn			<= "101"; --5 
			wait until rising_edge(Clk);
			TxCtrl2GenReq		<= '1';
			TxCtrl2GenMsgType	<= "000";
			wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
			TxCtrl2GenReq		<= '0';
			wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
			wait for 10*tClk; 
		
			-- Send MkrDataReq
			TxCtrl2GenReq		<= '1';
			TxCtrl2GenMsgType	<= "011";
			wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
			TxCtrl2GenReq		<= '0';
			wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
			-- Drop valid 
			TxCtrl2GenReq		<= '1';
			TxCtrl2GenMsgType	<= "111";
			wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
			TxCtrl2GenReq		<= '0';
			TxCtrl2GenMsgType	<= "000";
			wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		End loop;
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=5 : Generate ResendReq   
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		
		TxCtrl2GenTag7		<= conv_std_logic_vector(1423, 27);
		TxCtrl2GenTag16		<= x"30"; 
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "100";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=6 : Generate SeqReset    
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		
		TxCtrl2GenTag123	<= x"59"; -- Y 
		TxCtrl2GenTag36		<= conv_std_logic_vector(124213, 27);
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "101";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=6 : Generate Reject     
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		TxCtrl2GenTag45		<= conv_std_logic_vector(2021, 27);
		TxCtrl2GenTag371	<= x"313132"&x"00";
		TxCtrl2GenTag372	<= x"41";
		TxCtrl2GenTag373	<= x"3939"; -- 99 
		TxCtrl2GenTag58		<= x"5465737420436f6e6e656374696f6e"&x"00"; -- Test Connection
		TxCtrl2GenTag371Len	<= conv_std_logic_vector(3, 3);
		TxCtrl2GenTag373Len	<= conv_std_logic_vector(2, 2);
		TxCtrl2GenTag58Len	<= conv_std_logic_vector(15, 4);
		
		
		-- FULL  
		TxCtrl2GenTag371En	<= '1';
		TxCtrl2GenTag372En	<= '1';
		TxCtrl2GenTag373En	<= '1';
		TxCtrl2GenTag58En	<= '1';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '0';
		TxCtrl2GenTag372En	<= '1';
		TxCtrl2GenTag373En	<= '1';
		TxCtrl2GenTag58En	<= '1';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '1';
		TxCtrl2GenTag372En	<= '0';
		TxCtrl2GenTag373En	<= '1';
		TxCtrl2GenTag58En	<= '1';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '1';
		TxCtrl2GenTag372En	<= '1';
		TxCtrl2GenTag373En	<= '0';
		TxCtrl2GenTag58En	<= '1';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '1';
		TxCtrl2GenTag372En	<= '1';
		TxCtrl2GenTag373En	<= '1';
		TxCtrl2GenTag58En	<= '0';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '0';
		TxCtrl2GenTag372En	<= '0';
		TxCtrl2GenTag373En	<= '1';
		TxCtrl2GenTag58En	<= '1';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '0';
		TxCtrl2GenTag372En	<= '1';
		TxCtrl2GenTag373En	<= '0';
		TxCtrl2GenTag58En	<= '1';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '0';
		TxCtrl2GenTag372En	<= '1';
		TxCtrl2GenTag373En	<= '1';
		TxCtrl2GenTag58En	<= '0';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '1';
		TxCtrl2GenTag372En	<= '0';
		TxCtrl2GenTag373En	<= '0';
		TxCtrl2GenTag58En	<= '1';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '1';
		TxCtrl2GenTag372En	<= '0';
		TxCtrl2GenTag373En	<= '1';
		TxCtrl2GenTag58En	<= '0';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '1';
		TxCtrl2GenTag372En	<= '1';
		TxCtrl2GenTag373En	<= '0';
		TxCtrl2GenTag58En	<= '0';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '0';
		TxCtrl2GenTag372En	<= '0';
		TxCtrl2GenTag373En	<= '0';
		TxCtrl2GenTag58En	<= '1';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '1';
		TxCtrl2GenTag372En	<= '0';
		TxCtrl2GenTag373En	<= '0';
		TxCtrl2GenTag58En	<= '0';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '0';
		TxCtrl2GenTag372En	<= '1';
		TxCtrl2GenTag373En	<= '0';
		TxCtrl2GenTag58En	<= '0';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '0';
		TxCtrl2GenTag372En	<= '0';
		TxCtrl2GenTag373En	<= '1';
		TxCtrl2GenTag58En	<= '0';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		TxCtrl2GenTag371En	<= '0';
		TxCtrl2GenTag372En	<= '0';
		TxCtrl2GenTag373En	<= '0';
		TxCtrl2GenTag58En	<= '0';
		TxCtrl2GenReq		<= '1';
		TxCtrl2GenMsgType	<= "110";
		wait until Gen2TxCtrlBusy='1' and rising_edge(Clk); 
		TxCtrl2GenReq		<= '0';
		wait until Gen2TxCtrlBusy='0' and rising_edge(Clk); 
		
		wait for 100*tClk;
		-------------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
	End Process u_Test;
	
End Architecture HTWTestBench;
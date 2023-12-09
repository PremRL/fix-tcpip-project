----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TbTxFixMsg.vhd
-- Title        Testbench of FIX message transmitter 
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
USE work.PkTbTxFixMsg.all;
USE work.PkSigTbTxFixMsg.all;
 
Entity TbTxFixMsg Is
End Entity TbTxFixMsg;

Architecture HTWTestBench Of TbTxFixMsg Is

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
	Component PkMapTbTxFixMsg Is 
	End Component PkMapTbTxFixMsg;
	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------

	u_PkMapTbTxFixMsg : PkMapTbTxFixMsg; 

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

		FixCtrl2TxReq			<= '0';	 	
		FixCtrl2TxPossDupEn     <= '0';	 	
		FixCtrl2TxReplyTest		<= '0';
		MsgType					<= (others=>'0');
		MsgSeqNum				<= (others=>'0');
		MsgSendTimeYear		    <= conv_std_logic_vector(2021, 14);
		MsgSendTimeMonth	    <= conv_std_logic_vector(2, 4);
		MsgSendTimeDay		    <= conv_std_logic_vector(16, 5);
		MsgSendTimeHour		    <= conv_std_logic_vector(0, 5);
		MsgSendTimeMin		    <= conv_std_logic_vector(52, 6);
		MsgSendTimeMilliSec	    <= conv_std_logic_vector(24531, 17);
		MsgBeginString			<= x"464958542e312e31"; -- FIXT.1.1
		MsgSenderCompID			<= x"4d445f4649585f414c4c"&x"000000000000"; -- MD_FIX_ALL
		MsgTargetCompID			<= x"534554"&x"00000000000000000000000000"; -- SET 
		MsgBeginStringLen   	<= conv_std_logic_vector(8, 4);
		MsgSenderCompIDLen		<= conv_std_logic_vector(10, 5);
		MsgTargetCompIDLen		<= conv_std_logic_vector(3, 5);
		TOE2FixMemAlFull	 	<= '0';
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=1 : Gen valid  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		MrketData0				<= conv_std_logic_vector(0, 10);  
		MrketData1				<= conv_std_logic_vector(12, 10);
		MrketData2				<= conv_std_logic_vector(24, 10);
		MrketData3				<= conv_std_logic_vector(36, 10);
		MrketData4				<= conv_std_logic_vector(48, 10);
		MrketDataEn				<= "101"; --5 
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "1000";
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		wait until FixTx2CtrlBusy='0' and rising_edge(Clk); 
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=2 : Generate Log on  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		-- Log on Detail 
		MsgGenTag98		  		<= x"30"; -- 0
		MsgGenTag108	  		<= x"3330"; -- 30
		MsgGenTag141	  		<= x"59"; -- Y
		MsgGenTag553	  		<= x"4d445f4649585f414c4c"&x"000000000000"; -- MD_FIX_ALL
		MsgGenTag554	  		<= x"6162636431323321"&x"0000000000000000"; -- abcd123!
		MsgGenTag1137	  		<= x"39";
		MsgGenTag553Len	  		<= conv_std_logic_vector(10, 5);
		MsgGenTag554Len	  		<= conv_std_logic_vector(8, 5);
		
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "0001";
		MsgSeqNum				<= conv_std_logic_vector(1, 27);
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		FixOutDataVerify(FixOutDataRec, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=3 : Generate Heartbeat  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		MsgGenTag112			<= x"5265706c7954657374526571"&x"00000000"; -- ReplyTestReq
		MsgGenTag112Len			<= conv_std_logic_vector(12, 5);
		
		-- Without 112 
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "0010";
		MsgSeqNum				<= MsgSeqNum + 1;
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		FixOutDataVerify(FixOutDataRec, Clk);
		
		-- With 112
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		FixCtrl2TxReplyTest		<= '1';
		MsgType					<= "0010";
		MsgSeqNum				<= MsgSeqNum + 1;
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		FixCtrl2TxReplyTest		<= '0';
		FixOutDataVerify(FixOutDataRec, Clk);
		
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=4 : Generate MrkDataReq  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		MsgGenTag262			<= x"4d41"; -- MA 
		MsgGenTag263			<= x"31"; -- 1
		MsgGenTag264			<= x"31"; -- 1
		MsgGenTag265			<= x"30"; -- 0
		MsgGenTag266			<= x"59"; -- Y
		MsgGenTag146			<= x"5"; -- 5 Number 
		MsgGenTag22				<= x"38";
		MsgGenTag267			<= "010";
		MsgGenTag269			<= x"3031";
		
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "0011";
		MsgSeqNum				<= MsgSeqNum + 1;
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		FixOutDataVerify(FixOutDataRec, Clk);
		
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=5 : Generate ResendReq  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		MsgGenTag7				<= conv_std_logic_vector(2, 27);
		MsgGenTag16				<= x"30"; 
		
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "0100";
		MsgSeqNum				<= MsgSeqNum + 1;
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		FixOutDataVerify(FixOutDataRec, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=6 : Generate SeqReset  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		MsgGenTag123	        <= x"59"; -- Y 
		MsgGenTag36				<= conv_std_logic_vector(1, 27);
		
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "0101";
		MsgSeqNum				<= MsgSeqNum + 1;
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		FixOutDataVerify(FixOutDataRec, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=7 : Generate Reject  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		
		MsgGenTag45				<= conv_std_logic_vector(5, 27);
		MsgGenTag371	        <= x"313132"&x"00";
		MsgGenTag372	        <= x"41";
		MsgGenTag373	        <= x"3939"; -- 99 
		MsgGenTag58		        <= x"5465737420436f6e6e656374696f6e"&x"00"; -- Test Connection
		
		MsgGenTag371Len			<= conv_std_logic_vector(3, 3);
		MsgGenTag373Len	        <= conv_std_logic_vector(2, 2);
		MsgGenTag58Len	        <= conv_std_logic_vector(15, 4);
		MsgGenTag371En			<= '1';
		MsgGenTag372En	        <= '1';
		MsgGenTag373En	        <= '1';
		MsgGenTag58En	        <= '1';

		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "0110";
		MsgSeqNum				<= MsgSeqNum + 1;
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		FixOutDataVerify(FixOutDataRec, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=8 : Generate TestReq  
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		MsgGenTag112			<= x"52737453657123"&x"000000000000000000"; -- ReplyTestReq
		MsgGenTag112Len			<= conv_std_logic_vector(7, 5);
		
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "0000";
		MsgSeqNum				<= MsgSeqNum + 1;
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		FixOutDataVerify(FixOutDataRec, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=9 : Generate Logout   
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "0111";
		MsgSeqNum				<= MsgSeqNum + 1;
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		FixOutDataVerify(FixOutDataRec, Clk);
		
		wait for 20*tClk;
		-------------------------------------------
		-- TM=10 : Reset valid 
		-------------------------------------------
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT); 
		
		wait until rising_edge(Clk);
		FixCtrl2TxReq			<= '1';
		MsgType					<= "1111";
		MsgSeqNum				<= MsgSeqNum + 1;
		wait until FixTx2CtrlBusy='1' and rising_edge(Clk); 
		FixCtrl2TxReq			<= '0';
		
		wait for 100*tClk;
		-------------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 20*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
	End Process u_Test;
	
End Architecture HTWTestBench;
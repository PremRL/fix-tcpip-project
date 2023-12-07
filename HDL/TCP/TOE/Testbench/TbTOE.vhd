----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     TbTOE.vhd
-- Title        Testbench for TCP/TP offload engine 
-- 
-- Author       L.Ratchanon
-- Date        	2020/11/10
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
use work.PkTbTOE.all;
use work.PkSigTbTOE.all;

Entity TbTOE Is
End Entity TbTOE;

Architecture HTWTestBench Of TbTOE Is

-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
	Component PkMapTbTOE Is
    End Component PkMapTbTOE;
	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u_PkMapTbTOE : PkMapTbTOE;
	
-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------
	
	-- Notation of UserStatus 4 bit	->	LSB	: Closed 
	--							->	bit1	: Connecting
	--							->	bit2 : Established 
	--							->	MSB	: Terminating


	u_Test : Process
	variable	vPayloadLen         : integer range 0 to 16383 := 0; -- when 0 : No Payload 
	variable	vPayloadValue       : integer range 0 to 255 := 0;
	variable	vRxMacErrorOp       : integer range 0 to 1 := 0; -- No Error 
	variable 	vDataGenLength		: integer range 0 to 65535 := 0;
	variable    vDataGenValue	    : integer range 0 to 255 := 0;
	variable    vDataGenOp		    : integer range 0 to 1 := 0; -- Valid drop test when '1'
	
	Begin
		-------------------------------------------
		-- TM=0 : Initialization 
		-------------------------------------------
		TM <= 0; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Reset  
		User2TOEConnectReq			<= '0';
		User2TOETerminateReq    	<= '0';
		User2TOERxReq        		<= '0';
		
		UNG2TOESenderMACAddr 		<= (others=>'0');
		UNG2TOETargetMACAddr		<= (others=>'0');
		UNG2TOESenderIpAddr	    	<= (others=>'0');
		UNG2TOETargetIpAddr	    	<= (others=>'0');
		UNG2TOESrcPort     	    	<= (others=>'0');
		UNG2TOEDesPort     	    	<= (others=>'0');
		UNG2TOEAddrVal		 		<= '0';
		
		RxDataGenInitial(RxDataGenRecOut);
		
		wait for 20*tClk;
		----------------------------------------------------
		-- Set Unchanged Parameters
		-- Network registation 
		UNG2TOESenderMACAddr 		<= x"A235_C161_FAD2";
		UNG2TOETargetMACAddr		<= x"4CCC_6A83_972D";
		UNG2TOESenderIpAddr	    	<= x"C0A8_0701";
		UNG2TOETargetIpAddr	    	<= x"C0A8_0719";
		UNG2TOESrcPort     	    	<= x"3039";
		UNG2TOEDesPort     	    	<= x"6223";
		UNG2TOEAddrVal		 		<= '1';
		-- User always read Rx Data 
		User2TOERxReq        		<= '1';
		-- RxMac Process 
		PktTCPIPRecIn.MacDes		<= x"A235_C161_FAD2";
		PktTCPIPRecIn.MacSrc        <= x"4CCC_6A83_972D";  
		PktTCPIPRecIn.MacEtherType  <= x"0800";
		PktTCPIPRecIn.IPVerIHL      <= x"45";  
		PktTCPIPRecIn.IPDSCPEC      <= x"00";  
		PktTCPIPRecIn.IPFlags       <= x"4000";  
		PktTCPIPRecIn.IPTTL         <= x"80";   
		PktTCPIPRecIn.IPProtocol    <= x"06";
		PktTCPIPRecIn.IPSrcAddr     <= x"C0A8_0719";  
		PktTCPIPRecIn.IPDesAddr     <= x"C0A8_0701";  
		PktTCPIPRecIn.TCPSrcPort    <= x"6223";  
		PktTCPIPRecIn.TCPDesPort    <= x"3039";  
		PktTCPIPRecIn.TCPDataOff    <= x"5";  
		PktTCPIPRecIn.TCPAckFlag    <= '0';  
		PktTCPIPRecIn.TCPPshFlag    <= '0';  
		PktTCPIPRecIn.TCPRstFlag    <= '0';  
		PktTCPIPRecIn.TCPSynFlag    <= '0';  
		PktTCPIPRecIn.TCPFinFlag    <= '0';   
		PktTCPIPRecIn.TCPWinSize    <= x"FFFF";  
		PktTCPIPRecIn.TCPUrgent     <= x"0000";  
		----------------------------------------------------
		-- Reset changed Parameters of RxMac Process 
		PktTCPIPRecIn.IPIdent       <= x"0000";		
		PktTCPIPRecIn.TCPSeqNum     <= x"0000_0000";
		PktTCPIPRecIn.TCPAckNum     <= x"0000_0000"; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';

		wait for 20*tClk;
		-------------------------------------------
		-- TM=1 : Connection-Close 
		-------------------------------------------	
		-------------------------------------------
		-- TT=0 : Connection-Close 1
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_AABB";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait for 100*tClk;
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
		-- Wait for client FIN
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server ACK 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1;  
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		wait for 50*tClk;
		
		-- Send Server FIN  
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 2000*tClk;
		-------------------------------------------
		-- TT=1 : Connection-Close 2
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"AABB_1234";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait for 100*tClk;
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
		-- Wait for client FIN
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server FIN-ACK
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 2000*tClk;
		-------------------------------------------
		-- TT=2 : Connection-Close 3
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_1234";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait for 150*tClk;
		
		-- Send Server FIN-ACK 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait for 50*tClk;
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
		-- Wait for client FIN
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait for 100*tClk;
		
		-- Send Server ACK 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1;
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		wait for 100*tClk;
		-------------------------------------------
		-- TT=3 : Connection-Close 4
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"ABAB_CDCD";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait for 100*tClk;
		
		-- Send Server RST
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '1';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 

		wait for 100*tClk;
		-------------------------------------------
		-- TM=2 : Data Transfer 
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Data trans: received
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_1234";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Established
		-- Server send 3 Data Packet to Client  
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 1460; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 500; vPayloadValue := vPayloadValue + 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 12*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 103; vPayloadValue := vPayloadValue + 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Wait for RxUserData Done 
		wait until rising_edge(Clk) and TOE2UserRxEOP='1' and TOE2UserRxValid='1';
		wait until rising_edge(Clk) and TOE2UserRxEOP='1' and TOE2UserRxValid='1';
		wait until rising_edge(Clk) and TOE2UserRxEOP='1' and TOE2UserRxValid='1';
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
		-- Wait for client FIN
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait for 50*tClk;
		
		-- Send Server ACK 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		wait for 50*tClk;
		
		-- Send Server FIN  
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
	
		wait for 2000*tClk;
		-------------------------------------------
		-- TT = 1 : Data trans: Sent 1
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_5678";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Wait for TxTCP/IP Send data Packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		-- Server Send ACK 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 50; -- Send Data packet (length=50) 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for TxTCP/IP Send data Packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		-- Server Send ACK 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 401; -- Send Data packet (length=401) 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for TxTCP/IP Send data Packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		-- Server Send ACK 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 500; -- Send Data packet (length=500) 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Server Send ACK For last data packet 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; -- Send Data packet (length=1) 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		wait for 100*tClk;
		-------------------------------------------
		-- TT = 2 : Data trans: Sent 2 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Wait for TxTCP/IP Send 3 data Packets
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server Send cumulative ACK For last data packet 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 600; -- Send Data packet (length=150+199+251) 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		wait for 100*tClk;
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
		-- Wait for client FIN
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait for 50*tClk;
		
		-- Send Server ACK 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		wait for 50*tClk;
		
		-- Send Server FIN  
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 2000*tClk;
		-------------------------------------------
		-- TT = 3 : Data Trans: 2-way comm 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"5678_1234";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Wait for 3 data packets 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Data with ACK set (Piggybacking)
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 345; -- Send Data packet (length=100+120+125)  
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 501; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Server Send data packet 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 1; vPayloadValue := vPayloadValue + 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for 1 data packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1'; 
		
		-- Server send ACK packet 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 150; -- Send DAta packet (length=150)  
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := vPayloadValue; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		wait for 200*tClk;
		-- Server send data packet 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; -- Send Data packet (length=250)  
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 200; vPayloadValue := vPayloadValue + 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for data packet and ACK packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server send ACK packet 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 500; -- Send Data packet (length=500)  
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := vPayloadValue + 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		wait for 150*tClk;
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
		
		-- Wait for data packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server send ACK packet 
		wait for 150*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 250; -- Send Data packet (length=250)  
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := vPayloadValue + 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client FIN
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait for 50*tClk;
		
		-- Send Server ACK 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		wait for 50*tClk;
		
		-- Send Server FIN  
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 2000*tClk;
		-------------------------------------------
		-- TM=3 : Retrans timeout
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Retrans timeout: SYN
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for 2 client SYN packet (1 Retrans)
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_5678";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		
		wait for 500*tClk;
		-------------------------------------------
		-- TT = 1 : Retrans timeout: FIN 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
		
		-- Wait for 2 client FIN packet (1 Retrans)
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server ACK 
		wait for 150*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Send Server FIN  
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 2000*tClk;
		-------------------------------------------
		-- TT = 2 : Retrans timeout: Data 1
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_ABCD";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- wait for Data Packet that sending to Server and its retransmission packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server ACK 
		wait for 150*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 100;  -- Send Data packet (length=100)     
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 200*tClk;
		-------------------------------------------
		-- TT = 3 : Retrans timeout: Data 2 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Wait for 2 Data Packets out (Sending 4 packets)
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server send ACK to first packet 
		wait for 150*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 101;  -- Send Data packet (length=101)     
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for 3 Data Packets out (Retransmission packets)
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server send ACK to all packet 
		wait for 150*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 581;  -- Send Data packet (length=505+1+75)     
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
	
		-- Wait for client FIN packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server ACK 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Send Server FIN  
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 2000*tClk;
		-------------------------------------------
		-- TM=4 : Retrans recv data
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Retrans recv data: ACK 1
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_ABCD";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server send SYN-ACK again due to loss of ACK packet 
		wait for 500*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 200*tClk;
		-------------------------------------------
		-- TT = 1 : Retrans recv data: ACK 2
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Server send 1 data packet to client 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 201; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server send that data packet again due to loss of ACK packet 
		wait for 500*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 201; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 200*tClk;
		-------------------------------------------
		-- TT = 2 : Retrans recv data: ACK 3
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Received 3 data packet from server 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 100; vPayloadValue := 2; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 200; vPayloadValue := 3; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 300; vPayloadValue := 4; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for last Client ACK packets 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server send that data packet again due to loss of all ACK packets 
		-- Delay 
		wait for 500*tClk;	
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum - 300;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 100; vPayloadValue := 2; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 100*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 200; vPayloadValue := 3; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 100*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 300; vPayloadValue := 4; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for last Client ACK packets 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 200*tClk;
		-------------------------------------------
		-- TT = 3 : Retrans recv data: ACK 4
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
	
		-- Wait for client FIN packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server ACK 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Send Server FIN  
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server not receiving ACK Packet, Send FIN Packet again 
		wait for 500*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		wait for 2000*tClk;
		-------------------------------------------
		-- TM=5 : Retrans 3ACK 
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Retrans 3ACK : 1st packet of 3 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_1234";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Sending 3 data packets (But wait only 2 packets)
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Sending three ACK from server indicate 1st packet  
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 12*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 12*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- wait for last packet that sent 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Wait for 3 data packets (retransmission packets)
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send ACK to client 
		wait for 150*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 664; -- Send Data packet (length=150+13+501)       
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 200*tClk;
		-------------------------------------------
		-- TT = 1 : Retrans 3ACK : 2nd packet of 3 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Wait for 3 data packets that sent to server 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Sending three ACK from server indicate 2nd packet   
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 101; -- Send Data packet (length=101)   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 12*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 12*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for 2 data packets (retransmission packets)
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send ACK to client 
		wait for 150*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 505; -- Send Data packet (length=202+303)       
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
	
		-- Wait for client FIN packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server ACK 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Send Server FIN  
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 2000*tClk;
		-------------------------------------------
		-- TM=6 : Sent 3 ACK
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Retrans 3ACK: 1
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"ABCD_EF12";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server send 2 data packets, the first one is lose but the sescond one doesn't 
		-- 1st: Length = 200 
		-- 2nd: Length = 300 
		
		wait for 300*tClk; 
		-- send 2nd packet
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1 + 200;
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 300; vPayloadValue := 2; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- wait for three ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Retransmission 
		-- 1st 
		wait for 300*tClk; 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum - 200;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 200; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		-- 2nd 
		wait for 350*tClk; 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 300; vPayloadValue := 2; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		wait for 200*tClk;
		-------------------------------------------
		-- TT = 1 : Retrans 3ACK: 2
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Server send 2 data packets, but it's out-of-order packets 
		-- 1st: Length = 100 
		-- 2nd: Length = 250 
		
		wait for 200*tClk; 
		-- send 2nd packet
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen + 100;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 250; vPayloadValue := 2; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- While sending 3 ACK, receiving 1st data packet 
		wait for 60*tClk; 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum - 100;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 100; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Retransmission packets 
		-- 1st 
		wait for 250*tClk; 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 100; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		-- 2nd  
		wait for 350*tClk; 
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum;   
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 250; vPayloadValue := 2; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
	
		-- Wait for client FIN packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server ACK 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + vPayloadLen;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Send Server FIN  
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';

		wait for 2000*tClk;
		-------------------------------------------
		-- TM=7 : Flow Control 
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : Flow Cont: Trans side   
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_5678";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;  
		PktTCPIPRecIn.TCPWinSize    <= x"03E8";  -- 1000 Bytes 	
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send 5 packets to server as: 500, 100, 200, 200, 500, and 750 bytes 
		-- But only 4 packets receiving  
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send ACK to 2 packets firstly arrived to the server 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 600; -- Send Data packet (length=500+100)         
		PktTCPIPRecIn.TCPWinSize    <= PktTCPIPRecIn.TCPWinSize - 600;  -- 400 Bytes 	
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for 2 packets 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send ACK for 4 packets that was sent to the server  
		wait for 150*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 400; -- Send Data packet (length=200+200)         
		PktTCPIPRecIn.TCPWinSize    <= PktTCPIPRecIn.TCPWinSize - 400;  -- 0 Bytes 	
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for receiving window at server update 
		wait for 500*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPWinSize    <= x"03E8";  -- 1000 Bytes 		
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- wait for 1 data packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Wait for receiving window at server update and ACK to 500 bytes data packet 
		wait for 500*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 500; -- Send Data packet (length=500)         
		PktTCPIPRecIn.TCPWinSize    <= x"03E8";  -- 1000 Bytes 		
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- wait for last data packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Server send ACK Packet 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 750; -- Send Data packet (length=750)         
		PktTCPIPRecIn.TCPWinSize    <= PktTCPIPRecIn.TCPWinSize - 750;  -- 250 Bytes 		
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		wait for 500*tClk;
		-------------------------------------------
		-- TT = 1 : Flow Cont: Zero window 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Disconnection 
		wait until rising_edge(Clk);
		User2TOETerminateReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(3)='1';
		User2TOETerminateReq	<= '0';
	
		-- Wait for client FIN packet
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server ACK 
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 1; 
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Send Server FIN  
		wait for 50*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum; 
		PktTCPIPRecIn.TCPAckFlag    <= '0';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '1';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Wait for client ACK
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';

		wait for 2000*tClk;
		-------------------------------------------
		-- TM=8 : Special event
		-------------------------------------------	
		-------------------------------------------
		-- TT = 0 : 
		TM <= TM + 1; TT <= 0; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		
		-- Connection 
		wait until rising_edge(Clk);
		User2TOEConnectReq	<= '1';
		wait until rising_edge(Clk) and TOE2UserStatus(1)='1';
		User2TOEConnectReq	<= '0';
		-- Wait for client SYN packet 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server SYN-ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"1234_5678";
		PktTCPIPRecIn.TCPAckNum     <= TCPDataRecOut.TCPSeqNum + 1;  
		PktTCPIPRecIn.TCPWinSize    <= x"FFFF";  
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '1';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk); 
		
		-- Wait for Client ACK 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send 4 packets to server as: 536, 536, 424, and 536 bytes
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		-- Send Server ACK 
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= PktTCPIPRecIn.TCPSeqNum + 1;
		PktTCPIPRecIn.TCPAckNum     <= PktTCPIPRecIn.TCPAckNum + 2032;  -- Send Data packet (length=536*3+424)         
		PktTCPIPRecIn.TCPWinSize    <= x"FFFF";  
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '0';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 0; vPayloadValue := 1; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		-- Send Server Invalid SeqNum/AckNum   
		wait for 40*tClk;
		PktTCPIPRecIn.IPIdent       <= PktTCPIPRecIn.IPIdent + 1;		
		PktTCPIPRecIn.TCPSeqNum     <= x"6c18ecdf";
		PktTCPIPRecIn.TCPAckNum     <= x"c800bc73";  -- Send Data packet (length=536*3+424)         
		PktTCPIPRecIn.TCPWinSize    <= x"FEF0";  
		PktTCPIPRecIn.TCPAckFlag    <= '1';
		PktTCPIPRecIn.TCPPshFlag    <= '1';
		PktTCPIPRecIn.TCPRstFlag    <= '0';
		PktTCPIPRecIn.TCPSynFlag    <= '0';
		PktTCPIPRecIn.TCPFinFlag    <= '0';
		vPayloadLen	:= 129; vPayloadValue := 129; vRxMacErrorOp := 0; 
		RxTCPDataGen(RxDataGenRecOut, PktTCPIPRecIn, vPayloadLen, vPayloadValue, vRxMacErrorOp, Clk);
		
		wait for 2000*tClk;
		-------------------------------------------
		-- TT = 1 : 
		TM <= TM; TT <= TT + 1; wait for 1 ns;
		Report "TM=" & integer'image(TM) & " TT=" & integer'image(TT);
		wait for 2000*tClk;
		-------------------------------------------
		--------------------------------------------------------
		TM <= 255; wait for 1 ns;
		wait for 200*tClk;
		Report "##### End Simulation #####" Severity Failure;		
		wait;
		
	End Process u_Test;
	
	-- User Data generating process 
	u_TestUserData : Process
	variable	vDataGenLength	: integer range 0 to 65535;
	variable	vDataGenValue	: integer range 0 to 255 := 0;
	variable	vDataGenOp		: integer range 0 to 1;
	
	Begin 
		-------------------------------------------
		-- Initialization
		-------------------------------------------	
		DataGenInitial(DataGenRecOut);

		-- TM=2 and TT=1 
		-------------------------------------------
		wait until TM=2 and TT=1;
		wait until TOE2UserStatus(2)='1' and rising_edge(Clk);
		-- Send 4 Data packets to server 
		vDataGenLength	:= 50;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- Wait until there's no data laft to send 
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutEop='1';
		
		vDataGenLength	:= 401;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 500;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 1;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- TM=2 and TT=1 
		-------------------------------------------
		wait until TM=2 and TT=2;
		
		vDataGenLength	:= 150;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 199;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 251;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- TM=2 and TT=3
		-------------------------------------------
		wait until TM=2 and TT=3;
		
		wait until TOE2UserStatus(2)='1' and rising_edge(Clk);
		-- Send 3 Data packets to server 
		vDataGenLength	:= 100;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 120;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 125;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- Send 2 Data packet to server 
		wait for 770*tClk;
		vDataGenLength	:= 150;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 500;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		wait for 880*tClk;
		vDataGenLength	:= 250;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- TM=3 and TT=2 
		-------------------------------------------
		wait until TM=3 and TT=2;
		
		wait until TOE2UserStatus(2)='1' and rising_edge(Clk);
		-- Send 1 Data packets to server 
		vDataGenLength	:= 100;
		vDataGenValue	:= 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- TM=3 and TT=3 
		-------------------------------------------
		wait until TM=3 and TT=3;
		
		wait until TOE2UserStatus(2)='1' and rising_edge(Clk);
		-- Send 4 Data packets to server 
		vDataGenLength	:= 101;
		vDataGenValue	:= 2;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 505;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 1;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 75;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- TM=5 and TT=0 
		-------------------------------------------
		wait until TM=5 and TT=0;
		
		wait until TOE2UserStatus(2)='1' and rising_edge(Clk);
		-- Send 4 Data packets to server 
		vDataGenLength	:= 150;
		vDataGenValue	:= 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 13;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 501;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- TM=5 and TT=0 
		-------------------------------------------
		wait until TM=5 and TT=1;
		
		wait until TOE2UserStatus(2)='1' and rising_edge(Clk);
		-- Send 4 Data packets to server 
		vDataGenLength	:= 101;
		vDataGenValue	:= 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 202;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 303;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- TM=7 and TT=0 
		-------------------------------------------
		wait until TM=7 and TT=0;
		
		wait until TOE2UserStatus(2)='1' and rising_edge(Clk);
		-- Send 6 Data packets to server 
		vDataGenLength	:= 500;
		vDataGenValue	:= 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 100;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 200;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 200;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 500;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 750;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		-- TM=8 and TT=0 
		-------------------------------------------
		wait until TM=8 and TT=0;
		
		wait until TOE2UserStatus(2)='1' and rising_edge(Clk);
		-- Send 4 Data packets to server 
		vDataGenLength	:= 536;
		vDataGenValue	:= 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 536;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 424;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		vDataGenLength	:= 536;
		vDataGenValue	:= vDataGenValue + 1;
		vDataGenOp		:= 0;
		UserDataInGen(DataGenRecOut, vDataGenLength, vDataGenValue, vDataGenOp, Clk);
		
		wait;
	End Process u_TestUserData;	
	
	-- TxTCP/IP Data Verification
	u_TxVerify : Process
	Begin
		-------------------------------------------
		-- Initial expected value 
		-------------------------------------------	
		-- Fixed Fields  
		ExpDataRecIn.ExpEnetType	<= x"0800";
		ExpDataRecIn.ExpIPVerIHL	<= x"45";
		ExpDataRecIn.ExpDSCPECN 	<= x"00"; 
		ExpDataRecIn.ExpProtocol	<= x"06";
		
		-- Varying Fields (Assigned here)
		ExpDataRecIn.ExpMACSou	    <= x"A235C161FAD2";
		ExpDataRecIn.ExpMACDes		<= x"4CCC6A83972D";
		ExpDataRecIn.ExpIPSou	    <= x"C0A80701";
		ExpDataRecIn.ExpIPDes	    <= x"C0A80719";
		ExpDataRecIn.ExpSouPort	    <= x"3039";
		ExpDataRecIn.ExpDesPort	    <= x"6223";
		
		-------------------------------------------
		-- TxTCP/IP Verification 
		-------------------------------------------	
		L1 : Loop 
			wait until rising_edge(Clk) and TOE2EMACTxDataOutVal='1' and TOE2EMACTxDataOutSop='1';
			TxVerify(TCPDataRecOut, ExpDataRecIn,TOE2EMACTxDataOutVal,TOE2EMACTxDataOutSop,TOE2EMACTxDataOutEop,TOE2EMACTxDataOut,TOE2EMACTxDataOutFF,Clk);
		End Loop; 
	End Process u_TxVerify;


End Architecture HTWTestBench;
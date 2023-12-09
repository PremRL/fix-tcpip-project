##	
quit -sim
vlib work
#--------------------------------#
#--      Compile Package       --#
#--------------------------------#
vcom -work work ../Package/PkTbFixProc.vhd	
vcom -work work ../Package/PkSigTbFixProc.vhd	
vcom -work work ../Package/PkMapTbFixProc.vhd

#--------------------------------#
#--      Compile IP		       --#
#--------------------------------#
vcom -work work ../IP/Fifo72x8.vhd
vcom -work work ../IP/Ram74x16.vhd
vcom -work work ../IP/Ram128x8.vhd
vcom -work work ../IP/Ram1024x8.vhd

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/RxFix/Ascii2Bin.vhd
vcom -work work ../source/RxFix/RxHdDec.vhd
vcom -work work ../source/RxFix/RxMsgDec.vhd
vcom -work work ../source/RxFix/RxFix.vhd
vcom -work work ../source/TxFix/TxFixMsg/Ascii2Bin16bit.vhd
vcom -work work ../source/TxFix/TxFixMsg/Bin2Ascii.vhd
vcom -work work ../source/TxFix/TxFixMsg/Bin2AsciiPipe.vhd
vcom -work work ../source/TxFix/TxFixMsg/MuxEncoder.vhd
vcom -work work ../source/TxFix/TxFixMsg/Rom1024x8.vhd
vcom -work work ../source/TxFix/TxFixMsg/TxFixMsgCtrl.vhd
vcom -work work ../source/TxFix/TxFixMsg/TxFixMsgGen.vhd
vcom -work work ../source/TxFix/TxFixMsg.vhd
vcom -work work ../source/FixCtrl.vhd
vcom -work work ../source/FixProc.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbFixProc.vhd

vsim -t 100ps -novopt work.TbFixProc
view wave

do wave.do

view structure
view signals

run 1000 us	


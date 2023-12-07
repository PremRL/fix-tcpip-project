##	
quit -sim
vlib work
#--------------------------------#
#--      Compile Package       --#
#--------------------------------#
vcom -work work ../Package/PkTbTxFixMsg.vhd
vcom -work work ../Package/PkSigTbTxFixMsg.vhd
vcom -work work ../Package/PkMapTbTxFixMsg.vhd

#--------------------------------#
#--      Compile IP		       --#
#--------------------------------#

vcom -work work ../IP/Ram1024x8.vhd
vcom -work work ../IP/Ram128x8.vhd

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/TxFix/TxFixMsg/Rom1024x8.vhd
vcom -work work ../source/TxFix/TxFixMsg/Ascii2Bin16bit.vhd
vcom -work work ../source/TxFix/TxFixMsg/Bin2Ascii.vhd
vcom -work work ../source/TxFix/TxFixMsg/MuxEncoder.vhd
vcom -work work ../source/TxFix/TxFixMsg/Bin2AsciiPipe.vhd
vcom -work work ../source/TxFix/TxFixMsg/TxFixMsgGen.vhd
vcom -work work ../source/TxFix/TxFixMsg/TxFixMsgCtrl.vhd
vcom -work work ../source/TxFix/TxFixMsg.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbTxFixMsg.vhd

vsim -t 100ps -novopt work.TbTxFixMsg
view wave

do waveTxFixMsg.do

view structure
view signals

run 1000 us	


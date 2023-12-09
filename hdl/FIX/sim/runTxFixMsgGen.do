##	
quit -sim
vlib work
#--------------------------------#
#--      Compile Package       --#
#--------------------------------#
vcom -work work ../Package/PkSigTbTxFixMsgGen.vhd
vcom -work work ../Package/PkMapTbTxFixMsgGen.vhd


#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/TxFix/TxFixMsg/Rom1024x8.vhd
vcom -work work ../source/TxFix/TxFixMsg/Ascii2Bin16bit.vhd
vcom -work work ../source/TxFix/TxFixMsg/TxFixMsgGen.vhd
vcom -work work ../source/TxFix/TxFixMsg/Bin2Ascii.vhd
vcom -work work ../source/TxFix/TxFixMsg/MuxEncoder.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbTxFixMsgGen.vhd

vsim -t 100ps -novopt work.TbTxFixMsgGen
view wave

do waveTxFixMsgGen.do

view structure
view signals

run 1000 us	


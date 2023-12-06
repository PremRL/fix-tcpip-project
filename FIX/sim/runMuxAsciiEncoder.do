##	
quit -sim
vlib work
#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../Package/PkTbMuxEncoder.vhd
vcom -work work ../source/TxFix/TxFixMsg/Bin2Ascii.vhd
vcom -work work ../source/TxFix/TxFixMsg/MuxEncoder.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbMuxEncoder.vhd

vsim -t 100ps -novopt work.TbMuxEncoder
view wave

do waveMuxAsciiEncoder.do

view structure
view signals

run 1000 us	


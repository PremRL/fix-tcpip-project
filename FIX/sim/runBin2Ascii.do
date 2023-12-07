##	
quit -sim
vlib work
#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../Package/PkTbBin2Ascii.vhd
vcom -work work ../source/TxFix/TxFixMsg/Bin2Ascii.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbBin2Ascii.vhd

vsim -t 100ps -novopt work.TbBin2Ascii
view wave

do waveBin2Ascii.do

view structure
view signals

run 1000 us	


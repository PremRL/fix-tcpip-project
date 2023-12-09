##	
quit -sim
vlib work
#--------------------------------#
#--      Compile Package       --#
#--------------------------------#
vcom -work work ../Package/PkTbAscii2Bin.vhd

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/RxFix/Ascii2Bin.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbAscii2Bin.vhd

vsim -t 100ps -novopt work.TbAscii2Bin
view wave

do waveAscii2Bin.do

view structure
view signals

run 1000 us	


##	
quit -sim
vlib work
#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../Package/PkTbBin2Ascii.vhd
vcom -work work ../source/TxFix/TxFixMsg/Bin2AsciiPipe.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbBin2AsciiPipe.vhd

vsim -t 100ps -novopt work.TbBin2AsciiPipe
view wave

do waveBin2AsciiPipe.do

view structure
view signals

run 1000 us	


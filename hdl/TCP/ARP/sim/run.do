##
quit -sim
vlib work

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/TxArp.vhd
vcom -work work ../source/RxArp.vhd
vcom -work work ../source/ArpProc.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbArpProc.vhd

vsim -t 100ps -novopt work.TbArpProc
view wave

do wave.do

view structure
view signals

run 1000 us	


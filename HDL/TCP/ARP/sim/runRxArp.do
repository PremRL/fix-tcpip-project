##
quit -sim
vlib work

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/RxArp.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbRxArp.vhd

vsim -t 100ps -novopt work.TbRxArp
view wave

do waveRxArp.do

view structure
view signals

run 1000 us	


##
quit -sim
vlib work

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/TxArp.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbTxArp.vhd

vsim -t 100ps -novopt work.TbTxArp
view wave

do waveTxArp.do

view structure
view signals

run 1000 us	


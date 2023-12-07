##	
quit -sim
vlib work
#--------------------------------#
#--      Compile Package       --#
#--------------------------------#
vcom -work work ../Package/PkTbFixCtrl.vhd	
vcom -work work ../Package/PkSigTbFixCtrl.vhd	
vcom -work work ../Package/PkMapTbFixCtrl.vhd

#--------------------------------#
#--      Compile IP		       --#
#--------------------------------#
vcom -work work ../IP/Fifo72x8.vhd
vcom -work work ../IP/Ram74x16.vhd

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/FixCtrl.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbFixCtrl.vhd

vsim -t 100ps -novopt work.TbFixCtrl
view wave

do waveFIXCTRL.do

view structure
view signals

run 1000 us	


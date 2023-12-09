##
quit -sim
vlib work

vcom -work work ../Package/PkTbFixGen.vhd
vcom -work work ../Package/PkSigTbRxFix.vhd
vcom -work work ../Package/PkTbRxFix.vhd

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/RxFix/RxFix.vhd
vcom -work work ../source/RxFix/RxHdDec.vhd
vcom -work work ../source/RxFix/RxMsgDec.vhd
vcom -work work ../source/RxFix/Ascii2Bin.vhd

#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#

vcom -work work ../Testbench/TbRxFix.vhd

vsim -t 100ps -novopt work.TbRxFix
view wave

do waveRxFIX.do

view structure
view signals

run 100000 ms	


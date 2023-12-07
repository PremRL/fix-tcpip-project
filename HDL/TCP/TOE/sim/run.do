##
quit -sim
vlib work

#--------------------------------#
#--      Compile Package       --#
#--------------------------------#

vcom -work work ../Package/PkTbTOE.vhd
vcom -work work ../Package/PkSigTbTOE.vhd
vcom -work work ../Package/PkMapTbTOE.vhd

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vcom -work work ../source/TxTCP/Queue.vhd
vcom -work work ../source/TxTCP/CheckSumCal.vhd
vcom -work work ../source/TxTCP/IPHdGen.vhd
vcom -work work ../source/TxTCP/TCPHdGen.vhd
vcom -work work ../source/TxTCP/TxOutCtrl.vhd
vcom -work work ../source/TxTCP/TxTCPIP.vhd

vcom -work work ../source/TPU/LFSR.vhd
vcom -work work ../source/TPU/TxTPUCtrl.vhd
vcom -work work ../source/TPU/RxTPUCtrl.vhd
vcom -work work ../source/TPU/StateCtrl.vhd
vcom -work work ../source/TPU/TPUTCPIP.vhd

vcom -work work ../source/RxTCP/ClkAdaptor.vhd
vcom -work work ../source/RxTCP/RxDataCtrl.vhd
vcom -work work ../source/RxTCP/RxHeaderDec.vhd
vcom -work work ../source/RxTCP/RxTCPIP.vhd	

vcom -work work ../source/TOE.vhd	

#--------------------------------#
#--      Compile IP            --#
#--------------------------------#

vcom -work work ../IP/AsynFIFO16x16.vhd
vcom -work work ../IP/FIFO256x17.vhd
vcom -work work ../IP/Ram64kx8.vhd
vcom -work work ../IP/RamData16kx8.vhd
vcom -work work ../IP/RamIndex.vhd
vcom -work work ../IP/RamQueue.vhd
vcom -work work ../IP/RamTCPIPHd.vhd


#--------------------------------#
#--     Compile Test Bench     --#
#--------------------------------#
vcom -work work ../Testbench/TbTOE.vhd

vsim -t 100ps -novopt work.TbTOE
view wave

do wave.do

view structure
view signals

run 1000 us	


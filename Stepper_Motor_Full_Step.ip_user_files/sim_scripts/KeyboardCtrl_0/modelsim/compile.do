vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../Stepper_Motor_Full_Step.srcs/sources_1/ip/KeyboardCtrl_0/src/Ps2Interface.v" \
"../../../../Stepper_Motor_Full_Step.srcs/sources_1/ip/KeyboardCtrl_0/src/KeyboardCtrl.v" \
"../../../../Stepper_Motor_Full_Step.srcs/sources_1/ip/KeyboardCtrl_0/sim/KeyboardCtrl_0.v" \


vlog -work xil_defaultlib \
"glbl.v"


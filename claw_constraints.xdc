## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

#Buttons
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Switches
#set_property PACKAGE_PIN V17 [get_ports {direction}]
#set_property IOSTANDARD LVCMOS33 [get_ports {direction}]
#set_property PACKAGE_PIN V16 [get_ports {en}]
#   set_property IOSTANDARD LVCMOS33 [get_ports {en}]

##Pmod Header JC
##Sch name = JC1
#    set_property PACKAGE_PIN K17 [get_ports {JC[0]}]
#        set_property IOSTANDARD LVCMOS33 [get_ports {JC[0]}]
##Sch name = JC2
#set_property PACKAGE_PIN M18 [get_ports {JC[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[1]}]
##Sch name = JC3
#set_property PACKAGE_PIN N17 [get_ports {JC[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[2]}]
##Sch name = JC4
#set_property PACKAGE_PIN P18 [get_ports {JC[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[3]}]
#Sch name = JC7

#         #leds
#           set_property PACKAGE_PIN U16 [get_ports {signal_out[0]}]
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[0]}]
#           #Sch name = JC8
#           set_property PACKAGE_PIN E19 [get_ports {signal_out[1]}]
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[1]}]
#           #Sch name = JC9
#           set_property PACKAGE_PIN U19 [get_ports {signal_out[2]}]
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[2]}]
#           #Sch name = JC10
#           set_property PACKAGE_PIN V19 [get_ports {signal_out[3]}]
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[3]}]


set_property CFGBVS Vcco [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_x[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_x[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_x[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_x[0]}]
set_property PACKAGE_PIN L17 [get_ports {signal_out_x[0]}]
set_property PACKAGE_PIN M19 [get_ports {signal_out_x[1]}]
set_property PACKAGE_PIN P17 [get_ports {signal_out_x[2]}]
set_property PACKAGE_PIN R18 [get_ports {signal_out_x[3]}]
set_property PACKAGE_PIN K17 [get_ports {signal_out_y[0]}]
set_property PACKAGE_PIN M18 [get_ports {signal_out_y[1]}]
set_property PACKAGE_PIN N17 [get_ports {signal_out_y[2]}]
set_property PACKAGE_PIN P18 [get_ports {signal_out_y[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_y[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_y[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_y[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_y[0]}]

#set_property IOSTANDARD LVCMOS33 [get_ports {controll[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {controll[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {controll[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {controll[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {controll[0]}]
#set_property PACKAGE_PIN V17 [get_ports {controll[0]}]
#set_property PACKAGE_PIN V16 [get_ports {controll[1]}]
#set_property PACKAGE_PIN W16 [get_ports {controll[2]}]
#set_property PACKAGE_PIN W17 [get_ports {controll[3]}]
#set_property PACKAGE_PIN W15 [get_ports {controll[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_y2[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_y2[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_y2[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {signal_out_y2[0]}]
set_property PACKAGE_PIN G3 [get_ports {signal_out_y2[0]}]
set_property PACKAGE_PIN H2 [get_ports {signal_out_y2[1]}]
set_property PACKAGE_PIN K2 [get_ports {signal_out_y2[2]}]
set_property PACKAGE_PIN H1 [get_ports {signal_out_y2[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports PWM_z]
set_property PACKAGE_PIN C16 [get_ports PWM_z]

set_property IOSTANDARD LVCMOS33 [get_ports PS2_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports PS2_DATA]
set_property PACKAGE_PIN C17 [get_ports PS2_CLK]
set_property PACKAGE_PIN B17 [get_ports PS2_DATA]

set_property IOSTANDARD LVCMOS33 [get_ports write]
set_property IOSTANDARD LVCMOS33 [get_ports get]
set_property PACKAGE_PIN U16 [get_ports get]
set_property PACKAGE_PIN U19 [get_ports write]

set_property PACKAGE_PIN U15 [get_ports {led[0]}]
set_property PACKAGE_PIN U14 [get_ports {led[1]}]
set_property PACKAGE_PIN V14 [get_ports {led[2]}]
set_property PACKAGE_PIN V13 [get_ports {led[3]}]
set_property PACKAGE_PIN V3 [get_ports {led[4]}]
set_property PACKAGE_PIN W3 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

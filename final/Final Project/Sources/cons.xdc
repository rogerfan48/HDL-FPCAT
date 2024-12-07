## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]
create_generated_clock -name clk_25MHz -source [get_ports clk] -divide_by 4 [get_pins Clk_Div_4/num_reg[1]/Q]

# 添加時序約束
set_input_delay -clock [get_clocks sys_clk_pin] -min 1.000 [get_ports {PS2_CLK PS2_DATA}]
set_input_delay -clock [get_clocks sys_clk_pin] -max 3.000 [get_ports {PS2_CLK PS2_DATA}]
set_output_delay -clock [get_clocks sys_clk_pin] 2.000 [get_ports {vgaRed[*] vgaGreen[*] vgaBlue[*] display[*] digit[*]}]

# 添加跨時鐘域的約束
set_clock_groups -asynchronous -group [get_clocks sys_clk_pin] -group [get_clocks clk_25MHz]

# 放寬非關鍵路徑的時序要求
set_false_path -from [get_pins Seven_Segment_0/*/C] -to [get_ports display*]

## Buttons
set_property PACKAGE_PIN U17 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## LED
set_property PACKAGE_PIN L1 [get_ports {arm_LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {arm_LED[0]}]
set_property PACKAGE_PIN P1 [get_ports {arm_LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {arm_LED[1]}]
set_property PACKAGE_PIN N3 [get_ports {arm_LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {arm_LED[2]}]
set_property PACKAGE_PIN P3 [get_ports {arm_LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {arm_LED[3]}]
set_property PACKAGE_PIN U3 [get_ports {arm_LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {arm_LED[4]}]
set_property PACKAGE_PIN W3 [get_ports {arm_LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {arm_LED[5]}]
set_property PACKAGE_PIN V3 [get_ports {arm_LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {arm_LED[6]}]
set_property PACKAGE_PIN V13 [get_ports {arm_LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {arm_LED[7]}]

## 7-display
set_property PACKAGE_PIN W7 [get_ports {display[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display[0]}]
set_property PACKAGE_PIN W6 [get_ports {display[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display[1]}]
set_property PACKAGE_PIN U8 [get_ports {display[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display[2]}]
set_property PACKAGE_PIN V8 [get_ports {display[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display[3]}]
set_property PACKAGE_PIN U5 [get_ports {display[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display[4]}]
set_property PACKAGE_PIN V5 [get_ports {display[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display[5]}]
set_property PACKAGE_PIN U7 [get_ports {display[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display[6]}]

set_property PACKAGE_PIN U2 [get_ports {digit[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[0]}]
set_property PACKAGE_PIN U4 [get_ports {digit[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[1]}]
set_property PACKAGE_PIN V4 [get_ports {digit[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[2]}]
set_property PACKAGE_PIN W4 [get_ports {digit[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[3]}]

## VGA Connector
set_property PACKAGE_PIN G19 [get_ports {vgaRed[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[0]}]
set_property PACKAGE_PIN H19 [get_ports {vgaRed[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[1]}]
set_property PACKAGE_PIN J19 [get_ports {vgaRed[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[2]}]
set_property PACKAGE_PIN N19 [get_ports {vgaRed[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[3]}]
set_property PACKAGE_PIN N18 [get_ports {vgaBlue[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[0]}]
set_property PACKAGE_PIN L18 [get_ports {vgaBlue[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[1]}]
set_property PACKAGE_PIN K18 [get_ports {vgaBlue[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[2]}]
set_property PACKAGE_PIN J18 [get_ports {vgaBlue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[3]}]
set_property PACKAGE_PIN J17 [get_ports {vgaGreen[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[0]}]
set_property PACKAGE_PIN H17 [get_ports {vgaGreen[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[1]}]
set_property PACKAGE_PIN G17 [get_ports {vgaGreen[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[2]}]
set_property PACKAGE_PIN D17 [get_ports {vgaGreen[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[3]}]
set_property PACKAGE_PIN P19 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property PACKAGE_PIN R19 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]


set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## Mouse
set_property IOSTANDARD LVCMOS33 [get_ports PS2_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports PS2_DATA]
set_property PACKAGE_PIN C17 [get_ports PS2_CLK]
set_property PACKAGE_PIN B17 [get_ports PS2_DATA]
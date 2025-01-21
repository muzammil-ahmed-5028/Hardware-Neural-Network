onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /layer_2/rden_sys
add wave -noupdate -radix decimal /layer_2/wren_sys
add wave -noupdate -radix unsigned /layer_2/count_X
add wave -noupdate -radix unsigned /layer_2/count_W1
add wave -noupdate -radix decimal /layer_2/x_out
add wave -noupdate -radix decimal /layer_2/w_out
add wave -noupdate -radix decimal /layer_2/acc_out
add wave -noupdate -radix decimal /layer_2/mac_out
add wave -noupdate -radix decimal /layer_2/clk_sys
add wave -noupdate -radix decimal /layer_2/rst_sys
add wave -noupdate -radix decimal /layer_2/rst_acc
add wave -noupdate -radix unsigned /layer_2/output_ram_address
add wave -noupdate -radix decimal /layer_2/rden_output
add wave -noupdate -radix decimal /layer_2/wren_output
add wave -noupdate -radix decimal /layer_2/q_layer_2_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9657682317 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {9654849829 ps} {9671233829 ps}

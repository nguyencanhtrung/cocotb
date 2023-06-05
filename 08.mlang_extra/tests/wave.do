onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /endian_swapper_mixed/DATA_BYTES
add wave -noupdate /endian_swapper_mixed/clk
add wave -noupdate /endian_swapper_mixed/reset_n
add wave -noupdate /endian_swapper_mixed/stream_in_data
add wave -noupdate /endian_swapper_mixed/stream_in_empty
add wave -noupdate /endian_swapper_mixed/stream_in_valid
add wave -noupdate /endian_swapper_mixed/stream_in_startofpacket
add wave -noupdate /endian_swapper_mixed/stream_in_endofpacket
add wave -noupdate /endian_swapper_mixed/stream_in_ready
add wave -noupdate /endian_swapper_mixed/stream_out_data
add wave -noupdate /endian_swapper_mixed/stream_out_empty
add wave -noupdate /endian_swapper_mixed/stream_out_valid
add wave -noupdate /endian_swapper_mixed/stream_out_startofpacket
add wave -noupdate /endian_swapper_mixed/stream_out_endofpacket
add wave -noupdate /endian_swapper_mixed/stream_out_ready
add wave -noupdate /endian_swapper_mixed/csr_address
add wave -noupdate /endian_swapper_mixed/csr_readdata
add wave -noupdate /endian_swapper_mixed/csr_readdatavalid
add wave -noupdate /endian_swapper_mixed/csr_read
add wave -noupdate /endian_swapper_mixed/csr_write
add wave -noupdate /endian_swapper_mixed/csr_waitrequest
add wave -noupdate /endian_swapper_mixed/csr_writedata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {552457791004 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {3442361265 ns}

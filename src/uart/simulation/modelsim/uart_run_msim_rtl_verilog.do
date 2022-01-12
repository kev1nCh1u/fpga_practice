transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/kevin/src/fpga_practice/src/uart/nandland {/home/kevin/src/fpga_practice/src/uart/nandland/uart_tx.v}
vlog -vlog01compat -work work +incdir+/home/kevin/src/fpga_practice/src/uart {/home/kevin/src/fpga_practice/src/uart/uart.v}


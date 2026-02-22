# Makefile for cocotb UnsignedDivider unit test
TOPLEVEL_LANG = verilog
SIM ?= icarus
TOPLEVEL = UnsignedDivider
MODULE = test_divider

VERILOG_SOURCES = $(PWD)/../../../../generated_rtl/modules/UnsignedDivider.v

ifeq ($(SIM),verilator)
    EXTRA_ARGS += --trace
    COMPILE_ARGS += -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-UNOPTFLAT -Wno-UNSIGNED
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

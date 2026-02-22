# Makefile for cocotb ValuEngine unit test
TOPLEVEL_LANG = verilog
SIM ?= icarus
TOPLEVEL = ValuEngine
MODULE = test_valu

VERILOG_SOURCES = $(PWD)/../../../../generated_rtl/modules/ValuEngine.v

ifeq ($(SIM),verilator)
    EXTRA_ARGS += --trace
    COMPILE_ARGS += -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-UNOPTFLAT -Wno-UNSIGNED
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

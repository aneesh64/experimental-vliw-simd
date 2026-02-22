# Makefile for cocotb AluEngine unit test
TOPLEVEL_LANG = verilog
SIM ?= icarus
TOPLEVEL = AluEngine
MODULE = test_alu

VERILOG_SOURCES = $(PWD)/../../../../generated_rtl/modules/AluEngine.v

ifeq ($(SIM),verilator)
    EXTRA_ARGS += --trace
    COMPILE_ARGS += -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-UNOPTFLAT -Wno-UNSIGNED
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

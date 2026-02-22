# Makefile for cocotb BankedScratchMemory unit test
TOPLEVEL_LANG = verilog
SIM ?= icarus
TOPLEVEL = BankedScratchMemory
MODULE = test_scratch

VERILOG_SOURCES = $(PWD)/../../../../generated_rtl/modules/BankedScratchMemory.v

ifeq ($(SIM),verilator)
    EXTRA_ARGS += --trace
    COMPILE_ARGS += -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-UNOPTFLAT -Wno-UNSIGNED
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

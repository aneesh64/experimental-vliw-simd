# Makefile for cocotb MemoryEngine unit test
TOPLEVEL_LANG = verilog
SIM ?= icarus
TOPLEVEL = MemoryEngine
MODULE = test_mem

VERILOG_SOURCES = $(PWD)/../../../../generated_rtl/modules/MemoryEngine.v

ifeq ($(SIM),verilator)
    EXTRA_ARGS += --trace
    COMPILE_ARGS += -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-UNOPTFLAT -Wno-UNSIGNED
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

# Makefile for cocotb FlowEngine unit test
TOPLEVEL_LANG = verilog
SIM ?= icarus
TOPLEVEL = FlowEngine
MODULE = test_flow

VERILOG_SOURCES = $(PWD)/../../../../generated_rtl/modules/FlowEngine.v

ifeq ($(SIM),verilator)
    EXTRA_ARGS += --trace
    COMPILE_ARGS += -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-UNOPTFLAT -Wno-UNSIGNED
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

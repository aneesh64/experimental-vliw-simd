# Makefile for cocotb VliwCore integration test
TOPLEVEL_LANG = verilog
SIM ?= icarus
TOPLEVEL = VliwCore
MODULE = test_core

VERILOG_SOURCES = $(PWD)/../../../../generated_rtl/modules/VliwCore.v

ifeq ($(SIM),verilator)
    EXTRA_ARGS += --trace
    COMPILE_ARGS += -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-UNOPTFLAT -Wno-UNSIGNED
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

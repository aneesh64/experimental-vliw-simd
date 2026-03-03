"""VLIW SIMD integration test package.

Module map
==========

Compatibility aggregate modules:
	- test_integration
	- test_algorithms

Grouped integration domains:
	- test_integration_scalar
	- test_integration_memory
	- test_integration_control
	- test_integration_vector

Grouped algorithm domains:
	- test_algorithms_kernels
	- test_algorithms_multiwidth

Shared helpers:
	- test_integration_common
	- test_algorithms_common

Runner examples:
	python verification/cocotb/integration/run_integration.py --modules test_integration
	python verification/cocotb/integration/run_integration.py --modules test_integration_scalar
	python verification/cocotb/integration/run_integration.py --modules test_algorithms_multiwidth
"""

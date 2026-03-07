# DSL Developer Guide

This guide is for developers extending the VLIW SIMD Python DSL itself.

## Purpose

Use this document when you are:
- adding a new builder helper
- extending lowering behavior
- introducing a new example kernel
- adding scheduler or assembler-facing DSL features
- updating RTL-backed DSL regression coverage

## Recommended reading order

1. [docs/DSL.md](DSL.md)
2. [docs/DSL_QUICKSTART.md](DSL_QUICKSTART.md)
3. [docs/DSL_TUTORIAL_SCALAR.md](DSL_TUTORIAL_SCALAR.md)
4. [docs/DSL_TUTORIAL_TENSOR.md](DSL_TUTORIAL_TENSOR.md)
5. [docs/DSL_TILEWEAVE_GUIDE.md](DSL_TILEWEAVE_GUIDE.md)
6. [docs/DSL_PROGRAMMING_GUIDE.md](DSL_PROGRAMMING_GUIDE.md)
7. [docs/DSL_SOFTWARE_PIPELINING.md](DSL_SOFTWARE_PIPELINING.md)
8. [docs/DSL_RTL_VERIFICATION_PLAN.md](DSL_RTL_VERIFICATION_PLAN.md)

## Source layout

Core DSL files:
- [tools/dsl/builder.py](../tools/dsl/builder.py)
- [tools/dsl/ir.py](../tools/dsl/ir.py)
- [tools/dsl/lowering.py](../tools/dsl/lowering.py)
- [tools/dsl/layout.py](../tools/dsl/layout.py)
- [tools/dsl/graph.py](../tools/dsl/graph.py)
- [tools/dsl/capabilities.py](../tools/dsl/capabilities.py)
- [tools/dsl/manifest.py](../tools/dsl/manifest.py)
- [tools/dsl/tileweave.py](../tools/dsl/tileweave.py)

Examples:
- [tools/dsl/examples/box_blur_3x3.py](../tools/dsl/examples/box_blur_3x3.py)
- [tools/dsl/examples/pipelined_vector_add.py](../tools/dsl/examples/pipelined_vector_add.py)
- [tools/dsl/examples/control_flow_kernels.py](../tools/dsl/examples/control_flow_kernels.py)

Verification:
- [tools/tests/test_dsl_helpers.py](../tools/tests/test_dsl_helpers.py)
- [tools/tests/test_dsl_examples.py](../tools/tests/test_dsl_examples.py)
- [tools/tests/test_dsl_flow_and_graph.py](../tools/tests/test_dsl_flow_and_graph.py)
- [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py)
- [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py)
- [verification/cocotb/integration/test_dsl_algorithms_integration.py](../verification/cocotb/integration/test_dsl_algorithms_integration.py)

## Mental model

The DSL stack is:
1. developer-facing builder helpers
2. logical IR in `Kernel` + ops
3. capability-aware lowering
4. scheduler bundle generation
5. assembler binary emission
6. RTL execution and golden checking

When adding a feature, keep all six levels in mind.

## How to add a DSL feature

### 1. Decide the abstraction level

Prefer the highest stable abstraction that still maps clearly to the backend.

Examples:
- low level: `vector_binary()`
- ergonomic helper: `vector_map()`
- staged helper: `software_pipeline_binary()`
- full worked example: box blur or tiled vector kernels

### 2. Add builder surface area

Modify [tools/dsl/builder.py](../tools/dsl/builder.py).

Guidelines:
- keep helpers composable
- keep naming explicit and action-oriented
- prefer simple wrappers before inventing new IR nodes
- only add new IR nodes when the builder can no longer express the feature cleanly

### 3. Update lowering only when required

If the feature is expressible using existing IR ops, do not expand lowering unnecessarily.

Modify [tools/dsl/lowering.py](../tools/dsl/lowering.py) only when:
- a new op type is needed
- new validation is required
- bindings or scratch rules must change

### 4. Add unit tests first

Expected test layers:
- builder helper behavior
- lowering shape or manifest behavior
- example compile coverage

Typical files:
- [tools/tests/test_dsl_helpers.py](../tools/tests/test_dsl_helpers.py)
- [tools/tests/test_dsl_lowering.py](../tools/tests/test_dsl_lowering.py)
- [tools/tests/test_dsl_examples.py](../tools/tests/test_dsl_examples.py)

### 5. Add RTL smoke coverage

Add at least one golden RTL test for developer-facing functionality.

Preferred homes:
- small helper kernels: [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py)
- larger worked examples: [verification/cocotb/integration/test_dsl_algorithms_integration.py](../verification/cocotb/integration/test_dsl_algorithms_integration.py)

### 6. Update docs

At minimum update:
- [docs/DSL.md](DSL.md)
- one tutorial or example doc
- [docs/DSL_RTL_VERIFICATION_PLAN.md](DSL_RTL_VERIFICATION_PLAN.md) when coverage status changes

## Design guidance

### Prefer wrappers over new op types

Use builder wrappers when the backend pattern already exists.

Examples:
- `vector_fill()` wraps `vbroadcast()`
- `vector_copy()` wraps `vcast()`
- `pipelined_vector_map()` wraps `software_pipeline_binary()`

### Make developer intent obvious

A good helper should communicate:
- data movement intent
- compute intent
- tiling intent
- whether the pattern is staged or scalarized

### Keep conservative RTL paths

If a more aggressive form is not yet stable in RTL:
- keep the expressive API
- validate a conservative configuration in RTL
- cover the more aggressive form with unit or lowering tests

This is the current approach for software-pipelined tiled kernels.

## Software-pipelining guidance

Current staged abstraction:
- `software_pipeline_binary()`

Recommended usage:
- keep tiles beat-aligned when practical
- start with `unroll=1` for RTL-backed smoke tests
- use larger `unroll` values first in lowering or bundle-count tests

Good first staged kernels:
- tiled add
- tiled mul
- bias add with broadcast stage

## Verification workflow

### Fast local checks

1. run focused unit tests
2. run the affected DSL RTL module with `--no-rtl`

### Broader checks

When changing scheduler/assembler/RTL-facing behavior, also run:
- [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py)
- [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py)
- [verification/cocotb/integration/test_dsl_algorithms_integration.py](../verification/cocotb/integration/test_dsl_algorithms_integration.py)

## Documentation map

Use these documents by audience:
- overview: [docs/DSL.md](DSL.md)
- first use: [docs/DSL_QUICKSTART.md](DSL_QUICKSTART.md)
- practical authoring: [docs/DSL_PROGRAMMING_GUIDE.md](DSL_PROGRAMMING_GUIDE.md)
- high-level TileWeave frontend: [docs/DSL_TILEWEAVE_GUIDE.md](DSL_TILEWEAVE_GUIDE.md)
- scalar authoring: [docs/DSL_TUTORIAL_SCALAR.md](DSL_TUTORIAL_SCALAR.md)
- tensor/vector authoring: [docs/DSL_TUTORIAL_TENSOR.md](DSL_TUTORIAL_TENSOR.md)
- staged kernels: [docs/DSL_SOFTWARE_PIPELINING.md](DSL_SOFTWARE_PIPELINING.md)
- worked blur example: [docs/DSL_EXAMPLE_BOX_BLUR_3X3.md](DSL_EXAMPLE_BOX_BLUR_3X3.md)
- control-flow example: [docs/DSL_EXAMPLE_CONTROL_FLOW.md](DSL_EXAMPLE_CONTROL_FLOW.md)
- verification strategy: [docs/DSL_RTL_VERIFICATION_PLAN.md](DSL_RTL_VERIFICATION_PLAN.md)

## Definition of done for a DSL feature

A feature is ready when:
- builder API is stable enough to document
- unit coverage exists
- RTL golden coverage exists or a conservative RTL path is documented
- docs are linked from the DSL overview
- the feature is reflected in the verification plan when relevant

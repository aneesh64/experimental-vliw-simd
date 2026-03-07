# DSL RTL Verification Plan

## Status

Current DSL RTL-backed coverage already exists, but it is still narrow.

Currently verified modules:
- [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py)
- [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py)

Currently verified kernel shapes:
- scalar symbolic DMEM load/compute/store
- scalar symbolic DMEM load/compute/store under randomized AXI read latency
- scalar counting loop
- core-aware `coreid()` offset-store smoke kernel
- vector broadcast with symbolic DMEM binding
- helper-driven vector fill with lane stores
- helper-driven `vector_map("add", ...)` using scalar-fed vectors
- helper-driven packed-8-bit `vector_map("xor", ...)`
- helper-driven packed-16-bit `vector_map("sub", ...)`
- helper-driven symbolic DMEM `vload_view -> vector_map -> vstore_view`
- helper-driven symbolic DMEM `vector_copy()`
- helper-driven symbolic DMEM `vcast(32->8)`
- helper-driven symbolic DMEM `vcast(8->16)`
- helper-driven symbolic DMEM signed `vcast(8->32)`
- helper-driven symbolic DMEM `vector_map("mul")`
- fixed-shape 3x3 box blur for one output pixel
- looped 3x3 row blur over a 3x5 patch
- small full-image 3x3 blur over a 4x4 patch with nested loops
- software-pipelined fused DSP gain-monitor kernel with vector output, scalar probes, and metadata sideband
- software-pipelined fused DSP dual-output kernel with gain/bias vector outputs, scalar probes, and metadata sideband
- software-pipelined tiled vector add with beat-aligned tiles and RTL-backed conservative configuration

This plan expands coverage so DSL, scheduler, assembler, and RTL failures are caught earlier.

## Goal

Build a correctness-first RTL verification program for DSL kernels that:
- exercises every stable DSL feature with golden outputs
- catches frontend/backend mismatches early
- catches scheduler hazard issues under realistic kernels
- catches assembler encoding issues before software integration
- provides a clear promotion path from new DSL feature to regression coverage

## Principles

1. Every new DSL surface area should ship with RTL-backed coverage when practical.
2. Kernel verification should use Python golden models, not manual inspection.
3. Small smoke kernels should land first; larger algorithm kernels should follow.
4. RTL tests should be grouped by feature area so failures are easy to triage.
5. DSL regressions should be runnable independently from the broader RTL suite.
6. Scheduler and assembler changes should automatically re-run DSL RTL modules.

## Verification Layers

### Layer 0: Builder and lowering unit tests
Purpose:
- validate IR construction
- validate bindings and scratch allocation
- validate lowering shape and manifest content

Existing examples:
- [tools/tests/test_dsl_helpers.py](../tools/tests/test_dsl_helpers.py)
- [tools/tests/test_dsl_lowering.py](../tools/tests/test_dsl_lowering.py)
- [tools/tests/test_dsl_flow_and_graph.py](../tools/tests/test_dsl_flow_and_graph.py)

### Layer 1: RTL smoke kernels
Purpose:
- one short golden test per DSL feature
- low runtime, high signal

Existing examples:
- [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py)
- [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py)

### Layer 2: RTL feature kernels
Purpose:
- combine multiple DSL features in one kernel
- use symbolic DMEM inputs and outputs
- validate realistic hazard patterns

### Layer 3: RTL algorithm kernels
Purpose:
- larger end-to-end kernels
- vectorized loops and tiled memory movement
- stronger schedule pressure and backend coverage

## Required RTL Coverage Matrix

Each feature below should eventually have at least one golden RTL kernel.

| Feature area | Current state | Required RTL target |
|---|---|---|
| Scalar constants/load/store | Partial | 2-3 smoke kernels |
| Scalar arithmetic and compares | Partial | scalar ALU matrix |
| Control flow (`label`, `jump`, `cond_jump`) | Partial | loop + branch edge cases |
| Scalar arguments / DMEM bindings | Partial | pointer and offset kernels |
| Vector broadcast / cast / copy | Partial | widen/narrow coverage beyond current `32->8`, `8->16`, `8->32` smoke kernels |
| `vector_map()` arithmetic | Partial | add/sub/mul/xor kernels across more widths and mixed scheduling shapes |
| `vload_view()` / `vstore_view()` | Partial | aligned and offset tiles |
| Lane alias / `store_lane()` | Partial | lane 0, middle, last |
| Multiwidth element ops | Partial | broaden beyond current packed `U8` xor, packed `U16` sub, and widening-cast smoke kernels |
| Multi-kernel graph compilation | Compile-time only | compile validation + packaged examples |
| Core-aware kernels (`coreid`) | Covered in single-core baseline | per-core address offset smoke kernel |
| Stress latency / backpressure | Partial | selected kernels under AXI stress |

## Immediate Execution Plan

### Phase 1: Close DSL smoke-kernel gaps
Add RTL kernels for:
1. scalar load/transform/store with symbolic bindings
2. control-flow loop with DMEM input and output
3. `vector_copy()` golden kernel
4. `vcast()` width-conversion kernel
5. `vector_map()` variants for `sub`, `mul`, and `xor`
6. `store_lane()` for non-edge lanes
7. `coreid()`-based per-core address selection

Exit criteria:
- every currently exposed helper in [tools/dsl/builder.py](../tools/dsl/builder.py) has at least one RTL-backed golden kernel or an explicit documented exception

### Phase 2: Add combined feature kernels
Add kernels that mix:
- view loads
- vector compute
- scalar epilogues
- loop control
- symbolic output buffers

Recommended kernels:
1. vector SAXPY-style kernel with scalar coefficient broadcast
2. tiled copy-plus-bias kernel
3. vector reduction epilogue using lane stores
4. counted loop over two vector tiles

Exit criteria:
- DSL kernels exercise mixed ALU, VALU, LOAD, STORE, and FLOW engines in the same regression set

### Phase 3: Add backend stress coverage
Run selected DSL kernels under:
- AXI latency sequences
- AXI stress mode
- multiple slot configurations
- rebuilt RTL after source changes

Recommended candidates:
- one scalar loop kernel
- one helper vector-map kernel
- one symbolic `vload_view -> vstore_view` kernel

Exit criteria:
- at least one DSL smoke module runs under latency stress and one alternate slot configuration in regression

### Phase 4: Promote algorithm kernels
Build larger DSL kernels with full golden outputs:
- vector bias add
- vector threshold / mask
- tiled reduction
- image or signal-processing kernel once helper layer is richer

Exit criteria:
- at least two nontrivial DSL kernels run in normal regression and publish cycle metrics

## Test Organization Plan

Recommended module layout:
- keep short smoke coverage in [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py)
- keep helper-specific coverage in [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py)
- add future larger kernels in a new module such as `test_dsl_algorithms_integration.py`
- keep graph tests unit-level until a runtime launcher exists

Naming rules:
- `test_dsl_<feature>_golden`
- docstring states feature and expected behavior
- each test logs cycle count

## Golden Model Rules

Each RTL kernel should have:
- deterministic inputs
- explicit golden outputs in Python
- exact word-by-word comparison
- a short error message containing lane or index

Preferred golden patterns:
- list comprehensions for vector kernels
- helper functions for reusable arithmetic
- no hidden constants in assertions

## Regression Gates

### Gate A: Per-change DSL gate
Run when changing:
- [tools/dsl](../tools/dsl)
- [tools/scheduler.py](../tools/scheduler.py)
- [tools/assembler.py](../tools/assembler.py)
- [verification/cocotb/integration/test_dsl_*.py](../verification/cocotb/integration)

Commands:
- unit DSL tests
- DSL RTL smoke modules with `--no-rtl` when RTL is unchanged
- DSL RTL smoke modules with auto RTL rebuild when RTL-related sources changed

### Gate B: Pre-merge backend gate
Run when changing RTL, scheduler, assembler, or config:
- all DSL unit tests
- all DSL RTL modules
- one stress-latency DSL module
- one alternate-slot DSL run

### Gate C: Periodic full regression
Run nightly or before milestone tags:
- full integration suite
- full DSL RTL suite
- recorded metrics summary for DSL kernels

## Ownership Checklist For New DSL Features

When adding a new DSL feature:
1. add builder/lowering unit tests
2. add one RTL smoke kernel with golden values
3. add docs or tutorial snippet
4. add the feature to the verification matrix in this document
5. only then promote the feature as supported in [docs/DSL.md](DSL.md)

## Metrics To Track

Per kernel:
- pass/fail
- cycle count
- module name
- feature area
- whether RTL was rebuilt
- whether run used stress latency or alternate config

Recommended future summary fields:
- median cycles across repeated runs for stable smoke kernels
- coverage tags such as `scalar`, `vector`, `view`, `control`, `multiwidth`

## Failure Triage Guide

If a DSL RTL test fails:
1. rerun corresponding unit tests for builder/lowering
2. inspect lowered ops and bindings
3. compare scheduled bundles against expected engine usage
4. isolate whether failure is frontend, scheduler, assembler, or RTL
5. minimize to the smallest golden kernel before changing backend logic

## Proposed Near-Term Backlog

Highest priority:
1. alternate-slot rerun of current DSL helper kernels
2. multiwidth `vector_map()` RTL kernels beyond current `8-bit xor`, `16-bit subtract`, and `32-bit multiply`
3. widening `vcast()` RTL kernels beyond current `32->8`, `8->16`, and signed `8->32`
4. mixed control-flow plus vector tile kernel with runtime trip count
5. stress-latency rerun of additional DSL kernels beyond scalar smoke

## Definition of Done For DSL Verification

The DSL verification program is in good shape when:
- every public builder helper has unit coverage
- every public builder helper has RTL coverage or documented rationale
- DSL RTL tests are called out as a required regression gate
- larger algorithm kernels exist in addition to smoke kernels
- docs clearly explain how to run the DSL RTL suite

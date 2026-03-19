# DSL Example: Matrix Matmul

This example documents the current high-level `KernelBuilder.matmul()` path for the matrix engine.

## Goal

Express a fixed-size matrix multiplication in the Python DSL without manually authoring matrix scheduler ops.

Current supported kernel shape:
- left-hand side tile: `8x8` `U8`
- right-hand side tile: `8x8` `U8`
- output tile: `8x8` `U32`

The current lowering targets the repository's v1 matrix engine, which is a fixed `8x8` int8-input, int32-accumulate path.

## Source

- Builder examples: [tools/dsl/examples/matrix_kernels.py](../tools/dsl/examples/matrix_kernels.py)
- Builder API: [tools/dsl/builder.py](../tools/dsl/builder.py)
- Lowering logic: [tools/dsl/lowering.py](../tools/dsl/lowering.py)
- Compile/lowering tests: [tools/tests/test_dsl_lowering.py](../tools/tests/test_dsl_lowering.py)
- Example compilation tests: [tools/tests/test_dsl_examples.py](../tools/tests/test_dsl_examples.py)
- RTL integration tests: [verification/cocotb/integration/test_dsl_matrix_integration.py](../verification/cocotb/integration/test_dsl_matrix_integration.py)

## Why this example matters

It gives the DSL a first-class matrix operation instead of forcing users to hand-author:
- `MDMVIN` for operand A
- `MDMVIN` for operand B
- `MZERO` when starting a fresh output tile
- `MCOMPUTE` or `MCOMPUTE_ACC`
- `MDMVOUT` for the output tile

That keeps the public DSL surface compact while still lowering into the existing scheduler and assembler toolchain.

## Basic kernel

```python
from dsl import KernelBuilder, U8, U32


kb = KernelBuilder("matrix_matmul_8x8")
lhs = kb.arg_dmem_tensor("lhs", shape=(8, 8), dtype=U8)
rhs = kb.arg_dmem_tensor("rhs", shape=(8, 8), dtype=U8)
out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

kb.matmul(lhs, rhs, out)
kb.halt()

kernel = kb.build()
```

What this means semantically:

$$
out = lhs \times rhs
$$

The builder call does not expose matrix-local scratch addresses. Those are currently fixed inside lowering for the v1 engine contract.

## Accumulate variant

The current API also supports accumulation into the same output tile.

```python
from dsl import KernelBuilder, U8, U32


kb = KernelBuilder("matrix_matmul_accumulate_8x8")
lhs0 = kb.arg_dmem_tensor("lhs0", shape=(8, 8), dtype=U8)
rhs0 = kb.arg_dmem_tensor("rhs0", shape=(8, 8), dtype=U8)
lhs1 = kb.arg_dmem_tensor("lhs1", shape=(8, 8), dtype=U8)
rhs1 = kb.arg_dmem_tensor("rhs1", shape=(8, 8), dtype=U8)
out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

kb.matmul(lhs0, rhs0, out)
kb.matmul(lhs1, rhs1, out, accumulate=True)
kb.halt()

kernel = kb.build()
```

Semantically:

$$
out = (lhs0 \times rhs0) + (lhs1 \times rhs1)
$$

The first call emits a fresh compute path with accumulator clear. The second call emits an accumulate compute path and reuses the existing accumulator contents.

## Lowering contract

Today `KernelBuilder.matmul()` lowers into the following matrix-op sequence:

### Non-accumulating `matmul(lhs, rhs, out)`

1. `MDMVIN` operand A from `lhs`
2. `MDMVIN` operand B from `rhs`
3. `MZERO`
4. `MCOMPUTE`
5. `MDMVOUT` to `out`

### Accumulating `matmul(..., accumulate=True)`

1. `MDMVIN` operand A from `lhs`
2. `MDMVIN` operand B from `rhs`
3. `MCOMPUTE_ACC`
4. `MDMVOUT` to `out`

The verified direct-transfer details are:
- operand A load uses `flags=0`
- operand B load uses `flags=0b10`
- output store uses `flags=0b1`

Those details are an implementation contract of the current backend, not part of the high-level DSL API users need to write directly.

## Capability requirements

This path only lowers on targets that expose at least one matrix slot.

Typical compile pattern:

```python
from assembler import AssemblerConfig
from dsl import HardwareCapabilities, compile_kernel
from scheduler import SchedulerConfig


caps = HardwareCapabilities.from_configs(
    scheduler_config=SchedulerConfig(n_matrix_slots=1),
    assembler_config=AssemblerConfig(n_matrix_slots=1),
)

result = compile_kernel(
    kernel,
    caps,
    bindings={"lhs": 0, "rhs": 16, "out": 32},
    assemble=True,
)
```

If `n_matrix_slots == 0`, lowering fails intentionally rather than silently falling back to scalar code.

## Current constraints

This is a correctness-first first slice, not a general matrix algebra frontend. Important current limits:
- only `8x8` tiles are supported
- inputs must be DMEM-backed `U8` tensors
- outputs must be DMEM-backed `U32` tensors
- lowering is specialized to one matrix engine slot
- larger matrices must currently be expressed as explicit tiled composition over tile-packed DMEM buffers
- there is no generic broadcasting, transposition, or batched matmul DSL yet

For a documented larger example, see [DSL_EXAMPLE_MATRIX_MATMUL_32X32.md](DSL_EXAMPLE_MATRIX_MATMUL_32X32.md).

## Verification coverage

The current stack validates this path at multiple levels:
- compile-only example coverage for the public builders
- lowering coverage for emitted matrix op sequences
- RTL-backed golden tests for basic matmul and accumulate matmul
- mixed-engine RTL tests where matrix ops interact with ALU and VALU bundles
- a matrix-transfer stall regression proving unrelated bundles can proceed during an inbound matrix load

## Related reading

- [DSL.md](DSL.md)
- [DSL_PROGRAMMING_GUIDE.md](DSL_PROGRAMMING_GUIDE.md)
- [DSL_EXAMPLE_MATRIX_MATMUL_32X32.md](DSL_EXAMPLE_MATRIX_MATMUL_32X32.md)
- [DSL_TUTORIAL_TENSOR.md](DSL_TUTORIAL_TENSOR.md)
# DSL Tutorial: Tensor and Vector Helpers

This tutorial covers the current higher-level helper layer for vector kernels.

## Goal

Build a symbolic DMEM vector kernel that:
- loads two vectors from DMEM
- adds them with `vector_map()`
- stores the result back with `vstore_view()`

## Step 1: Imports

```python
from tools.dsl import HardwareCapabilities, KernelBuilder, U32, compile_kernel
from tools.dsl.layout import tile_1d
```

## Step 2: Define symbolic buffers and scratch vectors

```python
kb = KernelBuilder("helper_vload_vstore_add")
lhs_buf = kb.arg_dmem_tensor("lhs", shape=(8,), dtype=U32)
rhs_buf = kb.arg_dmem_tensor("rhs", shape=(8,), dtype=U32)
out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U32)

lhs_vec = kb.vector("lhs_vec", dtype=U32, scratch_base=320)
rhs_vec = kb.vector("rhs_vec", dtype=U32, scratch_base=328)
out_vec = kb.vector("out_vec", dtype=U32, scratch_base=336)
```

Explicit `scratch_base` values are useful when you also want lane aliases or predictable layout during debugging.

## Step 3: Use TensorView helpers

```python
kb.vload_view(lhs_vec, tile_1d(lhs_buf, length=8), addr_name="lhs_ptr")
kb.vload_view(rhs_vec, tile_1d(rhs_buf, length=8), addr_name="rhs_ptr")
kb.vector_map("add", out_vec, lhs_vec, rhs_vec, ew=32)
kb.vstore_view(tile_1d(out_buf, length=8), out_vec, addr_name="out_ptr")
kb.halt()
```

Helper meanings:
- `vload_view()` materializes an address for a `TensorView` and emits `vload()`.
- `vector_map()` is the helper alias for `vector_binary()`.
- `vstore_view()` materializes an address for a `TensorView` and emits `vstore()`.

The same helper surface also supports multiwidth kernels. For example:

```python
kb.vector_map("xor", out_vec, lhs_vec, rhs_vec, ew=8)
kb.vector_map("sub", out_vec, lhs_vec, rhs_vec, ew=16)
kb.vcast(wide_vec, narrow_vec, ew=8, dw=16, signed=0, upper=0)
kb.vcast(wide32_vec, narrow_vec, ew=8, dw=32, signed=1, upper=0)
```

These forms are now covered by RTL-backed helper tests, including packed `8-bit xor`, packed `16-bit sub`, unsigned `8->16`, and signed `8->32` widening casts.

## Step 4: Compile with symbolic bindings

```python
caps = HardwareCapabilities.from_configs()
result = compile_kernel(
    kb.build(),
    caps,
    bindings={"lhs": 96, "rhs": 104, "out": 112},
    assemble=True,
)
```

At compile time:
- `lhs`, `rhs`, and `out` become concrete DMEM base addresses.
- the scheduler still handles hazard avoidance and bundle packing.

## Lane helpers

For kernels that only commit selected lanes:

```python
kb.vector_fill(out_vec, scalar_value, ew=32)
kb.store_lane(out_ptr, out_vec, 0)
kb.add_imm(out_ptr, out_ptr, 1)
kb.store_lane(out_ptr, out_vec, 7, alias_name="out_vec_last")
```

This is useful for scalarized inspection, reduction epilogues, and simple golden checks.

## Multi-kernel graph sketch

The current graph layer compiles multiple kernels and launch metadata:

```python
graph = KernelGraph("pipeline")
graph.add_kernel("loader", loader_kernel, launch=LaunchSpec.single(0), bindings={"src": 64, "tmp": 96})
graph.add_kernel("consumer", consumer_kernel, launch=LaunchSpec.explicit(1), bindings={"tmp": 96, "out": 128})
graph.add_dependency("loader", "consumer", via=("tmp", "tmp"))
compiled = GraphCompiler(caps).compile(graph, assemble=False)
```

This is currently compile-time orchestration metadata rather than a runtime executor.

## Validation references

See:
- [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py)
- [tools/tests/test_dsl_flow_and_graph.py](../tools/tests/test_dsl_flow_and_graph.py)

## Related docs

- [docs/DSL.md](DSL.md)
- [docs/DSL_QUICKSTART.md](DSL_QUICKSTART.md)
- [docs/DSL_SOFTWARE_PIPELINING.md](DSL_SOFTWARE_PIPELINING.md)
- [docs/TOOLCHAIN.md](TOOLCHAIN.md)

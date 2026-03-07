# DSL Quickstart

This quickstart shows the current shape of the Python DSL and the end-to-end compile flow.

## Imports

```python
from tools.dsl import HardwareCapabilities, KernelBuilder, U32, compile_kernel
```

## Example 1: Scalar counting loop

```python
kb = KernelBuilder("count_loop")
counter = kb.scalar("counter")
limit = kb.arg_scalar("limit", default=5)
one = kb.scalar("one")
cond = kb.scalar("cond")
out_ptr = kb.scalar("out_ptr")
out_buf = kb.arg_dmem_tensor("out", shape=(1,), dtype=U32)

kb.const(counter, 0)
kb.const(one, 1)
kb.label("loop")
kb.add(counter, counter, one)
kb.binary("lt", cond, counter, limit)
kb.cond_jump(cond, "loop")
kb.address_of(out_ptr, out_buf)
kb.store(out_ptr, counter)
kb.halt()

caps = HardwareCapabilities.from_configs()
result = compile_kernel(
    kb.build(),
    caps,
    bindings={"out": 1200},
    assemble=True,
)
```

What happens:
- `limit` is resolved as a scalar argument with default value 5
- `out` is a symbolic DMEM binding resolved to word address 1200
- the DSL lowers to scheduler ops and then to binary bundles

Useful outputs:
- `result.scratch_map`
- `result.required_bindings`
- `result.resolved_bindings`
- `result.scheduled_bundles`
- `result.binary_bundles`
- `result.to_manifest()`

## Example 2: Vector broadcast with symbolic output binding

```python
from tools.dsl import U8
from tools.dsl.layout import tile_1d

kb = KernelBuilder("vbroadcast")
out_buf = kb.arg_dmem_tensor("out", shape=(2,), dtype=U32)
scalar_value = kb.arg_scalar("scalar_value", default=10)
out_ptr = kb.scalar("out_ptr")
vec = kb.vector("vec", dtype=U8, scratch_base=340)
vec_last = kb.scalar("vec_last", scratch_base=347)

out_tile = tile_1d(out_buf, length=2, start=0)
kb.address_of_view(out_ptr, out_tile)
kb.vbroadcast(vec, scalar_value, ew=32)
kb.store(out_ptr, vec)
kb.add_imm(out_ptr, out_ptr, 1)
kb.store(out_ptr, vec_last)
kb.halt()

caps = HardwareCapabilities.from_configs()
result = compile_kernel(
    kb.build(),
    caps,
    bindings={"out": 32, "scalar_value": 10},
    assemble=True,
)
```

## Example 3: Multi-kernel graph

```python
from tools.dsl import GraphCompiler, KernelGraph, LaunchSpec

graph = KernelGraph("pipeline")
graph.add_kernel("producer", producer_kernel, launch=LaunchSpec.single(0), bindings={"value": 3})
graph.add_kernel("consumer", consumer_kernel, launch=LaunchSpec.replicated())
graph.add_dependency("producer", "consumer", via=("value", "value"))

compiled = GraphCompiler(caps).compile(graph, assemble=False)
manifest = compiled.to_manifest()
```

## Example 4: Helper-style vector fill and lane stores

```python
from tools.dsl import U8

kb = KernelBuilder("helper_fill")
scalar_value = kb.arg_scalar("scalar_value", default=21)
out_buf = kb.arg_dmem_tensor("out", shape=(2,), dtype=U32)
out_ptr = kb.scalar("out_ptr")
vec = kb.vector("vec", dtype=U8, scratch_base=340)

kb.address_of(out_ptr, out_buf)
kb.vector_fill(vec, scalar_value, ew=32)
kb.store_lane(out_ptr, vec, 0)
kb.add_imm(out_ptr, out_ptr, 1)
kb.store_lane(out_ptr, vec, 7, alias_name="vec_last")
kb.halt()
```

This pattern is useful when a kernel needs a vector temporary but only commits selected lanes back to DMEM.

## Example 5: Helper-style vector map

```python
kb = KernelBuilder("helper_map_add")
lhs_scalar = kb.arg_scalar("lhs_scalar", default=7)
rhs_scalar = kb.arg_scalar("rhs_scalar", default=11)
out_buf = kb.arg_dmem_tensor("out", shape=(2,), dtype=U32)
out_ptr = kb.scalar("out_ptr")
lhs_vec = kb.vector("lhs_vec", dtype=U32, scratch_base=320)
rhs_vec = kb.vector("rhs_vec", dtype=U32, scratch_base=328)
out_vec = kb.vector("out_vec", dtype=U32, scratch_base=336)

kb.address_of(out_ptr, out_buf)
kb.vector_fill(lhs_vec, lhs_scalar, ew=32)
kb.vector_fill(rhs_vec, rhs_scalar, ew=32)
kb.vector_map("add", out_vec, lhs_vec, rhs_vec, ew=32)
kb.store_lane(out_ptr, out_vec, 0)
kb.add_imm(out_ptr, out_ptr, 1)
kb.store_lane(out_ptr, out_vec, 7, alias_name="out_vec_last")
kb.halt()
```

This is the current helper-layer shape for elementwise vector compute without dropping down to raw `vector_binary()` calls.

## Example 6: TensorView vector load and store helpers

```python
from tools.dsl.layout import tile_1d

kb = KernelBuilder("helper_vload_vstore_add")
lhs_buf = kb.arg_dmem_tensor("lhs", shape=(8,), dtype=U32)
rhs_buf = kb.arg_dmem_tensor("rhs", shape=(8,), dtype=U32)
out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U32)
lhs_vec = kb.vector("lhs_vec", dtype=U32, scratch_base=320)
rhs_vec = kb.vector("rhs_vec", dtype=U32, scratch_base=328)
out_vec = kb.vector("out_vec", dtype=U32, scratch_base=336)

kb.vload_view(lhs_vec, tile_1d(lhs_buf, length=8), addr_name="lhs_ptr")
kb.vload_view(rhs_vec, tile_1d(rhs_buf, length=8), addr_name="rhs_ptr")
kb.vector_map("add", out_vec, lhs_vec, rhs_vec, ew=32)
kb.vstore_view(tile_1d(out_buf, length=8), out_vec, addr_name="out_ptr")
kb.halt()
```

This is the current highest-level path for symbolic DMEM vector inputs and outputs while still targeting the existing scheduler and assembler backend.

## Example 7: Scalar symbolic load/compute/store

```python
kb = KernelBuilder("scalar_symbolic_load_store")
in_buf = kb.arg_dmem_tensor("in_buf", shape=(1,), dtype=U32)
out_buf = kb.arg_dmem_tensor("out_buf", shape=(1,), dtype=U32)
bias = kb.arg_scalar("bias", default=5)
in_ptr = kb.scalar("in_ptr")
out_ptr = kb.scalar("out_ptr")
value = kb.scalar("value")
acc = kb.scalar("acc")

kb.address_of(in_ptr, in_buf)
kb.load(value, in_ptr)
kb.add(acc, value, bias)
kb.address_of(out_ptr, out_buf)
kb.store(out_ptr, acc)
kb.halt()
```

This is the smallest end-to-end symbolic DMEM scalar kernel shape and is a good default smoke test when changing the DSL, scheduler, assembler, or RTL.

## Unit tests

The current DSL unit coverage lives under [tools/tests](../tools/tests).

## RTL-backed verification

The current DSL kernels are verified in [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py) and [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py).

Typical checks:
- compile DSL kernel
- load binary bundles into IMEM
- run the RTL through cocotb
- compare DMEM results against Python golden values

## Current limits

The current implementation is intentionally narrow:
- vectors are expected to match full target `vlen`
- layouts are mostly 1D for now
- tensor algebra helpers are still minimal
- graph compilation does not yet include a full runtime launcher

## Recommended next read

- [docs/DSL.md](DSL.md)
- [docs/DSL_PROGRAMMING_GUIDE.md](DSL_PROGRAMMING_GUIDE.md)
- [docs/DSL_TILEWEAVE_GUIDE.md](DSL_TILEWEAVE_GUIDE.md)
- [docs/DSL_DEVELOPER_GUIDE.md](DSL_DEVELOPER_GUIDE.md)
- [docs/DSL_TUTORIAL_SCALAR.md](DSL_TUTORIAL_SCALAR.md)
- [docs/DSL_TUTORIAL_TENSOR.md](DSL_TUTORIAL_TENSOR.md)
- [docs/DSL_SOFTWARE_PIPELINING.md](DSL_SOFTWARE_PIPELINING.md)
- [docs/DSL_EXAMPLE_BOX_BLUR_3X3.md](DSL_EXAMPLE_BOX_BLUR_3X3.md)
- [docs/TOOLCHAIN.md](TOOLCHAIN.md)
- [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py)

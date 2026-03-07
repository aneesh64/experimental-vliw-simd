# DSL Tutorial: Scalar Kernels

This tutorial walks through a minimal scalar kernel using the Python DSL.

## Goal

Build a kernel that counts from `0` to `limit`, then stores the result to DMEM.

## Step 1: Imports

```python
from tools.dsl import HardwareCapabilities, KernelBuilder, U32, compile_kernel
```

## Step 2: Define the kernel shape

```python
kb = KernelBuilder("count_loop")
counter = kb.scalar("counter")
limit = kb.arg_scalar("limit", default=5)
one = kb.scalar("one")
cond = kb.scalar("cond")
out_ptr = kb.scalar("out_ptr")
out_buf = kb.arg_dmem_tensor("out", shape=(1,), dtype=U32)
```

Notes:
- `scalar()` creates scratch-resident scalars.
- `arg_scalar()` creates a scalar binding resolved at compile time.
- `arg_dmem_tensor()` creates a symbolic DMEM buffer binding.

## Step 3: Express control flow

```python
kb.const(counter, 0)
kb.const(one, 1)
kb.label("loop")
kb.add(counter, counter, one)
kb.binary("lt", cond, counter, limit)
kb.cond_jump(cond, "loop")
```

This lowers to flow and ALU operations handled by the scheduler backend.

## Step 4: Write the result

```python
kb.address_of(out_ptr, out_buf)
kb.store(out_ptr, counter)
kb.halt()
```

## Step 5: Compile

```python
caps = HardwareCapabilities.from_configs()
result = compile_kernel(
    kb.build(),
    caps,
    bindings={"out": 1200},
    assemble=True,
)
```

Useful outputs:
- `result.required_bindings`
- `result.resolved_bindings`
- `result.scratch_map`
- `result.scheduled_bundles`
- `result.binary_bundles`

## Step 6: What the backend does

The flow is:
1. allocate scratch addresses
2. resolve argument bindings
3. emit scalar argument prologue
4. lower DSL ops into scheduler ops
5. schedule bundles
6. optionally assemble binary bundles

## Validation reference

See the RTL-backed example in [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py).

## Next tutorial

Continue with [docs/DSL_TUTORIAL_TENSOR.md](DSL_TUTORIAL_TENSOR.md) for vector and TensorView helpers.

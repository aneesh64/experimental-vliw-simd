# DSL Example: Control-Flow Heavy Threshold Clip

This example shows a reusable branch-heavy scalar kernel built with the higher-level control-flow helpers.

## Goal

Clip values below a threshold to zero:

$$
\mathrm{output}[i] = \begin{cases}
0 & \text{if } \mathrm{input}[i] < \mathrm{threshold} \\
\mathrm{input}[i] & \text{otherwise}
\end{cases}
$$

## Source

- Builder example: [tools/dsl/examples/control_flow_kernels.py](../tools/dsl/examples/control_flow_kernels.py)
- RTL verification: [verification/cocotb/integration/test_dsl_algorithms_integration.py](../verification/cocotb/integration/test_dsl_algorithms_integration.py)

## Helpful abstractions used

- `counted_loop()` for structured scalar loops
- `if_else()` for readable branch emission
- standard pointer arithmetic and scalar loads/stores

## Kernel shape

The current example processes a fixed 1D buffer of length `6`.

## Core idea

```python
kb.address_of(input_base, input_buf)
kb.address_of(output_base, output_buf)
kb.const(zero, 0)


def body(inner_kb: KernelBuilder) -> None:
    inner_kb.add(in_ptr, input_base, index)
    inner_kb.load(value, in_ptr)
    inner_kb.binary("lt", below_threshold, value, threshold)
    inner_kb.add(out_ptr, output_base, index)
    inner_kb.if_else(
        below_threshold,
        prefix=f"clip_{length}",
        then_body=lambda kb_then: kb_then.store(out_ptr, zero),
        else_body=lambda kb_else: kb_else.store(out_ptr, value),
    )

kb.counted_loop(index, start=0, stop=length, step=1, body=body, prefix=f"clip_loop_{length}")
kb.halt()
```

## Golden vector

The RTL test uses:

```python
values = [3, 10, 12, 7, 21, 9]
threshold = 10
```

Expected output:

```python
[0, 10, 12, 0, 21, 0]
```

## Why it matters

This example demonstrates that the DSL can express:
- structured loops
- explicit branches
- symbolic DMEM bindings
- scalar kernels with nontrivial control flow

## Next extensions

- parameterized loop trip counts
- nested control-flow kernels
- reductions with branchy epilogues

---

# Vector control flow: threshold mask loop

The same example module also includes a vector kernel that uses structured loop control flow together with vector instructions.

## Goal

Produce a mask vector over a 1D input buffer:

$$
\mathrm{output}[i] = \begin{cases}
1 & \text{if } \mathrm{input}[i] < \mathrm{threshold} \\
0 & \text{otherwise}
\end{cases}
$$

## Helpful abstractions used

- `counted_loop()` for tiled iteration
- `vector_fill()` for one-time threshold broadcast
- `vload()` / `vstore()` for vector memory traffic
- `vector_map("lt", ...)` for vector comparison

## Core idea

```python
kb.address_of(input_ptr, input_buf)
kb.address_of(out_ptr, out_buf)
kb.vector_fill(threshold_vec, threshold, ew=32)


def body(inner_kb: KernelBuilder) -> None:
    inner_kb.vload(input_vec, input_ptr)
    inner_kb.vector_map("lt", mask_vec, input_vec, threshold_vec, ew=32)
    inner_kb.vstore(out_ptr, mask_vec)
    inner_kb.add_imm(input_ptr, input_ptr, tile_elements)
    inner_kb.add_imm(out_ptr, out_ptr, tile_elements)


kb.counted_loop(tile_index, start=0, stop=tiles, step=1, body=body, prefix=f"vector_threshold_loop_{length}_{tile_elements}")
kb.halt()
```

## Golden vector

The RTL test uses:

```python
values = [3, 10, 12, 7, 21, 9, 15, 30, 5, 18, 22, 1, 14, 11, 27, 6]
threshold = 16
```

Expected output:

```python
[1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1]
```

## Why it matters

This kernel demonstrates RTL-backed vector control flow without dropping down to handwritten scheduler ops.

## Nested vector loop variant

The same source module also includes `build_nested_vector_threshold_mask_kernel()` for a small 2D-style flattened image.

That kernel combines:
- an outer `counted_loop()` over rows
- an inner `for_each_tile_1d()` over vector tiles in each row
- scalar row-offset arithmetic
- vector compare/store operations inside the inner loop

This provides a reusable pattern for row-major image kernels that need nested control flow plus vector memory traffic.

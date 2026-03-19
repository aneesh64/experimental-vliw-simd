# DSL Example: Pipelined Multi-Run Matrix Residual-Affine Kernel

This document explains the lower-level `KernelBuilder` version of the multi-run matrix residual-affine example, why it packs better than the earlier statically addressed form, and what was verified in RTL.

## Goal

The kernel executes multiple independent `8x8` matrix tiles and then applies a fused vector epilogue to each output tile:

$$
M_r = lhs_r \times rhs_r
$$

$$
affine_r = (M_r + residual_r) \times gain + bias
$$

for each run $r$.

In addition to the main outputs, the kernel also emits:

- `probe[2*r] = affine_r[0]`
- `probe[2*r + 1] = affine_r[63]`
- `meta = runs \times 8`

The intent is to demonstrate a more explicit, lower-level software-pipelined schedule than the TileWeave frontend currently exposes.

## Source

- Builder example: [tools/dsl/examples/tileweave_kernels.py](../tools/dsl/examples/tileweave_kernels.py)
- Builder API: [tools/dsl/builder.py](../tools/dsl/builder.py)
- Lowering: [tools/dsl/lowering.py](../tools/dsl/lowering.py)
- Compile-time schedule checks: [tools/tests/test_dsl_examples.py](../tools/tests/test_dsl_examples.py)
- RTL golden test: [verification/cocotb/integration/test_dsl_matrix_integration.py](../verification/cocotb/integration/test_dsl_matrix_integration.py)

## Why This Version Exists

The earlier helper-based pipelined version already overlapped vector loads with vector compute and stores, but it still spent many load slots materializing absolute DMEM addresses for each chunk.

The optimized version switches to explicit pointer-stepped scheduling:

- preload stage 0
- preload stage 1 while computing and storing stage 0
- advance `matrix_ptr`, `residual_ptr`, and `affine_ptr` with `add_imm`
- emit scalar probe stores only on the first and last chunk of each run

That change reduces the static schedule and, more importantly, cuts load-slot pressure substantially. With the current backend, some of the old load-use wait time is now handled by hardware-side stalls instead of explicit NOP bundles, so the absolute bundle counts are lower than in earlier revisions of this document.

## Kernel Shape

The kernel is built in [tools/dsl/examples/tileweave_kernels.py](../tools/dsl/examples/tileweave_kernels.py) by `_build_multi_matrix_residual_affine_kernel(..., pipelined=True)`.

Structurally it has three phases:

1. Matrix phase
2. Pointer-stepped double-buffered vector epilogue
3. Scalar metadata store

### Matrix phase

For each run, the builder emits one matrix multiply:

1. `MDMVIN lhs_r`
2. `MDMVIN rhs_r`
3. `MZERO`
4. `MCOMPUTE`
5. `MDMVOUT matrix_out_r`

For `runs=2`, that is `10` matrix-slot operations total.

### Vector epilogue

The optimized path allocates two explicit stage buffers for each stream:

- `mat_stages[0:2]`
- `residual_stages[0:2]`
- `affine_stages[0:2]`

It then uses scalar pointers:

- `matrix_ptr`
- `residual_ptr`
- `affine_ptr`

to walk the flattened tiles in `8`-element aligned chunks.

Per chunk, the main compute sequence is:

1. `vload mat_stage`
2. `vload residual_stage`
3. `add`
4. `mul`
5. `add`
6. `vstore affine_ptr`
7. optional scalar probe store on first/last chunk
8. `add_imm affine_ptr, affine_ptr, 8`

This still respects the current RTL constraints, but avoids repeated `const addr` setup for every vector transfer.

### Scalar metadata

After all chunks are complete, the kernel writes one scalar metadata word:

$$
meta = runs \times (64 / 8)
$$

For the current validated example with `runs=2`, that is `16`.

## Important Implementation Detail

Because this version uses explicit `scratch_base` assignments for the stage vectors, the scalar control temporaries must be placed after the entire staged vector window.

If the control scalars are auto-allocated inside that range, they can overlap vector lanes and silently corrupt outputs. The final version places:

- `chunks_done`
- `meta_ptr`
- `matrix_ptr`
- `residual_ptr`
- `affine_ptr`

above the staged vector region.

## Compile Results

For the matrix-enabled target with `runs=2` and `chunk_elements=8`, the final optimized kernel compiles to:

- required bindings: `('lhs_tiles', 'rhs_tiles', 'residual', 'matrix_out', 'affine_out', 'probe', 'meta', 'gain', 'bias')`
- static scheduled bundles: `311`
- slot usage:
  - `alu: 0`
  - `valu: 50`
  - `load: 75`
  - `store: 21`
  - `matrix: 10`
  - `flow: 47`

The non-pipelined baseline for the same workload compiles to:

- static scheduled bundles: `313`
- slot usage:
  - `alu: 16`
  - `valu: 50`
  - `load: 121`
  - `store: 21`
  - `matrix: 10`
  - `flow: 1`

### What improved

The major win is not extra VALU work, which is unchanged, but the elimination of repeated per-chunk address materialization on the load side:

- load-slot usage drops from `121` to `75`
- both versions now include `wait_for_load` ops which replaced a large fraction of the old explicit NOP padding; the absolute bundle counts (313 vs 311) are therefore much closer together than in earlier revisions of this document

The pointer-stepped pipelined form still shows a meaningful advantage in load-slot pressure and in flow-slot scheduling quality (47 flow slots vs 1), which reflects the explicit loop control that the pipelined builder emits vs the flat schedule of the naive version. Both versions also benefit from hardware-side stall absorption through `wait_for_load`, which removes scheduled padding without changing the relative advantage of the pipelined form.

## RTL Verification

The optimized kernel is verified by [verification/cocotb/integration/test_dsl_matrix_integration.py](../verification/cocotb/integration/test_dsl_matrix_integration.py) in `test_pipelined_multi_matrix_residual_affine_golden`.

The last recorded timing (from a pre-`wait_for_load` build):

```text
test_pipelined_multi_matrix_residual_affine_golden  sim_time_ns=42470.0
```

With the `10 ns` clock in the matrix config that was:

$$
42470\,ns / 10\,ns = 4247\text{ cycles}
$$

With the current schedule (311 bundles, `wait_for_load` replacing static NOP padding), the actual runtime is expected to be lower. A re-run is needed to capture the updated figure.

The RTL test verifies:

- `matrix_out`
- `affine_out`
- per-run probe values
- scalar `meta`

for signed-int8 inputs and `U32` outputs.

## What This Demonstrates

This example is useful because it shows the boundary between frontend-level and backend-level optimization.

What the lower-level builder can already improve:

- explicit stage-buffer reuse
- pointer-stepped loads and stores
- reduced address-setup overhead
- better static schedule density

What still dominates the remaining runtime:

- matrix engine latency
- AXI and engine backpressure that now shows up more as dynamic stalls than as static NOP bundles
- the remaining scheduler hazard policy around long-latency vector and matrix operations

So this kernel is a better demonstration of software-pipelined authoring, but it also makes clear that further runtime reductions now depend more on scheduler policy than on DSL expression style.

## Related Reading

- [DSL.md](DSL.md)
- [DSL_SOFTWARE_PIPELINING.md](DSL_SOFTWARE_PIPELINING.md)
- [DSL_EXAMPLE_TILEWEAVE_MATRIX_RESIDUAL_AFFINE.md](DSL_EXAMPLE_TILEWEAVE_MATRIX_RESIDUAL_AFFINE.md)
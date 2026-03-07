# DSL Example: 3x3 Box Blur Kernel

This example shows more complex DSL kernels than the current smoke tests.

## Goal

Compute blurred outputs from 3x3 windows.

$$
\mathrm{output}[0] = \left\lfloor \frac{\sum_{r=0}^{2} \sum_{c=0}^{2} \mathrm{input}[r, c]}{9} \right\rfloor
$$

The worked examples now include:
- a single-pixel blur over one `3x3` patch
- a looped row blur that slides a `3x3` window across a `3x5` patch and emits `3` outputs
- a small full-image blur over a `4x4` input that emits a valid `2x2` output image

## Source

- Builder example: [tools/dsl/examples/box_blur_3x3.py](../tools/dsl/examples/box_blur_3x3.py)
- RTL verification: [verification/cocotb/integration/test_dsl_algorithms_integration.py](../verification/cocotb/integration/test_dsl_algorithms_integration.py)

## Why this example matters

They exercise a richer scalar DSL shape:
- symbolic rank-2 DMEM tensor binding
- repeated `address_of_view()` on 2D subtiles
- scalar loads from DMEM
- an accumulation chain
- scalar division
- symbolic output binding
- loop control and dynamic pointer arithmetic in the row kernel
- nested row/column loop control in the image kernel

## Kernel shapes

The single-pixel kernel is fixed to one `3x3` patch and one output word. The row kernel is fixed to one `3x5` patch and three output words. This keeps the examples simple enough for early RTL regression while still catching issues across the full stack.

The image kernel is fixed to one `4x4` input image and a `2x2` valid output image.

## Single-pixel core idea

```python
input_view = TensorView.full(input_buf)
kb.const(acc, 0)
kb.const(nine, 9)

for row in range(3):
    for col in range(3):
        pixel_view = input_view.subtile((1, 1), (row, col))
        kb.address_of_view(input_ptr, pixel_view)
        kb.load(value, input_ptr)
        kb.add(acc, acc, value)

kb.binary("div", avg, acc, nine)
kb.address_of(output_ptr, output_buf)
kb.store(output_ptr, avg)
kb.halt()
```

## Row-kernel core idea

```python
kb.address_of(input_base, input_buf)
kb.address_of(output_base, output_buf)
kb.const(x, 0)
kb.const(one, 1)
kb.const(limit, 3)
kb.const(nine, 9)

kb.label("row_loop")
kb.const(acc, 0)

for base_offset in (0, 1, 2, 5, 6, 7, 10, 11, 12):
    kb.add(ptr, input_base, x)
    kb.add_imm(ptr, ptr, base_offset)
    kb.load(value, ptr)
    kb.add(acc, acc, value)

kb.binary("div", avg, acc, nine)
kb.add(out_ptr, output_base, x)
kb.store(out_ptr, avg)
kb.add(x, x, one)
kb.binary("lt", cond, x, limit)
kb.cond_jump(cond, "row_loop")
kb.halt()
```

## Image-kernel core idea

```python
kb.label("image_row_loop")
kb.const(x, 0)
kb.label("image_col_loop")

kb.binary("mul", row_base, y, width)
kb.add(window_base, row_base, x)
kb.const(acc, 0)

for base_offset in (0, 1, 2, 4, 5, 6, 8, 9, 10):
    kb.add(ptr, input_base, window_base)
    kb.add_imm(ptr, ptr, base_offset)
    kb.load(value, ptr)
    kb.add(acc, acc, value)

kb.binary("div", avg, acc, nine)
kb.binary("mul", output_index, y, two)
kb.add(output_index, output_index, x)
kb.add(out_ptr, output_base, output_index)
kb.store(out_ptr, avg)
```

## Golden test vector

The current RTL test uses the patch:

```python
[
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
]
```

The sum is $45$, so the blurred output is $45 / 9 = 5$.

The row-kernel RTL test uses the patch:

```python
[
    1, 2, 3, 4, 5,
    6, 7, 8, 9, 10,
    11, 12, 13, 14, 15,
]
```

The three valid horizontal windows produce:

$$
[7, 8, 9]
$$

The image-kernel RTL test uses:

```python
[
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
    13, 14, 15, 16,
]
```

The valid `2x2` blur output is:

$$
[6, 7, 10, 11]
$$

## Current scope

This is not yet a full-image blur pipeline. These are correctness-first kernels used to catch DSL, scheduler, assembler, and RTL mismatches early.

## Next expansion ideas

- blur a small full image with nested loops
- extend from fixed-size images to parameterized image dimensions
- mix vector loads for row windows with scalar border handling
- add cycle comparisons for scalar versus helper-based variants

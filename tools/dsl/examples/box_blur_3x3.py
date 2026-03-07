from __future__ import annotations

from ..builder import KernelBuilder
from ..ir import Kernel, U32
from ..layout import TensorView


def build_box_blur_3x3_kernel(name: str = "dsl_box_blur_3x3") -> Kernel:
    """Build a fixed 3x3 box blur kernel for one output pixel.

    The kernel expects:
    - `input`: a 3x3 DMEM tensor in row-major order
    - `output`: a 1-element DMEM tensor receiving the blurred center pixel

    The computation is:
        output[0] = sum(input[r, c] for r in range(3) for c in range(3)) // 9
    """

    kb = KernelBuilder(name)
    input_buf = kb.arg_dmem_tensor("input", shape=(3, 3), dtype=U32)
    output_buf = kb.arg_dmem_tensor("output", shape=(1,), dtype=U32)

    input_ptr = kb.scalar("input_ptr")
    output_ptr = kb.scalar("output_ptr")
    value = kb.scalar("value")
    acc = kb.scalar("acc")
    nine = kb.scalar("nine")
    avg = kb.scalar("avg")

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
    return kb.build()


def build_box_blur_3x3_row_kernel(name: str = "dsl_box_blur_3x3_row") -> Kernel:
    """Build a 3x3 box blur kernel for a single output row.

    The kernel expects:
    - `input`: a 3x5 DMEM tensor in row-major order
    - `output`: a 3-element DMEM tensor

    It computes the three horizontally valid 3x3 box-blur outputs for the
    middle row by sliding a 3x3 window across the 3x5 patch.
    """

    kb = KernelBuilder(name)
    input_buf = kb.arg_dmem_tensor("input", shape=(3, 5), dtype=U32)
    output_buf = kb.arg_dmem_tensor("output", shape=(3,), dtype=U32)

    input_base = kb.scalar("input_base")
    output_base = kb.scalar("output_base")
    ptr = kb.scalar("ptr")
    out_ptr = kb.scalar("out_ptr")
    x = kb.scalar("x")
    one = kb.scalar("one")
    limit = kb.scalar("limit")
    cond = kb.scalar("cond")
    value = kb.scalar("value")
    acc = kb.scalar("acc")
    nine = kb.scalar("nine")
    avg = kb.scalar("avg")

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
    return kb.build()


def build_box_blur_3x3_image_kernel(name: str = "dsl_box_blur_3x3_image") -> Kernel:
    """Build a fixed 3x3 box blur kernel for a small full image.

    The kernel expects:
    - `input`: a 4x4 DMEM tensor in row-major order
    - `output`: a 2x2 DMEM tensor in row-major order

    It computes the valid 3x3 box-blur outputs for the 4x4 image using
    nested scalar loops over the two output rows and two output columns.
    """

    kb = KernelBuilder(name)
    input_buf = kb.arg_dmem_tensor("input", shape=(4, 4), dtype=U32)
    output_buf = kb.arg_dmem_tensor("output", shape=(2, 2), dtype=U32)

    input_base = kb.scalar("input_base")
    output_base = kb.scalar("output_base")
    ptr = kb.scalar("ptr")
    out_ptr = kb.scalar("out_ptr")
    y = kb.scalar("y")
    x = kb.scalar("x")
    one = kb.scalar("one")
    two = kb.scalar("two")
    width = kb.scalar("width")
    cond = kb.scalar("cond")
    value = kb.scalar("value")
    acc = kb.scalar("acc")
    nine = kb.scalar("nine")
    avg = kb.scalar("avg")
    row_base = kb.scalar("row_base")
    window_base = kb.scalar("window_base")
    output_index = kb.scalar("output_index")

    kb.address_of(input_base, input_buf)
    kb.address_of(output_base, output_buf)
    kb.const(y, 0)
    kb.const(one, 1)
    kb.const(two, 2)
    kb.const(width, 4)
    kb.const(nine, 9)

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

    kb.add(x, x, one)
    kb.binary("lt", cond, x, two)
    kb.cond_jump(cond, "image_col_loop")

    kb.add(y, y, one)
    kb.binary("lt", cond, y, two)
    kb.cond_jump(cond, "image_row_loop")
    kb.halt()
    return kb.build()

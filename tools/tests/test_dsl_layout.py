#!/usr/bin/env python3

import sys
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from dsl import KernelBuilder, U8
from dsl.layout import Layout, contiguous_view, tile_1d


def test_contiguous_layout_offsets():
    layout = Layout.contiguous((4, 8))
    assert layout.strides == (8, 1)
    assert layout.offset((0, 0)) == 0
    assert layout.offset((2, 3)) == 19


def test_rank1_tile_view_offset():
    kb = KernelBuilder("tile_view")
    buf = kb.arg_dmem_tensor("input", shape=(32,), dtype=U8)
    view = contiguous_view(buf)
    sub = view.subtile((8,), (16,))

    assert sub.base_offset_words == 16
    assert sub.vector_length == 8


def test_tile_1d_helper():
    kb = KernelBuilder("tile_helper")
    buf = kb.arg_dmem_tensor("input", shape=(64,), dtype=U8)
    sub = tile_1d(buf, length=8, start=24)
    assert sub.base_offset_words == 24
    assert sub.tile.origin == (24,)

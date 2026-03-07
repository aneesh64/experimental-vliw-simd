from __future__ import annotations

from dataclasses import dataclass
from typing import Tuple

from .ir import Buffer


@dataclass(frozen=True)
class Layout:
    shape: Tuple[int, ...]
    strides: Tuple[int, ...]

    @classmethod
    def contiguous(cls, shape: Tuple[int, ...]) -> "Layout":
        if not shape:
            return cls(shape=(), strides=())
        strides = [1] * len(shape)
        running = 1
        for idx in range(len(shape) - 1, -1, -1):
            strides[idx] = running
            running *= shape[idx]
        return cls(shape=shape, strides=tuple(strides))

    def offset(self, indices: Tuple[int, ...]) -> int:
        if len(indices) != len(self.shape):
            raise ValueError(f"Expected {len(self.shape)} indices, got {len(indices)}")
        total = 0
        for index, extent, stride in zip(indices, self.shape, self.strides):
            if index < 0 or index >= extent:
                raise ValueError(f"Index {index} is out of bounds for extent {extent}")
            total += index * stride
        return total


@dataclass(frozen=True)
class Tile:
    shape: Tuple[int, ...]
    origin: Tuple[int, ...]

    def elements(self) -> int:
        total = 1
        for dim in self.shape:
            total *= dim
        return total


@dataclass(frozen=True)
class TensorView:
    buffer: Buffer
    layout: Layout
    tile: Tile
    base_offset_words: int = 0

    @classmethod
    def full(cls, buffer: Buffer) -> "TensorView":
        layout = Layout.contiguous(buffer.shape)
        return cls(
            buffer=buffer,
            layout=layout,
            tile=Tile(shape=buffer.shape, origin=tuple(0 for _ in buffer.shape)),
            base_offset_words=0,
        )

    def subtile(self, tile_shape: Tuple[int, ...], origin: Tuple[int, ...]) -> "TensorView":
        if len(tile_shape) != len(self.buffer.shape):
            raise ValueError("Tile rank must match buffer rank")
        if len(origin) != len(self.buffer.shape):
            raise ValueError("Tile origin rank must match buffer rank")

        for dim, off, full in zip(tile_shape, origin, self.buffer.shape):
            if dim <= 0:
                raise ValueError("Tile dimensions must be positive")
            if off < 0 or off + dim > full:
                raise ValueError("Requested tile exceeds buffer bounds")

        return TensorView(
            buffer=self.buffer,
            layout=self.layout,
            tile=Tile(shape=tile_shape, origin=origin),
            base_offset_words=self.layout.offset(origin),
        )

    @property
    def vector_length(self) -> int:
        if len(self.tile.shape) != 1:
            raise ValueError("Initial tensor helper layer only supports rank-1 vector tiles")
        return self.tile.shape[0]


def contiguous_view(buffer: Buffer) -> TensorView:
    return TensorView.full(buffer)


def tile_1d(buffer: Buffer, *, length: int, start: int = 0) -> TensorView:
    return TensorView.full(buffer).subtile((length,), (start,))

# Visualization Project

This folder contains architecture-style block diagrams for the generated SpinalHDL/Verilog hierarchy.

## Chosen tool

Graphviz/DOT is now the default for the checked-in SVG assets in this folder.

- Mermaid remains useful for quick drafts.
- Graphviz/DOT gives better control over ranks, orthogonal routing, and cluster layout when a diagram has many feedback paths.
- Kroki can render both Mermaid and Graphviz directly to SVG over HTTP, which avoids needing a local Node.js or Graphviz toolchain.

## Alternatives considered

- `netlistsvg`: strong automatic RTL-to-SVG path, but it expects Yosys JSON, produces more schematic-style output, and this workspace does not currently have Yosys or Node tooling available.
- Graphviz: excellent general SVG renderer, but it is not HDL-aware and no local `dot` binary was available on PATH.
- `rtlviz`: not available as a ready-to-use local integration here, so it was not the fastest reliable path for checked-in assets.

## Files

- `vliw_soc_block_diagram.dot`: top-level SoC block view based on `generated_rtl/Sim/VliwSimdSoc_1c.v`
- `vliw_core_block_diagram.dot`: core-internal block view based on `generated_rtl/modules/VliwCore.v`
- `vliw_core_pipeline_control.dot`: focused fetch/decode, execution, and control-return view
- `vliw_core_memory_matrix.dot`: focused scratch, AXI, DMA, and matrix-local memory view
- `*.svg`: rendered SVG outputs for the Mermaid sources

## Regenerate

From the repository root on Windows PowerShell:

```powershell
./docs/visualization/render_svgs.ps1
```

The script posts each Mermaid source file to Kroki and writes the SVG next to the source.
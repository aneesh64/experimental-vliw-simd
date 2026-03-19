param(
    [string]$SourceDir = $PSScriptRoot
)

$typeMap = @{
    ".mmd" = "mermaid"
    ".dot" = "graphviz"
}

$sources = Get-ChildItem -Path $SourceDir -File |
    Where-Object { $typeMap.ContainsKey($_.Extension.ToLowerInvariant()) } |
    Sort-Object Name

if (-not $sources) {
    Write-Error "No supported diagram source files found in $SourceDir"
    exit 1
}

foreach ($source in $sources) {
    $diagramType = $typeMap[$source.Extension.ToLowerInvariant()]
    $endpoint = "https://kroki.io/$diagramType/svg"
    $svgPath = [System.IO.Path]::ChangeExtension($source.FullName, ".svg")
    $body = Get-Content -Path $source.FullName -Raw
    Invoke-WebRequest -Uri $endpoint -Method Post -ContentType "text/plain; charset=utf-8" -Body $body -OutFile $svgPath
    Write-Host "Rendered $($source.Name) -> $([System.IO.Path]::GetFileName($svgPath))"
}
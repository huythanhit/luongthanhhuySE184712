param(
    [string]$Destination = "docs",
    [switch]$IncludeDrafts,
    [switch]$Minify = $true
)

$ErrorActionPreference = "Stop"

function Assert-Hugo {
    if (-not (Get-Command hugo -ErrorAction SilentlyContinue)) {
        throw "hugo not found. Run scripts/install-hugo.ps1 first."
    }
}

function Build-Site {
    Assert-Hugo

    # PowerShell 5 compatibility: use if/else instead of ternary
    $draftFlag = ""
    if ($IncludeDrafts) { $draftFlag = "-D" }

    $minifyFlag = ""
    if ($Minify) { $minifyFlag = "--minify" }

    Write-Host "Building site to '$Destination'..." -ForegroundColor Cyan
    $cmd = @("hugo", "-d", $Destination)
    if ($draftFlag) { $cmd += $draftFlag }
    if ($minifyFlag) { $cmd += $minifyFlag }

    & $cmd[0] $cmd[1..($cmd.Length - 1)]
    Write-Host "Build complete. Output: $Destination" -ForegroundColor Green
}

Build-Site

Write-Host "Next steps: commit and push '$Destination' or upload its contents to your host." -ForegroundColor Yellow

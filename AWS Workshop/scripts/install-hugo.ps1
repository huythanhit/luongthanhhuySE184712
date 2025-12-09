param(
    [switch]$Force
)

# Installs Hugo Extended via available package managers and ensures hugo.exe is on PATH.
function Add-ToPathIfNeeded {
    param([string]$PathToAdd)
    if (-not $PathToAdd) { return }
    $current = [Environment]::GetEnvironmentVariable('Path', 'User')
    if (-not $current) { $current = '' }
    $parts = $current.Split(';') | Where-Object { $_ -ne '' }
    if ($parts -contains $PathToAdd) { return }
    [Environment]::SetEnvironmentVariable('Path', ($current + ';' + $PathToAdd).Trim(';'), 'User')
    Write-Host "Added to user PATH: $PathToAdd" -ForegroundColor Green
}

function Resolve-HugoPath {
    $candidates = @(
        "C:\\ProgramData\\chocolatey\\bin",
        "C:\\Program Files\\Hugo\\bin",
        "C:\\Users\\$env:USERNAME\\AppData\\Local\\Microsoft\\WinGet\\Packages\\Hugo.Hugo.Extended_Microsoft.Winget.Source_8wekyb3d8bbwe"
    )
    foreach ($p in $candidates) {
        if (Test-Path (Join-Path $p 'hugo.exe')) { return $p }
    }
    $found = Get-ChildItem -Path "C:\\Program Files","C:\\ProgramData","$env:LOCALAPPDATA" -Filter hugo.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty DirectoryName
    return $found
}

# Installs Hugo Extended via available package managers. Fails with guidance if none are available.
function Install-Hugo {
    Write-Host "Checking for existing hugo..." -ForegroundColor Cyan
    if (Get-Command hugo -ErrorAction SilentlyContinue) {
        if (-not $Force) {
            Write-Host "hugo already installed. Use -Force to reinstall." -ForegroundColor Yellow
        } else {
            Write-Host "hugo found but reinstall forced." -ForegroundColor Yellow
        }
    }

    $installed = $false

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Installing via winget (Hugo Extended)..." -ForegroundColor Cyan
        winget install --id Hugo.Hugo.Extended -e --source winget
        $installed = $true
    }
    elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "Installing via Chocolatey (Hugo Extended)..." -ForegroundColor Cyan
        choco install hugo-extended -y
        $installed = $true
    }
    elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "Installing via Scoop (Hugo Extended)..." -ForegroundColor Cyan
        scoop install hugo-extended
        $installed = $true
    }

    if (-not $installed) {
        Write-Error "No package manager found (winget/choco/scoop). Please install Hugo Extended manually from https://github.com/gohugoio/hugo/releases." -ErrorAction Stop
    }

    $hugoDir = Resolve-HugoPath
    if ($hugoDir) {
        if (-not ($env:Path -split ';' | Where-Object { $_ -eq $hugoDir })) {
            Write-Host "Temporarily adding to session PATH: $hugoDir" -ForegroundColor Yellow
            $env:Path = "$hugoDir;" + $env:Path
        }
        Add-ToPathIfNeeded -PathToAdd $hugoDir
    } else {
        Write-Host "Could not locate hugo.exe automatically. Please add its folder to PATH manually." -ForegroundColor Red
    }

    Write-Host "hugo installation complete. Version:" -ForegroundColor Green
    hugo version
}

Install-Hugo

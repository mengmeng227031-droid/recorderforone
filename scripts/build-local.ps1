$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$cacheRoot = Join-Path $projectRoot '.cache'
$electronCache = Join-Path $cacheRoot 'electron'
$builderCache = Join-Path $cacheRoot 'electron-builder'

New-Item -ItemType Directory -Force -Path $electronCache, $builderCache | Out-Null

$env:electron_config_cache = $electronCache
$env:ELECTRON_CACHE = $electronCache
$env:ELECTRON_BUILDER_CACHE = $builderCache

Push-Location $projectRoot
try {
  npm run build
} finally {
  Pop-Location
}

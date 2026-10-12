$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$cacheRoot = Join-Path $projectRoot '.cache'
$npmCache = Join-Path $cacheRoot 'npm'
$electronCache = Join-Path $cacheRoot 'electron'
$builderCache = Join-Path $cacheRoot 'electron-builder'

New-Item -ItemType Directory -Force -Path $npmCache, $electronCache, $builderCache | Out-Null

$env:npm_config_cache = $npmCache
$env:electron_config_cache = $electronCache
$env:ELECTRON_CACHE = $electronCache
$env:ELECTRON_BUILDER_CACHE = $builderCache

Push-Location $projectRoot
try {
  npm ci
} finally {
  Pop-Location
}

#::name: set-core-env-vars
#::short: Sets core environment variables for consistent cross-platform config paths.
#::help:
#::  This script defines and sets the core environment variables recommended by the
#::  XDG Base Directory Specification. It ensures directories exist, sets values persistently
#::  at the user scope, and logs all actions.
#::
#::  Variables set:
#::    - XDG_CONFIG_HOME     → $HOME\.config
#::    - XDG_DATA_HOME       → $HOME\.local\share
#::    - XDG_STATE_HOME      → $HOME\.local\state
#::    - XDG_CACHE_HOME      → $HOME\.cache
#::    - XDG_BIN_HOME        → $HOME\.local\bin
#::    - XDG_RUNTIME_DIR     → $env:TEMP\xdg-runtime
#::
#::  Usage:
#::      init set-core-env-vars

# --- Bootstrap Logging Setup ---
$userHome = [Environment]::GetFolderPath("UserProfile")
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$bootstrapLog = Join-Path $userHome ".${timestamp}_set-core-env-vars-bootstrap.log"

function Write-BootstrapLog {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp [BOOTSTRAP] $Message" | Out-File -FilePath $bootstrapLog -Append
}

Write-BootstrapLog "Script start: set-core-env-vars"

# --- Define Target Paths ---
$envMap = @{
    "XDG_CONFIG_HOME"  = "$userHome\.config"
    "XDG_DATA_HOME"    = "$userHome\.local\share"
    "XDG_STATE_HOME"   = "$userHome\.local\state"
    "XDG_CACHE_HOME"   = "$userHome\.cache"
    "XDG_BIN_HOME"     = "$userHome\.local\bin"
    "XDG_RUNTIME_DIR"  = Join-Path $env:TEMP "xdg-runtime"
}

# --- Ensure Directories Exist ---
foreach ($key in $envMap.Keys) {
    $path = $envMap[$key]
    if (-not (Test-Path $path)) {
        try {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
            Write-BootstrapLog "Created directory: $path"
        } catch {
            Write-BootstrapLog "ERROR: Failed to create directory: $path"
        }
    }
}

# --- Set Environment Variables (User scope) ---
foreach ($key in $envMap.Keys) {
    $desiredValue = $envMap[$key]
    $currentValue = [Environment]::GetEnvironmentVariable($key, 'User')

    if ($currentValue -ne $desiredValue) {
        try {
            [Environment]::SetEnvironmentVariable($key, $desiredValue, 'User')
            Write-BootstrapLog "Set $key = $desiredValue"
        } catch {
            Write-BootstrapLog "ERROR: Failed to set $key"
        }
    } else {
        Write-BootstrapLog "$key is already set to desired value"
    }
}

# --- Switch to Final Logging Location ---
$xdgState = $envMap["XDG_STATE_HOME"]
$logRoot = Join-Path $xdgState "logs\cli-hub"

if (-not (Test-Path $logRoot)) {
    New-Item -ItemType Directory -Path $logRoot -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFileName = "${timestamp}_set-core-env-vars.log"
$finalLog = Join-Path $logRoot $logFileName

Copy-Item -Path $bootstrapLog -Destination $finalLog -Force
Remove-Item -Path $bootstrapLog -Force

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp $Message" | Out-File -FilePath $finalLog -Append
}

Write-Log "Logging transitioned to: $finalLog"

# --- Output Summary to Log ---
Write-Log "Final environment variable values:"
foreach ($key in $envMap.Keys) {
    Write-Log "  $key = $($envMap[$key])"
}

Write-Log "Script completed successfully."
Write-Host "✅ Core environment variables set."
Write-Host "📄 Log written to: $finalLog"
exit 0


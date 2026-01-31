param(
  [string]$Message = ""
)

# Always run from the repo directory (this script's folder)
Set-Location -LiteralPath $PSScriptRoot

# Make sure we're on main
git switch main | Out-Null

# Get latest remote changes (safe default)
git pull --rebase

# Stage ONLY modifications/deletions of already tracked files
git add -u

# If nothing changed, exit cleanly
$changed = git diff --cached --name-only
if (-not $changed) {
  Write-Host "No tracked changes to commit."
  exit 0
}

# Default commit message if none provided
if ([string]::IsNullOrWhiteSpace($Message)) {
  $Message = "Update summaries $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

git commit -m $Message
git push

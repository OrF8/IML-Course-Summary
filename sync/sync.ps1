param(
  [string]$Message = ""
)

Set-Location -LiteralPath $PSScriptRoot

git switch main | Out-Null
git pull --rebase

git add -u

$changed = git diff --cached --name-only
if (-not $changed) {
  Write-Host "No tracked changes to commit."
  exit 0
}

if ([string]::IsNullOrWhiteSpace($Message)) {
  $Message = "Update summaries $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

git commit -m $Message
git push

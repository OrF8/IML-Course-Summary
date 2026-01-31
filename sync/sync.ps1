Set-Location -LiteralPath $PSScriptRoot

git switch main | Out-Null
git pull --rebase

git add -u

# Nothing to commit?
if (git diff --cached --quiet) {
  Write-Host "No tracked changes to commit."
  exit 0
}

$useMsg = Read-Host "Do you want to enter a commit message? (y/n)"
if ($useMsg -match '^(y|yes|Y|YEs|YES)$') {
  $msg = Read-Host "Enter commit message"
  if ([string]::IsNullOrWhiteSpace($msg)) {
    Write-Host "Empty message → using default."
    $msg = "Update summaries $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
  }
} else {
  $msg = "Update summaries $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

git commit -m $msg
git push

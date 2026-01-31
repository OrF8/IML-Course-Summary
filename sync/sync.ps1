$ErrorActionPreference = 'Stop'

Set-Location -LiteralPath (Split-Path $PSScriptRoot -Parent)

# ----------- Export PDF -----------

function Export-DocxToPdfWithBookmarksHighQuality {
  param(
    [Parameter(Mandatory=$true)][string]$DocxPath,
    [Parameter(Mandatory=$true)][string]$PdfPath
  )

  if (-not (Test-Path -LiteralPath $DocxPath)) {
    throw "DOCX not found: $DocxPath"
  }

  # Word COM constants
  $wdExportFormatPDF = 17
  $wdExportOptimizeForPrint = 0  # Best quality
  $wdExportAllDocument = 0
  $wdExportDocumentContent = 0
  $wdExportCreateHeadingBookmarks = 1  # Bookmarks from Heading styles

  $word = $null
  $doc  = $null

  try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0

    # Open read-only
    $doc = $word.Documents.Open(
      $DocxPath,
      $false,   # ConfirmConversions
      $true     # ReadOnly
    )

    # Export PDF with heading bookmarks + best quality
    $doc.ExportAsFixedFormat(
      $PdfPath,                      # OutputFileName
      $wdExportFormatPDF,            # ExportFormat
      $false,                        # OpenAfterExport
      $wdExportOptimizeForPrint,     # OptimizeFor (PRINT)
      $wdExportAllDocument,          # Range
      0,                             # From
      0,                             # To
      $wdExportDocumentContent,      # Item
      $true,                         # IncludeDocProps
      $true,                         # KeepIRM
      $wdExportCreateHeadingBookmarks,# CreateBookmarks
      $true,                         # DocStructureTags
      $true,                         # BitmapMissingFonts
      $false                         # UseISO19005_1 (PDF/A)
    )
  }
  finally {
    if ($doc)  { $doc.Close($false) | Out-Null; [System.Runtime.InteropServices.Marshal]::ReleaseComObject($doc)  | Out-Null }
    if ($word) { $word.Quit()       | Out-Null; [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
  }
}

# Make sure the .docx file is the newest
git switch main | Out-Null
git pull --rebase

# Pick newest DOCX in current folder
$docx = Get-ChildItem -File -Filter "*.docx" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $docx) { throw "No DOCX found in $(Get-Location)" }

$pdf = [System.IO.Path]::ChangeExtension($docx.FullName, ".pdf")

if (Test-Path -LiteralPath $pdf) {
  $docxTime = (Get-Item -LiteralPath $docx.FullName).LastWriteTime
  $pdfTime  = (Get-Item -LiteralPath $pdf).LastWriteTime
  if ($pdfTime -ge $docxTime) {
    Write-Host "PDF is up-to-date; skipping export."
  } else {
    Write-Host "Exporting PDF from:" $docx.Name
    Export-DocxToPdfWithBookmarksHighQuality -DocxPath $docx.FullName -PdfPath $pdf
    Write-Host "Exported PDF to:" (Split-Path -Leaf $pdf)
  }
} else {
  Write-Host "Exporting PDF from:" $docx.Name
  Export-DocxToPdfWithBookmarksHighQuality -DocxPath $docx.FullName -PdfPath $pdf
  Write-Host "Exported PDF to:" (Split-Path -Leaf $pdf)
}

# ----------- Update Git -----------

git add -u
Write-Host "Staged files:"
git diff --cached --name-only
Write-Host ""
git status
git diff --stat

# Nothing to commit?
if (git diff --cached --quiet) {
  Write-Host "No tracked changes to commit."
  exit 0
}

$useMsg = Read-Host "Do you want to enter a commit message? (y/n)"
if ($useMsg -imatch '^(y|yes)$') {
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

$tagName = Read-Host "Enter tag name (or press Enter to skip tagging)"
if (-not [string]::IsNullOrWhiteSpace($tagName)) {

  # Sanitize tag name
  $tagName = $tagName.Trim()
  $tagName = $tagName -replace '\s+', '-'                 # spaces -> hyphen
  $tagName = $tagName -replace '[:\?\~\^\*\[\]\\]', ''    # remove illegal chars

  # Check if tag already exists
  $existing = git tag -l $tagName
  if (-not [string]::IsNullOrWhiteSpace($existing)) {
    Write-Host "Tag '$tagName' already exists. Skipping tag creation."
  } else {
    try {
      git tag -a $tagName -m "Tag $tagName"
      git push origin $tagName
      Write-Host "Created and pushed tag '$tagName'"
    } catch {
      Write-Host "Tagging failed: $($_.Exception.Message)"
    }
  }
}

Write-Host "Done :)"

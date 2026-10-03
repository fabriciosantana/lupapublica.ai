# Repository preparation checks only; no application behavior is tested.
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$files = @(
  'AGENTS.md', 'README.md', '.gitignore', '.editorconfig', '.env.example',
  'docs/PROJECT_CONTEXT.md', 'openspec/config.yaml',
  '.github/workflows/ci.yml',
  'docs/architecture/decisions/ADR-001-use-postgresql-for-structured-data.md',
  'docs/architecture/decisions/ADR-002-use-hybrid-rag-and-text-to-sql.md',
  'docs/architecture/decisions/ADR-003-read-only-sql-execution.md',
  'docs/architecture/decisions/ADR-004-llm-provider-abstraction.md'
)
foreach ($file in $files) {
  if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $file) -PathType Leaf)) {
    throw "Required file missing: $file"
  }
}
foreach ($dir in @('docs/rfi', 'docs/evidence', 'data/semantic',
    'data/verified-queries', 'data/evaluation', 'backend', 'frontend',
    'infrastructure', '.github/workflows', 'openspec/specs', 'openspec/changes')) {
  if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $dir) -PathType Container)) {
    throw "Required directory missing: $dir"
  }
}
$rfiName = '01RFI_CGU_PORTALTRANSPARENCIAPublicado.xlsx'
$originalHash = (Get-FileHash -LiteralPath (Join-Path $repoRoot "docs/$rfiName")).Hash
$copyHash = (Get-FileHash -LiteralPath (Join-Path $repoRoot "docs/rfi/$rfiName")).Hash
if ($originalHash -ne $copyHash) { throw 'RFI copy differs from preserved original.' }
$rfiReadme = Get-Content -LiteralPath (Join-Path $repoRoot 'docs/rfi/README.md') -Raw
if (-not $rfiReadme.Contains($copyHash.ToLowerInvariant())) {
  throw 'RFI README hash differs from actual file hash.'
}
$trackedFiles = & git -C $repoRoot ls-files
if ($LASTEXITCODE -ne 0) { throw 'Unable to list tracked files.' }
foreach ($file in $trackedFiles) {
  $leaf = Split-Path -Leaf $file
  if (($leaf -eq '.env') -or ($leaf -like '.env.*' -and $leaf -ne '.env.example')) {
    throw "Environment secrets file must not be tracked: $file"
  }
  if ($file -notlike '*.md' -or $file.StartsWith('.agents/')) { continue }
  $absolute = Join-Path $repoRoot $file
  $text = Get-Content -LiteralPath $absolute -Raw
  # Check simple relative Markdown links; remote links and heading anchors are excluded.
  foreach ($match in [regex]::Matches($text, '\]\(([^\s)]+)\)')) {
    $target = $match.Groups[1].Value
    if ($target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:' -or $target.StartsWith('#')) { continue }
    $target = [Uri]::UnescapeDataString(($target -split '#', 2)[0])
    if (-not (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $absolute) $target))) {
      throw "Broken local link in ${file}: $target"
    }
  }
}
Write-Host 'Repository structure, RFI integrity and local Markdown links: OK.'
Write-Host 'Application build, application tests and AI evaluation: not implemented.'

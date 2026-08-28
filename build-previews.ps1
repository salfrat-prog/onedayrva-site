$ErrorActionPreference = "Stop"
$root = "C:\Users\jilli\Documents\onedayrva-site"
$scratch = "C:\Users\jilli\AppData\Local\Temp\claude\C--Users-jilli--claude\b75addd0-332a-497b-a0aa-39d9786acc26\scratchpad"

$css = Get-Content "$root\css\site.css" -Raw

$fontLink = '<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Big+Shoulders+Display:wght@500;600;700;800&family=Source+Serif+4:opsz,wght@8..60,400;8..60,500;8..60,600&family=Source+Serif+4:ital,wght@1,400&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">'

$mime = @{ ".jpg"="image/jpeg"; ".jpeg"="image/jpeg"; ".png"="image/png"; ".svg"="image/svg+xml" }

# Build a lookup of every images/... reference -> data URI, scanning images/ recursively.
$imageUriCache = @{}
function Get-ImageDataUri($relPath) {
  if ($imageUriCache.ContainsKey($relPath)) { return $imageUriCache[$relPath] }
  $full = Join-Path $root $relPath
  if (-not (Test-Path $full)) { return $null }
  $ext = [System.IO.Path]::GetExtension($full).ToLower()
  $ct = $mime[$ext]
  if (-not $ct) { $ct = "application/octet-stream" }
  $bytes = [System.IO.File]::ReadAllBytes($full)
  $b64 = [System.Convert]::ToBase64String($bytes)
  $uri = "data:$ct;base64,$b64"
  $imageUriCache[$relPath] = $uri
  return $uri
}

function Build-Preview($srcFile, $outFile, $titleText) {
  $html = Get-Content "$root\$srcFile" -Raw
  if ($html -notmatch '(?s)<body>(.*)</body>') { throw "no body found in $srcFile" }
  $body = $Matches[1]

  # Inline every local image reference (src="images/...") as a data URI.
  $body = [regex]::Replace($body, 'src="(images/[^"]+)"', {
    param($m)
    $rel = $m.Groups[1].Value
    $uri = Get-ImageDataUri $rel
    if ($uri) { return "src=`"$uri`"" } else { return $m.Value }
  })

  # Same-site nav links don't resolve inside an artifact preview; neutralize them.
  foreach ($page in @('index.html','about.html','looking-back.html','get-involved.html','repair-fair.html')) {
    $body = $body.Replace("href=`"$page`"", 'href="#"')
  }

  $out = "<title>$titleText</title>`n<meta name=`"viewport`" content=`"width=device-width, initial-scale=1`">`n$fontLink`n`n<style>`n$css`n</style>`n$body"
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText("$scratch\$outFile", $out, $utf8NoBom)
  $sizeKb = [math]::Round((Get-Item "$scratch\$outFile").Length / 1kb, 1)
  Write-Host "$outFile -> $sizeKb KB"
}

Build-Preview "index.html" "preview-home.html" "One Day, One Step"
Build-Preview "about.html" "preview-about.html" "About One Day, One Step"
Build-Preview "looking-back.html" "preview-looking-back.html" "Looking Back | One Day, One Step"
Build-Preview "get-involved.html" "preview-get-involved.html" "Get Involved | One Day, One Step"
Build-Preview "repair-fair.html" "preview-repair-fair.html" "Repair Fair | One Day, One Step"

Write-Host "Done"

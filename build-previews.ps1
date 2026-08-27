$ErrorActionPreference = "Stop"
$root = "C:\Users\jilli\Documents\onedayrva-site"
$scratch = "C:\Users\jilli\AppData\Local\Temp\claude\C--Users-jilli--claude\b75addd0-332a-497b-a0aa-39d9786acc26\scratchpad"

$css = Get-Content "$root\css\site.css" -Raw

$sanctuaryB64 = (Get-Content "$scratch\sanctuary.b64" -Raw).Trim()
$forgiveB64 = (Get-Content "$scratch\forgive.b64" -Raw).Trim()
$sanctuaryUri = "data:image/jpeg;base64,$sanctuaryB64"
$forgiveUri = "data:image/jpeg;base64,$forgiveB64"

$fontLink = '<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Big+Shoulders+Display:wght@500;600;700;800&family=Source+Serif+4:opsz,wght@8..60,400;8..60,500;8..60,600&family=Source+Serif+4:ital,wght@1,400&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">'

function Build-Preview($srcFile, $outFile, $titleText) {
  $html = Get-Content "$root\$srcFile" -Raw
  if ($html -notmatch '(?s)<body>(.*)</body>') { throw "no body found in $srcFile" }
  $body = $Matches[1]
  $body = $body.Replace('images/2022-sanctuary.jpg', $sanctuaryUri)
  $body = $body.Replace('images/2022-forgiveness-ritual.jpg', $forgiveUri)
  $body = $body.Replace('href="index.html"', 'href="#"')
  $body = $body.Replace('href="about.html"', 'href="#"')
  $body = $body.Replace('href="looking-back.html"', 'href="#"')

  $out = "<title>$titleText</title>`n<meta name=`"viewport`" content=`"width=device-width, initial-scale=1`">`n$fontLink`n`n<style>`n$css`n</style>`n$body"
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText("$scratch\$outFile", $out, $utf8NoBom)
}

Build-Preview "index.html" "preview-home.html" "One Day, One Step"
Build-Preview "about.html" "preview-about.html" "About One Day, One Step"
Build-Preview "looking-back.html" "preview-looking-back.html" "Looking Back | One Day, One Step"

Write-Host "Done"

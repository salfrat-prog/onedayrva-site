$ErrorActionPreference = "Stop"
$scratch = "C:\Users\jilli\AppData\Local\Temp\claude\C--Users-jilli--claude\b75addd0-332a-497b-a0aa-39d9786acc26\scratchpad"
$src = "$scratch\repairfair-body.html"
$logoDir = "C:\Users\jilli\Documents\onedayrva-site\images\orgs"
New-Item -ItemType Directory -Force -Path $logoDir | Out-Null

$text = [System.IO.File]::ReadAllText($src)

$cardPattern = [regex]'(?s)<article class="org-card"[^>]*>(.*?)</article>'
$namePattern = [regex]'(?s)<h3 class="org-name">(.*?)</h3>'
$descPattern = [regex]'(?s)<p class="org-desc">(.*?)</p>'
$logoPattern = [regex]'<img class="org-logo" src="(data:image/[^;]+;base64,[^"]+)"'
$linkPattern = [regex]'<a href="([^"]+)" target="_blank" rel="noopener">([^<]*)</a>'

function Slugify($s) {
  $s = $s.ToLower()
  $s = $s -replace '&#39;', ''
  $s = $s -replace '[^a-z0-9]+', '-'
  $s = $s.Trim('-')
  return $s
}

function Decode($s) {
  return [System.Net.WebUtility]::HtmlDecode($s)
}

$results = @()
$i = 0
foreach ($m in $cardPattern.Matches($text)) {
  $i++
  $block = $m.Groups[1].Value
  $name = Decode(($namePattern.Match($block).Groups[1].Value).Trim())
  $descMatch = $descPattern.Match($block)
  $desc = if ($descMatch.Success) { Decode($descMatch.Groups[1].Value.Trim()) } else { "" }
  $logoMatch = $logoPattern.Match($block)
  $slug = Slugify($name)
  $logoFile = $null
  if ($logoMatch.Success) {
    $dataUri = $logoMatch.Groups[1].Value
    if ($dataUri -match '^data:image/([a-zA-Z0-9.+-]+);base64,(.+)$') {
      $ext = $Matches[1] -replace 'svg\+xml','svg'
      $b64 = $Matches[2]
      $bytes = [System.Convert]::FromBase64String($b64)
      $logoFile = "$slug.$ext"
      [System.IO.File]::WriteAllBytes("$logoDir\$logoFile", $bytes)
    }
  }
  $links = @()
  foreach ($lm in $linkPattern.Matches($block)) {
    $links += [PSCustomObject]@{ href = $lm.Groups[1].Value; text = Decode($lm.Groups[2].Value.Trim()) }
  }
  $results += [PSCustomObject]@{
    index = $i
    name = $name
    slug = $slug
    desc = $desc
    logoFile = $logoFile
    links = $links
  }
}

$results | ConvertTo-Json -Depth 5 | Set-Content -Path "$scratch\orgs.json" -Encoding UTF8
Write-Host "Extracted $($results.Count) orgs"
$results | ForEach-Object { Write-Host "$($_.index). $($_.name) -> logo=$($_.logoFile) links=$($_.links.Count)" }

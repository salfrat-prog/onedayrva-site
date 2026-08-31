$ErrorActionPreference = "Stop"
$scratch = "C:\Users\jilli\AppData\Local\Temp\claude\C--Users-jilli--claude\b75addd0-332a-497b-a0aa-39d9786acc26\scratchpad"
$root = "C:\Users\jilli\Documents\onedayrva-site"

$orgs = Get-Content "$scratch\orgs.json" -Raw | ConvertFrom-Json

function Enc($s) { [System.Net.WebUtility]::HtmlEncode($s) }

$cards = New-Object System.Text.StringBuilder
foreach ($o in $orgs) {
  $searchBits = (Enc($o.name)) + " " + (Enc($o.desc))
  $searchAttr = $searchBits.ToLower()
  [void]$cards.AppendLine("      <article class=`"org-card`" data-search=`"$searchAttr`">")
  [void]$cards.AppendLine("        <div class=`"org-head`">")
  [void]$cards.AppendLine("          <img class=`"org-logo`" src=`"images/orgs/$($o.logoFile)`" alt=`"$(Enc($o.name)) logo`" loading=`"lazy`">")
  [void]$cards.AppendLine("          <h3 class=`"org-name`">$(Enc($o.name))</h3>")
  [void]$cards.AppendLine("        </div>")
  [void]$cards.AppendLine("        <p class=`"org-desc`">$(Enc($o.desc))</p>")
  [void]$cards.AppendLine("        <div class=`"org-links`">")
  foreach ($l in $o.links) {
    [void]$cards.AppendLine("          <a href=`"$($l.href)`" target=`"_blank`" rel=`"noopener`">$(Enc($l.text))</a>")
  }
  [void]$cards.AppendLine("        </div>")
  [void]$cards.AppendLine("      </article>")
}
$cardsHtml = $cards.ToString()
$count = $orgs.Count

$page = @"
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Repair Fair | One Day, One Step</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Directory of $count Richmond nonprofits and ministries at the One Day, One Step Repair Fair.">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Big+Shoulders+Display:wght@500;600;700;800&family=Source+Serif+4:opsz,wght@8..60,400;8..60,500;8..60,600&family=Source+Serif+4:ital,wght@1,400&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/site.css">
</head>
<body>

<nav class="site" aria-label="Primary">
  <div class="wrap">
    <a class="back-link" href="https://www.onedayrva.org" target="_blank" rel="noopener">&larr; Back to One Day, One Step</a>
  </div>
</nav>

<header class="masthead">
  <div class="wrap">
    <p class="eyebrow mono">RICHMOND, VIRGINIA &middot; FAITH &amp; COMMUNITY PARTNERS</p>
    <h1 class="title">Repair <span class="thread-underline">Fair</span></h1>
    <p class="lede">The following ministries and nonprofits are working tirelessly across our region to address deep needs in housing, healthcare, education, and racial healing.</p>
    <div class="meta-row">
      <span><strong>$count</strong> partner organizations</span>
      <span>Immediately follows the Service of Repentance and Healing</span>
    </div>
  </div>
</header>

<div class="wrap search-block">
  <div class="search-box">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
    <input id="search" type="text" placeholder="Search by name, focus area, or keyword&hellip;" aria-label="Search organizations">
  </div>
  <p id="result-count" class="mono"></p>
</div>

<section id="directory">
  <div class="wrap">
    <div class="section-head">
      <h2 class="section-title">Organization Directory</h2>
      <span class="section-count mono" id="directory-total">$count organizations</span>
    </div>
    <p class="section-note">Each entry links out to the organization&rsquo;s own site &mdash; that&rsquo;s the best source for current programs, volunteer needs, and how to give.</p>
  </div>
  <div class="wrap">
    <div class="org-grid" id="org-grid">
$cardsHtml    </div>
    <p class="empty-state" id="empty-state">No organizations match that search.</p>
  </div>
</section>

<div class="seam"></div>

<section id="next">
  <div class="wrap">
    <div class="callout">
      <div>
        <p class="callout-label">Save the date</p>
        <p class="callout-title">One Day, One Step 2026</p>
      </div>
      <a class="btn btn-primary" href="https://www.onedayrva.org/event-details/one-day-one-step-2026" target="_blank" rel="noopener">Register for Sept 12</a>
    </div>
  </div>
</section>

<footer class="site-footer">
  <div class="wrap footer-grid">
    <div>
      <p class="footer-label">One Day, One Step</p>
      <p>A multi-church collaboration seeking racial healing for Richmond, Virginia through corporate, intercessory prayer.</p>
    </div>
    <div>
      <p class="footer-label">Site</p>
      <nav>
        <a href="https://www.onedayrva.org" target="_blank" rel="noopener">Home</a>
        <a href="https://www.onedayrva.org" target="_blank" rel="noopener">About</a>
        <a href="https://www.onedayrva.org/event-details/one-day-one-step-2026" target="_blank" rel="noopener">Event &amp; Register</a>
        <a href="http://www.renewingrva.org" target="_blank" rel="noopener">Donate</a>
      </nav>
    </div>
    <div>
      <p class="footer-label">Contact</p>
      <p><a href="mailto:renewingrva@gmail.com">renewingrva@gmail.com</a></p>
      <p>Renewing RVA is the fiscal sponsor for One Day, One Step.</p>
    </div>
  </div>
  <div class="footer-bottom wrap">
    &copy; 2026 One Day, One Step &middot; Richmond, VA
  </div>
</footer>

<script>
(function(){
  var input = document.getElementById('search');
  var cards = Array.prototype.slice.call(document.querySelectorAll('.org-card'));
  var empty = document.getElementById('empty-state');
  var count = document.getElementById('result-count');

  function render(){
    var q = input.value.trim().toLowerCase();
    var visible = 0;
    cards.forEach(function(card){
      var match = !q || (card.getAttribute('data-search') || '').indexOf(q) !== -1;
      card.classList.toggle('is-hidden', !match);
      if (match) visible++;
    });
    empty.classList.toggle('show', visible === 0);
    count.textContent = q ? (visible + ' of ' + cards.length + ' shown') : '';
  }

  input.addEventListener('input', render);
  render();
})();
</script>

</body>
</html>
"@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText("$root\repair-fair.html", $page, $utf8NoBom)
Write-Host "Wrote repair-fair.html ($([math]::Round((Get-Item "$root\repair-fair.html").Length/1kb,1)) KB)"

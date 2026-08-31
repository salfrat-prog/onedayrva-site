$ErrorActionPreference = "Stop"
$scratch = "C:\Users\jilli\AppData\Local\Temp\claude\C--Users-jilli--claude\b75addd0-332a-497b-a0aa-39d9786acc26\scratchpad"
$root = "C:\Users\jilli\Documents\onedayrva-site"

$orgs = Get-Content "$scratch\orgs.json" -Raw | ConvertFrom-Json

function Enc($s) { [System.Net.WebUtility]::HtmlEncode($s) }

$cards = New-Object System.Text.StringBuilder
foreach ($o in $orgs) {
  $searchBits = (Enc($o.name)) + " " + (Enc($o.desc))
  $searchAttr = $searchBits.ToLower()
  [void]$cards.AppendLine("      <article class=`"org-card`" data-search=`"$searchAttr`" data-categories=`"$($o.categories)`">")
  [void]$cards.AppendLine("        <div class=`"org-head`">")
  [void]$cards.AppendLine("          <img class=`"org-logo`" src=`"images/orgs/$($o.logoFile)`" alt=`"$(Enc($o.name)) logo`" loading=`"lazy`">")
  [void]$cards.AppendLine("          <h3 class=`"org-name`">$(Enc($o.name))</h3>")
  [void]$cards.AppendLine("        </div>")
  [void]$cards.AppendLine("        <p class=`"org-desc`">$(Enc($o.desc))</p>")
  [void]$cards.AppendLine("        <button class=`"org-toggle`" type=`"button`">Read more +</button>")
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

<nav class="jump" aria-label="Section navigation">
  <div class="wrap">
    <a href="#directory">Directory</a>
    <a href="#sponsors">Sponsors</a>
    <a href="#thanks">Thank You</a>
    <a href="#reading">Reading List</a>
    <a href="#next">Upcoming Events</a>
  </div>
</nav>

<div class="wrap search-block">
  <div class="search-row">
    <div class="search-box">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
      <input id="search" type="text" placeholder="Search by name, focus area, or keyword&hellip;" aria-label="Search organizations">
    </div>
    <select id="category-filter" class="category-select" aria-label="Filter by category">
      <option value="">All Categories</option>
      <option value="education">Education</option>
      <option value="housing">Housing</option>
      <option value="health-healing">Health &amp; Healing</option>
      <option value="basic-needs">Basic Needs</option>
      <option value="youth-family">Youth &amp; Family</option>
      <option value="racial-reconciliation">Racial Reconciliation &amp; Justice</option>
      <option value="leadership-community">Leadership &amp; Community</option>
    </select>
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

<section id="sponsors">
  <div class="wrap">
    <div class="section-head">
      <h2 class="section-title">Sponsors</h2>
    </div>
    <div class="pill-row">
      <span class="pill">Arrabon</span>
      <span class="pill">Cornelius Corp</span>
      <span class="pill">East End Fellowship</span>
      <span class="pill">First English Lutheran Church</span>
      <span class="pill">Mt. Gilead Full Gospel International Ministries</span>
      <span class="pill">RCLI</span>
      <span class="pill">Renewing RVA</span>
      <span class="pill">Richmond Hill</span>
      <span class="pill">St Giles Church</span>
      <span class="pill">St. Paul's Episcopal Church</span>
      <span class="pill">Third Church</span>
    </div>
  </div>
</section>

<section id="thanks" class="tight">
  <div class="wrap">
    <div class="section-head">
      <h2 class="section-title">Thank You</h2>
    </div>
    <p class="section-note">To the volunteers, clergy, organizers, and neighbors who made Repair Fair possible.</p>
    <div class="honor-roll">
      <div class="name">Blessing of Descendants</div>
      <div class="name">Abigail George</div>
      <div class="name">Alana Smith</div>
      <div class="name">Alan Dennison</div>
      <div class="name">Alex Sawyer</div>
      <div class="name">Rev. Benjamin Campbell</div>
      <div class="name">Brent Kemp</div>
      <div class="name">Brooke Wright</div>
      <div class="name">Cornelius Corp</div>
      <div class="name">Childcare Workers</div>
      <div class="name">Chipper Via</div>
      <div class="name">Rev. Christopher Carr</div>
      <div class="name">Chris Porter</div>
      <div class="name">Christy Collins</div>
      <div class="name">Rev. Dr. Corey Widmer</div>
      <div class="name">Dabney Varljen</div>
      <div class="name">Derrick Collins</div>
      <div class="name">Rev. Don Coleman</div>
      <div class="name">Dan Melin</div>
      <div class="name">Rev. David Bailey</div>
      <div class="name">Elisabeth Chapin</div>
      <div class="name">Erin Nogueira</div>
      <div class="name">Dr. Everett Worthington</div>
      <div class="name">First English Lutheran Church</div>
      <div class="name">Rev. Gwynn Crichton</div>
      <div class="name">Rev. Jim Melson</div>
      <div class="name">Rev. Jim Somerville</div>
      <div class="name">Jordan Maroon</div>
      <div class="name">Kevin Burtram</div>
      <div class="name">Dr. Laura Hunter</div>
      <div class="name">Lauren Comet</div>
      <div class="name">Liz Wiebe</div>
      <div class="name">Marcellus Wright</div>
      <div class="name">Marsha Miller</div>
      <div class="name">Marvin Daniel</div>
      <div class="name">Mt. Gilead Full Gospel International Ministries</div>
      <div class="name">Mt. Gilead Intercessory Prayer Team</div>
      <div class="name">Nancy Hendrickson</div>
      <div class="name">Rev. Nathan Walton</div>
      <div class="name">Octavia Tate</div>
      <div class="name">RCLI</div>
      <div class="name">Renewing RVA</div>
      <div class="name">Repair Fair Partners and Sponsors</div>
      <div class="name">Richmond Hill</div>
      <div class="name">Ryan Ramsden</div>
      <div class="name">Sal Fratanduono</div>
      <div class="name">Sheryl Finucane</div>
      <div class="name">St. Paul's Episcopal Church</div>
      <div class="name">Susan Bland</div>
      <div class="name">Rev. Tom Baynham</div>
    </div>
  </div>
</section>

<div class="seam"></div>

<section id="reading">
  <div class="wrap">
    <div class="section-head">
      <h2 class="section-title">Reading List</h2>
    </div>
    <ul class="reading-list">
      <li>
        <span class="book-title">Be the Bridge: Pursuing God's Heart for Racial Reconciliation</span>
        <span class="book-author mono">Latasha Morrison</span>
        <a class="book-buy" href="https://www.amazon.com/Be-Bridge-Pursuing-Racial-Reconciliation/dp/0525652884" target="_blank" rel="noopener">Amazon &rarr;</a>
      </li>
      <li>
        <span class="book-title">Faith, Race, and the Lost Cause: Confessions of a Southern Church</span>
        <span class="book-author mono">Christopher Alan Graham</span>
        <a class="book-buy" href="https://www.amazon.com/Faith-Race-Lost-Cause-Confessions/dp/0813948800" target="_blank" rel="noopener">Amazon &rarr;</a>
      </li>
      <li>
        <span class="book-title">Healing Racial Trauma: The Road to Resilience</span>
        <span class="book-author mono">Sheila Wise Rowe</span>
        <a class="book-buy" href="https://www.amazon.com/Healing-Racial-Trauma-Road-Resilience/dp/0830845887" target="_blank" rel="noopener">Amazon &rarr;</a>
      </li>
      <li>
        <span class="book-title">Just Mercy</span>
        <span class="book-author mono">Bryan Stevenson</span>
        <a class="book-buy" href="https://www.amazon.com/Just-Mercy-Story-Justice-Redemption/dp/081298496X" target="_blank" rel="noopener">Amazon &rarr;</a>
      </li>
      <li>
        <span class="book-title">Richmond's Unhealed History</span>
        <span class="book-author mono">Ben Campbell</span>
        <a class="book-buy" href="https://www.amazon.com/Richmonds-Unhealed-History-Benjamin-Campbell/dp/0983826404" target="_blank" rel="noopener">Amazon &rarr;</a>
      </li>
      <li>
        <span class="book-title">The Color of Compromise</span>
        <span class="book-author mono">Jemar Tisby</span>
        <a class="book-buy" href="https://www.amazon.com/Color-Compromise-American-Churchs-Complicity/dp/0310113601" target="_blank" rel="noopener">Amazon &rarr;</a>
      </li>
      <li>
        <span class="book-title">Reparations</span>
        <span class="book-author mono">Gregory Thompson &amp; Duke Kwon</span>
        <a class="book-buy" href="https://www.amazon.com/Reparations-Christian-Call-Repentance-Repair/dp/1587434504" target="_blank" rel="noopener">Amazon &rarr;</a>
      </li>
    </ul>
  </div>
</section>

<div class="seam"></div>

<section id="next">
  <div class="wrap">
    <div class="section-head">
      <h2 class="section-title">Upcoming Events</h2>
    </div>
    <div class="card-grid card-grid-4">
      <div class="card">
        <p class="card-title">CCDA National Conference</p>
        <p class="card-date mono">OCT 7&ndash;10, 2026</p>
        <p>Christian Community Development Association&rsquo;s annual gathering, held in Richmond this year.</p>
        <a class="card-link mono" href="https://ccda.org/train-connect/ccda-national-conference/" target="_blank" rel="noopener">Learn more &rarr;</a>
      </div>
      <div class="card">
        <p class="card-title">Amazing Praise</p>
        <p class="card-date mono">SEPT 15&ndash;17, 2026</p>
        <p>A 48-hour celebration of collaborative giving to Christian nonprofits across Richmond.</p>
        <a class="card-link mono" href="https://www.theamazingpraise.org/" target="_blank" rel="noopener">Learn more &rarr;</a>
      </div>
      <div class="card">
        <p class="card-title">Justice Fast RVA</p>
        <p class="card-date mono">SEPT 8 &ndash; OCT 17, 2026</p>
        <p>Praying and fasting for justice and healing in our city. 2026 proceeds benefit nonprofits fighting food insecurity in our area.</p>
        <a class="card-link mono" href="https://justicefastrva.org/" target="_blank" rel="noopener">Learn more &rarr;</a>
      </div>
      <div class="card">
        <p class="card-title">One Day, One Step 2027</p>
        <p class="card-date mono">SEPT 11, 2027</p>
        <p>Save the date &mdash; more details will be posted on the main site closer to the event.</p>
        <a class="card-link mono" href="https://www.onedayrva.org" target="_blank" rel="noopener">Visit onedayrva.org &rarr;</a>
      </div>
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
  var categorySelect = document.getElementById('category-filter');
  var cards = Array.prototype.slice.call(document.querySelectorAll('.org-card'));
  var empty = document.getElementById('empty-state');
  var count = document.getElementById('result-count');

  function render(){
    var q = input.value.trim().toLowerCase();
    var cat = categorySelect.value;
    var visible = 0;
    cards.forEach(function(card){
      var textMatch = !q || (card.getAttribute('data-search') || '').indexOf(q) !== -1;
      var cardCats = ' ' + (card.getAttribute('data-categories') || '') + ' ';
      var catMatch = !cat || cardCats.indexOf(' ' + cat + ' ') !== -1;
      var match = textMatch && catMatch;
      card.classList.toggle('is-hidden', !match);
      if (match) visible++;
    });
    empty.classList.toggle('show', visible === 0);
    count.textContent = (q || cat) ? (visible + ' of ' + cards.length + ' shown') : '';
  }

  input.addEventListener('input', render);
  categorySelect.addEventListener('change', render);
  render();

  // Collapsible org descriptions: hide the toggle on cards short enough
  // that clamping never truncated them, and wire up the rest.
  cards.forEach(function(card){
    var desc = card.querySelector('.org-desc');
    var toggle = card.querySelector('.org-toggle');
    if (!desc || !toggle) return;
    if (desc.scrollHeight <= desc.clientHeight + 1) {
      toggle.hidden = true;
      return;
    }
    toggle.addEventListener('click', function(){
      var expanded = card.classList.toggle('expanded');
      toggle.textContent = expanded ? 'Show less -' : 'Read more +';
    });
  });
})();
</script>

</body>
</html>
"@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText("$root\repair-fair.html", $page, $utf8NoBom)
Write-Host "Wrote repair-fair.html ($([math]::Round((Get-Item "$root\repair-fair.html").Length/1kb,1)) KB)"

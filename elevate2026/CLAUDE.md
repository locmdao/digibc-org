# Web Summit 2026 Site — Project Context

## What This Is
A single-page static marketing site for **DigiBC at Web Summit Vancouver 2026** (May 11–14, 2026). Promotes DigiBC's presence across Centre Stage, Film Summit, Gaming Summit, the BC Pavilion, Creative Tech Startup Island, Venture Spotlight Studios, Tech Advantage Tours, and the DigiBC Mixer.

Production URL: **https://digibc.org/elevate2026/**

## Architecture
- **Type**: Single static HTML file. No build step, no JS framework, no runtime dependencies.
- **Hosting**: Kinsta (DigiBC.org), deployed via `rsync` over SSH to `~/public_html/elevate2026/`.
- **Offline-capable**: Fonts are self-hosted (woff2). No CDN dependencies — page renders fully offline.

## File Structure
```
Web Summit 2026 Site/
├── index.html          # Entire site (1398 lines: HTML + inline <style>)
├── deploy.sh           # rsync deploy script (excludes .ttf, .DS_Store, etc.)
├── digibc-logo.png     # Placeholder (excluded from deploy; real logo is inline SVG)
└── assets/
    └── fonts/
        ├── Veneer.woff2, VeneerItalic.woff2          # 400 weight (lightest cut)
        ├── VeneerTwo.woff2, VeneerTwoItalic.woff2    # 700 weight (main cut)
        ├── VeneerThree.woff2, VeneerThreeItalic.woff2# 900 weight (heaviest cut)
        ├── VeneerExtras*.woff2                       # Dingbats/ornaments
        ├── Merriweather-{Light,Regular,Bold,Black}.woff2 + italics
        ├── Merriweather-*.ttf                        # Source TTFs (excluded from deploy)
        └── Veneer/                                   # Source files (excluded from deploy)
```

## Deployment

### Command
```bash
./deploy.sh                    # Deploy to ~/public_html/elevate2026 (default)
./deploy.sh ~/elevate2026      # Override remote path
```

### Deploy Script Details ([deploy.sh](deploy.sh))
- **Remote**: `digibccareers@35.199.174.117:17613` (Kinsta SSH)
- **Remote path**: `public_html/elevate2026` (default)
- Creates remote directory if missing (`ssh ... mkdir -p`)
- Uses `rsync -avzP --delete` to keep remote in sync with local
- **Excludes**: `.DS_Store`, `*.ttf` (only ship woff2), `assets/fonts/Veneer/` (source files), `digibc-logo.png` (placeholder), `deploy.sh` itself

## Typography System

### Veneer (Display) — Yellow Design Studio (licensed)
Three "cuts" designed to be layered together as letterpress impressions, each also works solo. Mapped to CSS weights so `font-weight: 700` auto-picks the right cut:

| Weight | Cut          | Description                       |
|--------|--------------|-----------------------------------|
| 400    | Veneer       | Lightest impression, most chipped |
| 700    | VeneerTwo    | Medium impression — main cut      |
| 900    | VeneerThree  | Heaviest impression, fewest gaps  |

`VeneerExtras` is kept as a separate family so weight rounding doesn't accidentally pick up the dingbats.

### Merriweather (Body) — Sorkin Type, OFL
4 weights × 2 styles: 300, 400, 700, 900 (each with italic).

### CSS Variables
```css
--font-display:   'Veneer', Impact, 'Oswald', sans-serif;
--font-condensed: 'Veneer', Impact, 'Oswald', sans-serif;
--font-body:      'Merriweather', Georgia, 'Times New Roman', serif;
```

## Brand Tokens (CSS Custom Properties)

| Token              | Hex       | Usage                                      |
|--------------------|-----------|--------------------------------------------|
| `--digi-black`     | `#0B0F14` | Primary dark / Tour tag                    |
| `--digi-ink`       | `#0E2A47` | Headlines (deep navy)                      |
| `--digi-ink-2`     | `#1B3A57` | Centre Stage tag bg                        |
| `--digi-blue`      | `#5BC2E7` | DigiBC light cyan accent                   |
| `--digi-blue-2`    | `#2EA8D6` | Hover/darker blue, Pavilion tag, links     |
| `--digi-pink`      | `#FF6FA9` | Gaming Summit + Spotlight accent           |
| `--digi-pink-2`    | `#FF3D87` | Gaming tag bg, hover                       |
| `--digi-green`     | `#34D399` | Film Summit accent                         |
| `--digi-green-2`   | `#10B981` | Film tag bg, hover                         |
| `--digi-gray-{900,700,500,300,100,50}` | — | Neutral ramp |

Radii: `--r-sm 6px`, `--r-md 10px`, `--r-lg 16px`. Shadow tokens `--shadow-{sm,md,lg}`.

## Page Sections (in order)

1. **Sticky top nav** — DigiBC inline-SVG logo + section anchor links. On `<800px` collapses all nav links except last (Connect CTA).
2. **Hero** — `eyebrow` + huge Veneer headline (`clamp(56px, 9vw, 124px)`) + lede + 2 CTAs + 4-stat hero meta grid.
3. **At-a-glance schedule** (`#schedule`) — 4 day cards (Mon/Tue/Wed/Thu), each color-coded with top border.
4. **Centre Stage sessions** (`#sessions`) — Navy-themed session cards.
5. **Film Summit sessions** — Green-themed (5 sessions, Wed May 13).
6. **Gaming Summit sessions** — Pink-themed (Thu May 14).
7. **BC Pavilion timetable** (`#pavilion`) — Full-width HTML table, time/programming/speakers (May 12, 9 AM–5 PM).
8. **Venture Spotlight Studios** (`#studios`) — 12 BC studio name tiles.
9. **Creative Tech Startup Island** (`#startup-island`) — Alpha track (7 companies) + Beta track (1 company).
10. **Tech Advantage Tours + DigiBC Mixer** — 3-up feature grid (Mon May 11 pre-summit).
11. **CTA / Connect** (`#connect`) — Email DigiBC + About Elevate.
12. **Partners & Funders** — Sponsor name row.
13. **Footer** — DigiBC SVG logo, Programs / Web Summit / Connect link columns.

## Component Patterns (CSS classes)

- `.container` — max-width 1180px, 24px padding
- `.section-head` + `.section-eyebrow{.green|.pink|.navy}` + `.section-title h2` + `.rule{.blue|.green|.navy}` — section header pattern
- `.tag.{centre|film|gaming|pavilion|tour}` — color-coded pill chips (matches deck tags)
- `.day-card.d{1-4}` — schedule day card with colored top border
- `.session.{film|gaming}` — session card with colored left bar (`::before` pseudo)
- `.pavilion-table` — schedule table with `.time`, `.item-title{.networking|.lunch}`, `.who` cells
- `.btn.{btn-primary|btn-secondary|btn-pink}` — pill buttons (999px radius)

## Accessibility / Conventions

- Single `<main id="top">` with semantic section landmarks
- Section anchors used by sticky nav: `#schedule`, `#sessions`, `#pavilion`, `#studios`, `#startup-island`, `#connect`
- All external links: `target="_blank" rel="noopener"`
- ARIA labels on logo links and pavilion table
- `font-display: swap` on every `@font-face` for fast paint

## Editing Notes

- All styles are inline in `<style>` inside [index.html](index.html) — there's no separate CSS file
- The DigiBC logo is an inline `<svg>` defined once with `id="digibc-logo"` and referenced via `<use href="#digibc-logo"/>` in header + footer (search `viewBox="0 0 284 51"` to find it)
- When adding sessions, copy an existing `<article class="session ...">` block — keep `tag`, `session-time`, and external Web Summit URL in sync
- When changing schedule, update both the day card list AND the BC Pavilion table separately (no shared data source)
- Stat numbers in the hero (13 sessions, 12 studios, 8 startups, 600+ investors) are hard-coded — update if counts change

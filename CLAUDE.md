# splitKbCompare

An interactive R Shiny web application for comparing split ergonomic keyboard layouts. Users can filter keyboards by specs, overlay multiple layouts at true scale with distinct colors, and download printable PDFs to compare keyboard sizes before buying or building.

Live app: https://jhelvy.shinyapps.io/splitkbcompare/

## Tech Stack

- **R Shiny** — web app framework
- **magick** — image manipulation (colorize, overlay, mosaic)
- **dplyr / readr** — data filtering and CSV loading
- **RMarkdown / knitr** — PDF generation
- **shinythemes** (cyborg) + custom CSS — dark theme UI

## Folder Structure

```
splitKbCompare/
├── ui.R                    # Shiny UI — three tabs: Compare, Keyboards, About
├── server.R                # Shiny server — filtering, image overlay, PDF download
├── global.R                # App initialization — loads libraries, data, images, palettes
├── code/
│   ├── functions.R         # Core logic: data loading, image overlay, filter functions
│   ├── uiElements.R        # UI components: filter panel, keyboard checkboxes, print controls
│   ├── printA4.Rmd         # RMarkdown template for A4 PDF output
│   ├── printLetter.Rmd     # RMarkdown template for Letter-size PDF output
│   └── makeAllPdfs.R       # Utility script to pre-generate all keyboard PDFs
├── data/
│   └── keyboards.csv       # Primary keyboard database (~70 rows, 25 columns)
├── images/
│   ├── png/                # PNG keyboard layout images (one per keyboard + scale ref)
│   ├── pdf/
│   │   ├── a4/             # Pre-generated A4 PDFs (62 keyboards)
│   │   └── letter/         # Pre-generated Letter PDFs (62 keyboards)
│   └── raw/                # Raw SVG/AI source files
├── includes/
│   ├── style.css           # Custom dark theme styles
│   └── footer.html         # App footer with links
├── keyboards.csv           # Top-level copy of the keyboard database
├── README.md               # Project documentation and contribution guide
└── .github/
    └── ISSUE_TEMPLATE/
        └── add-keyboard.md # Issue template for adding a new keyboard
```

## keyboards.csv Schema

The main data file has ~70 rows (62 active) and 25 columns:

| Column | Description |
|---|---|
| `id` | Unique keyboard ID (matches PNG filename) |
| `name` | Display name |
| `include` | 1 = shown in app, 0 = archived |
| `nKeysMin`, `nKeysMax` | Key count range |
| `numRows` | Number of rows |
| `hasNumRow`, `hasFuncRow` | Number/function row flags |
| `colStagger` | Column stagger: Aggressive / Moderate / None |
| `rowStagger` | Row stagger presence |
| `rotaryEncoder`, `wireless`, `onePiece` | Feature flags |
| `mxCompatible`, `chocV1`, `chocV2` | Switch compatibility |
| `mxSpacing`, `chocSpacing` | Spacing standard |
| `diy`, `prebuilt` | Availability |
| `openSource` | Open source flag |
| `url_source`, `url_store` | External links |
| `pdf_path_a4`, `pdf_path_letter` | Paths to pre-generated PDFs |

## How It Works

1. **Filter** — sidebar filters reduce the keyboard list by key count, row count, stagger type, switch type, features, and availability
2. **Select** — user picks keyboards from a checkbox list (sorted by name or key count)
3. **Overlay** — selected keyboard PNGs are colorized and composited via `magick::image_mosaic()`; each keyboard gets a color from the RColorBrewer Dark2 palette
4. **Print** — clicking "Print to scale" renders an RMarkdown doc to PDF (A4 or Letter, separate or combined pages, left or right half)

## Adding a New Keyboard

1. Add a row to `keyboards.csv` with `include = 1`
2. Add a PNG image to `images/png/` named `{id}.png`
3. Generate PDFs with `code/makeAllPdfs.R` and place them in `images/pdf/a4/` and `images/pdf/letter/`
4. (See `.github/ISSUE_TEMPLATE/add-keyboard.md` for the full checklist)

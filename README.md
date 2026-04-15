# Spritfill

A native iOS app for creating pixel art sprites and fill-by-number artwork — draw on a pixel canvas, recreate sprites by number, browse a built-in catalog, and share with the community.

## Features

### Canvas
Full-featured pixel art editor with 13 drawing tools: pencil, eraser, fill, eyedropper, line, rectangle, circle, gradient, dither, select, shift, flip, and pan. Supports adjustable brush sizes, shape outlines and fills, stroke thickness, horizontal and vertical symmetry, per-pixel opacity, and Apple Pencil detection with automatic finger-to-pan fallback.

### Layers
Up to 8 layers per project with per-layer visibility, opacity, undo/redo history, and real-time compositing. Layers are managed independently and composited via alpha blending for export.

### Palettes
9 built-in color palettes (Endesga 64, Endesga 32, Zughy 32, Generic 16, Pico-8, Sweetie 16, Resurrect 32, Journey 64, Spritfill 128) plus a custom palette editor with HSB color picker, hex input, and the ability to save and reuse custom palettes across projects.

### Gallery
A freeform photo-board where saved sprites are displayed as draggable, resizable thumbnails. Pinch to zoom, rearrange sprites, archive to storage, and tap to expand or export.

### Recreate (Fill by Number)
Pick any sprite — premade, community, or your own saved projects — and recreate it by painting numbered color cells. Tracks progress per session with undo/redo, and separates in-progress from finished recreations.

### Catalog
A browsable library of 80+ premade sprites across 16×16 and 32×32 sizes — characters, landscapes, items, and objects — plus community-submitted sprites fetched from Firebase. Save any catalog sprite directly to your projects.

### Community Submissions
Submit your original sprites to the community catalog via Firebase. Submissions are reviewed and, once approved, appear in the catalog for all users to browse and recreate. Daily submission limits keep the catalog curated.

### Export
Bitmap export via Core Graphics with nearest-neighbor scaling to preserve crisp pixel edges. Supports saving to Photos, sharing via the system share sheet, and automatic up-scaling so small sprites look sharp in the Photos app.

### Pro (In-App Purchase)
One-time purchase unlocking larger canvas sizes (128×128, 256×256, 512×512), extended sprite sheet formats, additional layers beyond 2, gradient/dither/select tools, the Spritfill 128 palette, and expanded custom palette limits.

## Tech Stack

| | |
|---|---|
| **Language** | Swift |
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM (Model-View-ViewModel) |
| **Concurrency** | Swift Concurrency (async/await, Task) + GCD |
| **Image Processing** | Core Graphics (CGImage, CGContext) |
| **Storage** | Local JSON files via FileManager |
| **Backend** | Firebase Firestore (community sprites, submissions) |
| **Monetization** | StoreKit 2 (non-consumable IAP) |
| **Platform** | iOS / iPadOS (iPhone & iPad) |

## Architecture

```
Spritfill/
├── Models/          ProjectData, LayerData, ProjectSettings, PremadeSprites,
│                    RecreatableArtModel, RecreateSession, StoreProducts, SubmissionModel
├── ViewModels/      CanvasVM, ToolsVM, LayerManagerVM, GalleryVM, RecreateVM,
│                    RecreateCanvasVM, CatalogVM, PaletteEditorVM, ProjectManagerVM, StoreVM
├── Views/
│   ├── Canvas/      ProjectCanvasView, ToolBarView, ColorPaletteView, LayerPanelView,
│   │                PaletteEditorView, NewProjectSetUpView, ExportView, SettingsSheet
│   ├── Gallery/     GalleryView (freeform photo-board with drag, resize, archive)
│   ├── Recreate/    RecreateView (browse, in-progress, finished tabs), RecreateCanvasView
│   ├── Catalog/     CatalogView (premade + community sprite browser)
│   └── Store/       StoreView (pro feature list, purchase, restore)
├── Classes/         LocalStorageService, RecreateStorageService, CommunitySpritesService,
│                    FirebaseSubmissionService, CustomPaletteService, DailyPromptService,
│                    StoreService, SettingsService, PremadeArtsService
├── Extensions/      Color+Hex
└── Utility/         BitmapExporter, PhotoSaver, ShareSheet, PixelGridThumbnailView
```

- **Views** contain zero processing logic — pure presentation
- **ViewModels** manage state via `ObservableObject` / `@Published` and call into services
- **Services** are singletons handling persistence, networking, and StoreKit — all processing runs off the main thread
- **Models** are `Codable` for JSON serialization and local storage

## Companion App

Spritfill is the creation companion to **Spritkit**, an iOS toolkit for pixelating photos, scaling sprites, extracting palettes, slicing sprite sheets, and previewing animations. Both apps share compatible model formats:

- Hex-based color palettes (`[String]` arrays)
- Pixel grid format (`"clear"` / `"#RRGGBB"`)
- Standardized canvas sizes (16×16 through 512×512)

This enables seamless round-trip workflows between sprite creation and sprite processing.

## License

Copyright © 2026 Eddy Wu. All rights reserved. See [LICENSE](LICENSE) for details.

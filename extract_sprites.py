#!/usr/bin/env python3
"""
Extract user-created sprites from Spritfill simulator and convert to PremadeSpriteData Swift code.

Usage:
  python3 extract_sprites.py            # List all projects
  python3 extract_sprites.py <name>     # Export a specific project by name (or partial match)
  python3 extract_sprites.py --all      # Export all projects
"""

import json
import glob
import sys
import os
import re
from collections import Counter

PROJECTS_GLOB = os.path.expanduser(
    "~/Library/Developer/CoreSimulator/Devices/*/data/Containers/Data/Application/*/Documents/SpritfillProjects/*.json"
)

# Canvas size mapping (width, height) -> Swift enum case
CANVAS_SIZES = {
    (16, 16): ".smallSquare",
    (16, 32): ".tallRect",
    (32, 16): ".wideRect",
    (32, 32): ".mediumSquare",
    (64, 64): ".largeSquare",
    (128, 128): ".xLargeSquare",
}


def load_projects():
    """Load all projects from all simulator instances."""
    projects = []
    for path in glob.glob(PROJECTS_GLOB):
        try:
            with open(path) as f:
                data = json.load(f)
            projects.append((path, data))
        except Exception as e:
            pass
    return projects


def detect_canvas_size(settings):
    """Extract canvas dimensions from project settings."""
    cs = settings.get("selectedCanvasSize", "")
    # The enum is stored as a string like "smallSquare"
    size_map = {
        "smallSquare": (16, 16),
        "tallRect": (16, 32),
        "wideRect": (32, 16),
        "mediumSquare": (32, 32),
        "largeSquare": (64, 64),
        "xLargeSquare": (128, 128),
    }
    return size_map.get(cs, (16, 16)), cs


def to_swift_var_name(name):
    """Convert a project name to a valid Swift variable name."""
    # Remove special chars, camelCase
    words = re.sub(r'[^a-zA-Z0-9 ]', '', name).split()
    if not words:
        return "sprite"
    result = words[0].lower()
    for w in words[1:]:
        result += w.capitalize()
    return result


def generate_swift(data, var_name=None, group=None, group_order=0):
    """Generate PremadeSpriteData Swift code from project JSON."""
    name = data["name"]
    pixels = data["pixelGrid"]
    settings = data.get("settings", {})
    (width, height), cs_key = detect_canvas_size(settings)
    cs_swift = CANVAS_SIZES.get((width, height), ".smallSquare")
    
    if var_name is None:
        var_name = to_swift_var_name(name)
    
    # Find unique colors (excluding "clear")
    unique_colors = []
    seen = set()
    for hex_val in pixels:
        h = hex_val.lower()
        if h not in seen and h != "clear":
            seen.add(h)
            unique_colors.append(hex_val)
    
    # Create short variable names for each color
    color_vars = {}
    color_vars["clear"] = "c"
    var_letters = "abdefghijklmnpqrtuvwxyz"  # skip 'c' (used for clear) and common conflicts
    idx = 0
    for hex_val in unique_colors:
        if idx < len(var_letters):
            color_vars[hex_val.lower()] = var_letters[idx]
        else:
            color_vars[hex_val.lower()] = f"c{idx}"
        idx += 1
    
    # Build Swift output
    lines = []
    sprite_id = var_name.lower()
    
    lines.append(f'    static let {var_name}: PremadeSpriteData = {{')
    lines.append(f'        let c = "clear"')
    for hex_val in unique_colors:
        v = color_vars[hex_val.lower()]
        lines.append(f'        let {v} = "{hex_val.lower()}"')
    lines.append('')
    lines.append('        let grid: [String] = [')
    
    for row in range(height):
        row_pixels = []
        for col in range(width):
            idx = row * width + col
            if idx < len(pixels):
                px = pixels[idx].lower()
                row_pixels.append(color_vars.get(px, f'"{px}"'))
            else:
                row_pixels.append('c')
        
        comma = ',' if row < height - 1 else ''
        row_str = ', '.join(row_pixels)
        lines.append(f'            {row_str}{comma} // row {row}')
    
    lines.append('        ]')
    lines.append('')
    
    group_str = f', group: "{group}", groupOrder: {group_order}' if group else ''
    
    # Detect custom palette
    palette_obj = settings.get("selectedPalette", {})
    custom_colors = settings.get("customPaletteColors", [])
    
    if isinstance(palette_obj, dict) and palette_obj.get("type") == "custom" and custom_colors:
        palette_colors_str = ', '.join(f'"{c}"' for c in custom_colors)
        lines.append(f'        return PremadeSpriteData(id: "{sprite_id}", name: "{name}", canvasSize: {cs_swift}, pixelGrid: grid{group_str}, paletteColors: [{palette_colors_str}])')
    else:
        # Map string palette names to Swift enum cases
        palette_map = {
            "Endesga 64": ".endesga64",
            "Endesga 32": ".endesga32",
            "Zughy 32": ".zughy32",
            "Generic 16": ".generic16",
            "Pico-8": ".pico8",
        }
        if isinstance(palette_obj, str):
            palette_swift = palette_map.get(palette_obj, ".endesga64")
        elif isinstance(palette_obj, dict):
            palette_swift = palette_map.get(palette_obj.get("type", ""), ".endesga64")
        else:
            palette_swift = ".endesga64"
        lines.append(f'        return PremadeSpriteData(id: "{sprite_id}", name: "{name}", canvasSize: {cs_swift}, palette: {palette_swift}, pixelGrid: grid{group_str})')
    
    lines.append('    }()')
    
    return '\n'.join(lines)


def main():
    projects = load_projects()
    
    if not projects:
        print("No Spritfill projects found in simulator.")
        return
    
    # List mode
    if len(sys.argv) == 1:
        print(f"\nFound {len(projects)} project(s):\n")
        for i, (path, data) in enumerate(projects):
            name = data.get("name", "Untitled")
            settings = data.get("settings", {})
            (w, h), _ = detect_canvas_size(settings)
            pixels = data.get("pixelGrid", [])
            filled = sum(1 for p in pixels if p.lower() != "clear")
            print(f"  [{i+1}] {name} ({w}x{h}, {filled}/{len(pixels)} pixels filled)")
        print(f"\nUsage:")
        print(f"  python3 extract_sprites.py <name>   # Export by name")
        print(f"  python3 extract_sprites.py --all     # Export all")
        return
    
    # Export mode
    target = sys.argv[1]
    
    # Direct file path mode (for AirDropped files from physical device)
    if target.endswith('.json') and os.path.isfile(target):
        with open(target) as f:
            data = json.load(f)
        name = data.get("name", "Untitled")
        print(f"\n// ===== {name} =====\n")
        print(generate_swift(data))
        print()
        return
    
    if target == "--all":
        matches = projects
    else:
        matches = [(p, d) for p, d in projects if target.lower() in d.get("name", "").lower()]
    
    if not matches:
        print(f"No project matching '{target}' found.")
        return
    
    for path, data in matches:
        name = data.get("name", "Untitled")
        print(f"\n// ===== {name} =====\n")
        print(generate_swift(data))
        print()


if __name__ == "__main__":
    main()

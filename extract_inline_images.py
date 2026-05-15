#!/usr/bin/env python3
"""Extract inline base64 PNG images from a markdown file.

The script reads the input markdown file line by line, so it can handle very large
files without loading them fully into memory. It looks for reference definition
lines like:

    [image1]: <data:image/png;base64,iVBORw0KGgoAAA...>

For each matching line it writes the decoded PNG into an `images/` directory next
to the output markdown file and replaces the inline data URL with a normal file
reference:

    [image1]: images/image1.png
"""

from __future__ import annotations

import argparse
import base64
import binascii
import re
from pathlib import Path


IMAGE_LINE_RE = re.compile(
    r"^\[(?P<name>[^\]]+)\]:\s*<data:image/(?P<format>[A-Za-z0-9.+-]+);base64,(?P<data>[^>]+)>\s*$"
)


def safe_filename(name: str, fallback_index: int) -> str:
    """Convert a markdown reference label into a safe filename stem."""
    cleaned = re.sub(r"[^A-Za-z0-9._-]+", "_", name).strip("._-")
    return cleaned or f"image_{fallback_index}"


def extract_images(input_path: Path, output_path: Path) -> tuple[int, int]:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    images_dir = output_path.parent / "images"
    images_dir.mkdir(parents=True, exist_ok=True)

    extracted = 0
    line_number = 0
    used_names: set[str] = set()

    with input_path.open("r", encoding="utf-8", errors="replace") as src, output_path.open(
        "w", encoding="utf-8", newline=""
    ) as dst:
        for raw_line in src:
            line_number += 1
            line = raw_line.rstrip("\r\n")
            newline = raw_line[len(line) :]
            match = IMAGE_LINE_RE.match(line)

            if not match:
                dst.write(raw_line)
                continue

            image_format = match.group("format").lower()
            if image_format != "png":
                raise ValueError(
                    f"Line {line_number}: expected PNG image, found image/{image_format}"
                )

            label = match.group("name")
            base_name = safe_filename(label, line_number)
            file_name = f"{base_name}.png"
            counter = 2
            while file_name in used_names:
                file_name = f"{base_name}_{counter}.png"
                counter += 1
            used_names.add(file_name)

            try:
                image_bytes = base64.b64decode(match.group("data"), validate=True)
            except binascii.Error as exc:
                raise ValueError(f"Line {line_number}: invalid base64 data") from exc

            image_path = images_dir / file_name
            image_path.write_bytes(image_bytes)

            replacement = f"[{label}]: images/{file_name}{newline or '\n'}"
            dst.write(replacement)
            extracted += 1

    return extracted, line_number


def default_output_path(input_path: Path) -> Path:
    return input_path.with_name(f"{input_path.stem}_extracted{input_path.suffix}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Extract inline base64 PNG image references from a markdown file into "
            "an images directory and write a rewritten markdown file."
        )
    )
    parser.add_argument("input_markdown", type=Path, help="Path to the source markdown file")
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        help="Path for the rewritten markdown output file (default: <input>_extracted.md)",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    input_path = args.input_markdown
    output_path = args.output or default_output_path(input_path)

    if not input_path.is_file():
        raise FileNotFoundError(f"Input file not found: {input_path}")

    extracted, total_lines = extract_images(input_path, output_path)
    print(
        f"Processed {total_lines} lines, extracted {extracted} image(s) to "
        f"{output_path.parent / 'images'}"
    )
    print(f"Rewritten markdown saved to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

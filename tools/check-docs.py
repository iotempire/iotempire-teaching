#!/usr/bin/env python3
"""Validate Markdown sources in the IoTempire teaching repository.

For every Markdown file under the given paths (default: the whole
repository, skipping ``.git`` and ``untracked``) the checker verifies:

* code fences are balanced;
* relative link and image targets exist;
* fragment links (``file.md#anchor`` and ``#anchor``) resolve to an
  explicit ``<a id="...">`` or to a heading slug.

Slugs follow GitHub's algorithm: lower-case, drop punctuation and emoji,
turn spaces into hyphens, keep underscores and consecutive hyphens, and
suffix duplicate headings with ``-1``, ``-2``, ...

Usage:
    tools/check-docs.py [PATH ...]

Exit status: 0 when clean, 1 when issues are found, 2 on usage error.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote

REPO = Path(__file__).resolve().parent.parent

SKIP_DIR_NAMES = {
    ".git",
    ".hg",
    ".svn",
    ".agents",
    ".gemini",
    ".venv",
    "venv",
    "__pycache__",
    "node_modules",
    ".pio",
    ".pioenvs",
    ".direnv",
    "lms-announcements",
    "untracked",
    "build",
    "dist",
}

FENCE_RE = re.compile(r"^(`{3,}|~{3,})")
INLINE_CODE_RE = re.compile(r"(`+)(.+?)\1")
LINK_RE = re.compile(r"!?\[[^\]]*\]\(([^)\s]+)\)")
HEADING_RE = re.compile(r"^(#{1,6})\s+(.*)$")
CLOSING_HASHES_RE = re.compile(r"\s+#+\s*$")
HTML_TAG_RE = re.compile(r"<[^>]+>")
EXPLICIT_ID_RE = re.compile(r"<a\s+(?:id|name)=\"([^\"]+)\"", re.IGNORECASE)
MD_LINK_RE = re.compile(r"!?\[([^\]]*)\]\([^)]*\)")
SCHEME_RE = re.compile(r"^[a-zA-Z][a-zA-Z0-9+.-]*:")

SLUG_CACHE: dict[Path, set[str]] = {}
BASELINE = Path(__file__).resolve().parent / "check-docs-baseline.txt"


def strip_fences(lines: list[str]) -> tuple[list[str], int | None]:
    """Blank out fenced code, returning the cleaned lines and an unclosed fence line."""
    cleaned: list[str] = []
    fence: str | None = None
    fence_line: int | None = None

    for number, line in enumerate(lines, 1):
        match = FENCE_RE.match(line.lstrip())
        if fence is None:
            if match:
                fence = match.group(1)[0]
                fence_line = number
                cleaned.append("")
            else:
                cleaned.append(line)
        else:
            if match and match.group(1)[0] == fence:
                fence = None
                fence_line = None
            cleaned.append("")

    return cleaned, fence_line


def github_slug(label: str) -> str:
    """Approximate GitHub's heading slug for a rendered heading text."""
    label = HTML_TAG_RE.sub("", label)
    label = MD_LINK_RE.sub(r"\1", label)
    label = label.replace("`", "").strip().lower()
    kept = [char for char in label if char.isalnum() or char in " -_"]
    return "".join(kept).replace(" ", "-")


def anchors_for(path: Path) -> set[str]:
    """Return explicit ids plus heading slugs for a Markdown file."""
    cached = SLUG_CACHE.get(path)
    if cached is not None:
        return cached

    text = path.read_text(encoding="utf-8")
    cleaned, _ = strip_fences(text.splitlines())
    ids = set(EXPLICIT_ID_RE.findall("\n".join(cleaned)))

    seen: dict[str, int] = {}
    for line in cleaned:
        match = HEADING_RE.match(line)
        if not match:
            continue
        label = CLOSING_HASHES_RE.sub("", match.group(2))
        slug = github_slug(label)
        if not slug:
            continue
        count = seen.get(slug, 0)
        seen[slug] = count + 1
        ids.add(slug if count == 0 else f"{slug}-{count}")

    SLUG_CACHE[path] = ids
    return ids


def check_link(path: Path, raw: str, line_number: int) -> list[tuple[Path, int, str]]:
    if not raw or raw.startswith("#"):
        if raw.startswith("#") and len(raw) > 1:
            if raw[1:] not in anchors_for(path):
                return [(path, line_number, f"missing anchor: {raw}")]
        return []

    if raw.startswith("//") or raw.startswith("/") or SCHEME_RE.match(raw):
        return []

    target_part, _, fragment = raw.partition("#")
    target_part = unquote(target_part.split("?")[0])
    if not target_part:
        return []

    target = (path.parent / target_part).resolve()
    if not target.exists():
        return [(path, line_number, f"missing file: {raw}")]

    if fragment and target.suffix.lower() == ".md":
        if fragment not in anchors_for(target):
            return [(path, line_number, f"missing anchor: {raw}")]

    return []


def check_file(path: Path) -> tuple[list[tuple[Path, int, str]], int]:
    text = path.read_text(encoding="utf-8")
    cleaned, unclosed = strip_fences(text.splitlines())

    issues: list[tuple[Path, int, str]] = []
    if unclosed is not None:
        issues.append((path, unclosed, "unbalanced code fence opened here"))

    links = 0
    for number, line in enumerate(cleaned, 1):
        masked = INLINE_CODE_RE.sub(lambda match: " " * len(match.group(0)), line)
        for match in LINK_RE.finditer(masked):
            links += 1
            issues.extend(check_link(path, match.group(1).strip(), number))

    return issues, links


def iter_markdown(targets: list[Path]):
    seen: set[Path] = set()
    for target in targets:
        if target.is_file():
            if target.suffix.lower() == ".md" and target not in seen:
                seen.add(target)
                yield target
            continue
        for path in sorted(target.rglob("*.md")):
            try:
                parts = path.relative_to(REPO).parts[:-1]
            except ValueError:
                parts = path.parts[:-1]
            if any(part in SKIP_DIR_NAMES or part.startswith(".") for part in parts):
                continue
            if path in seen:
                continue
            seen.add(path)
            yield path


def display(path: Path) -> str:
    try:
        return str(path.relative_to(Path.cwd()))
    except ValueError:
        return str(path)


def repo_relative(path: Path) -> str:
    try:
        return str(path.relative_to(REPO))
    except ValueError:
        return str(path)


def load_baseline() -> set[tuple[str, str]]:
    """Read known-issue entries (``repo/path|message``) from the baseline file."""
    if not BASELINE.exists():
        return set()
    entries: set[tuple[str, str]] = set()
    for line in BASELINE.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        path, separator, message = line.partition("|")
        if separator:
            entries.add((path.strip(), message.strip()))
    return entries


def main(argv: list[str]) -> int:
    targets = [Path(arg) for arg in argv[1:]] or [REPO]
    targets = [target if target.is_absolute() else (Path.cwd() / target) for target in targets]

    files = list(iter_markdown(targets))
    if not files:
        print("check-docs: no Markdown files found", file=sys.stderr)
        return 2

    issues: list[tuple[Path, int, str]] = []
    links = 0
    for path in files:
        file_issues, file_links = check_file(path)
        issues.extend(file_issues)
        links += file_links

    baseline = load_baseline()
    used: set[tuple[str, str]] = set()
    known_issues: list[tuple[Path, int, str]] = []
    new_issues: list[tuple[Path, int, str]] = []

    for path, line, message in issues:
        key = (repo_relative(path), message)
        if key in baseline:
            known_issues.append((path, line, message))
            used.add(key)
        else:
            new_issues.append((path, line, message))

    for path, line, message in known_issues:
        print(f"known  {display(path)}:{line}: {message}")
    for path, line, message in new_issues:
        print(f"{display(path)}:{line}: {message}")

    checked = {repo_relative(path) for path in files}
    stale = {entry for entry in baseline - used if entry[0] in checked}
    for path, message in sorted(stale):
        print(f"stale baseline entry: {path} | {message}")

    print()
    print(
        f"check-docs: {len(files)} files, {links} links, "
        f"{len(new_issues)} new issues, {len(known_issues)} known, {len(stale)} stale"
    )
    return 1 if new_issues or stale else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))

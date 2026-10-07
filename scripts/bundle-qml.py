#!/usr/bin/env python3
"""Bundle split QML sources into the single BarWidget.qml entry point."""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ENTRY = ROOT / "src" / "BarWidget.qml"
OUTPUT = ROOT / "BarWidget.qml"

INLINE_FILES = [
    "taskbar/TaskbarSeparator.qml",
    "taskbar/MenuSeparator.qml",
    "taskbar/MenuRow.qml",
    "taskbar/AppChip.qml",
    "taskbar/TaskbarChrome.qml",
    "taskbar/ContextMenu.qml",
    "taskbar/WindowPreview.qml",
    "taskbar/WindowThumbnail.qml",
    "settings/fields/SettingToggle.qml",
    "settings/fields/SettingDropdown.qml",
    "settings/fields/SettingNumber.qml",
    "settings/fields/SettingOptionalNumber.qml",
    "settings/fields/SettingText.qml",
    "settings/fields/PinnedMoveButton.qml",
    "settings/SettingsHub.qml",
    "settings/pages/ApplicationsPage.qml",
    "settings/pages/ClicksPage.qml",
    "settings/pages/ContentPage.qml",
    "settings/pages/ChipLayoutPage.qml",
    "settings/pages/BarPage.qml",
    "settings/pages/ColorsPage.qml",
    "settings/pages/IndicatorPage.qml",
    "settings/pages/PreviewsPage.qml",
    "settings/TaskbarSettings.qml",
]

GENERATED_HEADER = (
    "// GENERATED FILE — DO NOT EDIT.\n"
    "//\n"
    "// BarWidget.qml is produced by scripts/bundle-qml.py from:\n"
    "//   - src/BarWidget.qml and src/*.inc\n"
    "//   - taskbar/*.qml and taskbar/*.inc\n"
    "//   - settings/**/*.qml and settings/**/*.inc\n"
    "//\n"
    "// Any change you make here will be overwritten the next time the\n"
    "// bundle script runs. Edit those sources instead, then run:\n"
    "//   python3 scripts/bundle-qml.py\n"
)

WATCH_DIRS = [ROOT / "src", ROOT / "taskbar", ROOT / "settings"]
SOURCE_SUFFIXES = {".qml", ".js", ".inc"}
MAX_SOURCE_LINES = 150
INCLUDE_RE = re.compile(r"^([ \t]*)// @include[ \t]+(\S+)[ \t]*$", re.M)
RESOLVED_URL_RE = re.compile(r"Qt\.resolvedUrl\(\s*(['\"])([^'\"]+)\1\s*\)")
ROOT_TYPE_RE = re.compile(r"^([A-Za-z_][\w.]*)\s*\{")


class BundleError(Exception):
    pass


def source_paths() -> list[Path]:
    paths = [ENTRY] + [ROOT / relative for relative in INLINE_FILES]
    for directory in WATCH_DIRS:
        if not directory.is_dir():
            continue
        for path in directory.rglob("*"):
            if path.is_file() and path.suffix in SOURCE_SUFFIXES:
                paths.append(path)
    for path in ROOT.glob("*.js"):
        paths.append(path)
    unique: list[Path] = []
    seen: set[Path] = set()
    for path in paths:
        resolved = path.resolve()
        if resolved in seen:
            continue
        seen.add(resolved)
        unique.append(path)
    return unique


def expand_includes(text: str, source_file: Path, stack: tuple[Path, ...] = ()) -> str:
    resolved = source_file.resolve()
    if resolved in stack:
        raise BundleError(f"cyclic include: {source_file}")

    def replace(match: re.Match[str]) -> str:
        relative = match.group(2)
        path = (source_file.parent / relative).resolve()
        if not path.is_file():
            raise BundleError(f"missing include '{relative}' from {source_file}")
        included = expand_includes(path.read_text(), path, stack + (resolved,))
        return included.rstrip() + "\n"

    return INCLUDE_RE.sub(replace, text)


def brace_depth(text: str) -> int:
    depth = 0
    in_string = None
    escaped = False
    for char in text:
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == in_string:
                in_string = None
            continue
        if char in "'\"":
            in_string = char
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
    return depth


def check_balanced(path: Path, text: str) -> None:
    depth = brace_depth(text)
    if depth != 0:
        raise BundleError(
            f"{path.relative_to(ROOT)}: unmatched braces (depth {depth})"
        )


def check_source_lengths() -> None:
    over: list[str] = []
    for path in source_paths():
        if path.resolve() == OUTPUT.resolve():
            continue
        count = len(path.read_text().splitlines())
        if count > MAX_SOURCE_LINES:
            over.append(f"{path.relative_to(ROOT)} ({count} lines)")
    if over:
        raise BundleError(
            f"source files exceed {MAX_SOURCE_LINES} lines:\n  " + "\n  ".join(over)
        )


def split_qml(text: str) -> tuple[list[str], str]:
    lines = text.splitlines()
    imports: list[str] = []
    index = 0
    while index < len(lines):
        stripped = lines[index].strip()
        if stripped.startswith("import "):
            imports.append(stripped)
            index += 1
            continue
        if not imports and (
            not stripped
            or stripped.startswith("//")
            or stripped.startswith("/*")
            or stripped.startswith("pragma ")
        ):
            index += 1
            continue
        break
    body = "\n".join(lines[index:]).strip()
    if not body:
        raise BundleError("QML file has no root object")
    return imports, body + "\n"


def rewrite_relative_path(path: str, source_file: Path) -> str:
    if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*:", path) or path.startswith("/"):
        return path
    target = (source_file.parent / path).resolve()
    return Path(os.path.relpath(target, OUTPUT.parent)).as_posix()


def rewrite_import_line(line: str, source_file: Path) -> str:
    match = re.match(r'import\s+"([^"]+)"(.*)$', line.strip())
    if not match:
        return line
    path, rest = match.group(1), match.group(2)
    return f'import "{rewrite_relative_path(path, source_file)}"{rest}'


def keep_import(line: str, from_entry: bool) -> bool:
    stripped = line.strip()
    if not stripped.startswith("import "):
        return False
    quoted = re.match(r'import\s+"([^"]+)"', stripped)
    if not quoted:
        return True
    path = quoted.group(1)
    if path.endswith(".js"):
        return from_entry
    return False


def merge_imports(groups: list[tuple[list[str], bool, Path]]) -> list[str]:
    merged: list[str] = []
    seen: set[str] = set()
    for imports, from_entry, source_file in groups:
        for line in imports:
            if not keep_import(line, from_entry):
                continue
            rewritten = rewrite_import_line(line, source_file) if from_entry else line
            if rewritten in seen:
                continue
            seen.add(rewritten)
            merged.append(rewritten)

    def rank(line: str) -> tuple[int, str]:
        if line.startswith('import "'):
            return (3, line)
        if line.startswith("import qs."):
            return (2, line)
        if line.startswith("import Quickshell"):
            return (1, line)
        return (0, line)

    return sorted(merged, key=rank)


REQUIRED_TASKBAR_RE = re.compile(r"^[ \t]*required property var taskbar\s*\n", re.M)
TASKBAR_SELF_BIND_RE = re.compile(r"^[ \t]*taskbar:\s*taskbar\s*\n", re.M)


def drop_shadowed_taskbar_property(text: str) -> str:
    """Inline components live inside BarWidget { id: taskbar }. A nested
    `required property var taskbar` plus `taskbar: taskbar` is a self-binding
    that leaves the host unset, so chips neither click nor load icons."""
    text = REQUIRED_TASKBAR_RE.sub("", text)
    return TASKBAR_SELF_BIND_RE.sub("", text)


def rewrite_resolved_urls(text: str, source_file: Path) -> str:
    def replace(match: re.Match[str]) -> str:
        quote, url = match.group(1), match.group(2)
        if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*:", url) or url.startswith("/"):
            return match.group(0)
        relative = rewrite_relative_path(url, source_file)
        return f"Qt.resolvedUrl({quote}{relative}{quote})"

    return RESOLVED_URL_RE.sub(replace, text)


def wrap_component(name: str, body: str) -> str:
    stripped = body.strip()
    match = ROOT_TYPE_RE.match(stripped)
    if not match:
        raise BundleError(f"{name}: could not find a root QML type")
    return f"component {name}: {stripped}\n"


def indent_block(text: str, spaces: int = 4) -> str:
    pad = " " * spaces
    lines = []
    for line in text.splitlines():
        lines.append(pad + line if line.strip() else "")
    return "\n".join(lines) + "\n"


def insert_components(entry_body: str, components: str) -> str:
    body = entry_body.rstrip()
    if not body.endswith("}"):
        raise BundleError("src/BarWidget.qml does not end with a closing brace")
    return body[:-1].rstrip() + "\n\n" + components.rstrip() + "\n}\n"


def qmlformat_path() -> str | None:
    return shutil.which("qmlformat")


def format_qml(text: str) -> str:
    binary = qmlformat_path()
    if not binary:
        print("warning: qmlformat not found; writing unformatted output", file=sys.stderr)
        return text
    with tempfile.NamedTemporaryFile("w+", suffix=".qml", delete=False) as handle:
        handle.write(text)
        temp_path = Path(handle.name)
    try:
        result = subprocess.run(
            [binary, "-n", str(temp_path)],
            check=False,
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            raise BundleError(
                "qmlformat failed:\n"
                + (result.stderr.strip() or result.stdout.strip() or f"exit {result.returncode}")
            )
        formatted = result.stdout
        if not formatted.strip():
            formatted = temp_path.read_text()
        return formatted if formatted.endswith("\n") else formatted + "\n"
    finally:
        temp_path.unlink(missing_ok=True)


def ensure_header(text: str) -> str:
    stripped = text.lstrip("\n")
    if stripped.startswith(GENERATED_HEADER):
        return stripped if stripped.endswith("\n") else stripped + "\n"
    return GENERATED_HEADER + "\n" + stripped


def bundle() -> str:
    if not ENTRY.is_file():
        raise BundleError(f"missing entry file: {ENTRY}")
    check_source_lengths()
    groups: list[tuple[list[str], bool, Path]] = []
    entry_text = expand_includes(ENTRY.read_text(), ENTRY)
    check_balanced(ENTRY, entry_text)
    entry_imports, entry_body = split_qml(entry_text)
    groups.append((entry_imports, True, ENTRY))

    component_blocks: list[str] = []
    for relative in INLINE_FILES:
        path = ROOT / relative
        if not path.is_file():
            raise BundleError(f"missing source file: {path}")
        text = expand_includes(path.read_text(), path)
        check_balanced(path, text)
        imports, body = split_qml(text)
        groups.append((imports, False, path))
        rewritten = drop_shadowed_taskbar_property(rewrite_resolved_urls(body, path))
        wrapped = wrap_component(path.stem, rewritten)
        component_blocks.append(indent_block(wrapped))

    imports = merge_imports(groups)
    combined = (
        "\n".join(imports)
        + "\n\n"
        + insert_components(drop_shadowed_taskbar_property(entry_body), "\n".join(component_blocks))
    )
    check_balanced(OUTPUT, combined)
    return ensure_header(format_qml(combined))


def write_output(text: str) -> None:
    OUTPUT.write_text(text)


def check_output() -> int:
    generated = bundle()
    if not OUTPUT.is_file():
        print(f"{OUTPUT} is missing; run scripts/bundle-qml.py", file=sys.stderr)
        return 1
    current = OUTPUT.read_text()
    if current != generated:
        print(f"{OUTPUT.name} is stale; run python3 scripts/bundle-qml.py", file=sys.stderr)
        return 1
    print(f"{OUTPUT.name} is up to date")
    return 0


def watch() -> None:
    print(f"watching {', '.join(str(path.relative_to(ROOT)) for path in WATCH_DIRS)}")
    write_output(bundle())
    print(f"wrote {OUTPUT.relative_to(ROOT)}")
    inotifywait = shutil.which("inotifywait")
    if inotifywait:
        watch_inotify(inotifywait)
        return
    watch_poll()


def should_rebuild(path: str) -> bool:
    candidate = Path(path).resolve()
    if candidate == OUTPUT.resolve():
        return False
    if candidate.suffix not in SOURCE_SUFFIXES:
        return False
    return any(_is_relative_to(candidate, directory) for directory in WATCH_DIRS)


def _is_relative_to(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
        return True
    except ValueError:
        return False


def rebuild_from_watch() -> None:
    try:
        write_output(bundle())
        print(f"wrote {OUTPUT.relative_to(ROOT)}")
    except BundleError as error:
        print(f"bundle failed: {error}", file=sys.stderr)


def watch_inotify(binary: str) -> None:
    command = [
        binary,
        "-m",
        "-r",
        "-e",
        "close_write,create,delete,move",
        "--format",
        "%w%f",
        *[str(path) for path in WATCH_DIRS],
    ]
    process = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    assert process.stdout is not None
    try:
        while True:
            line = process.stdout.readline()
            if line == "" and process.poll() is not None:
                raise BundleError("inotifywait exited")
            path = line.strip()
            if path and should_rebuild(path):
                rebuild_from_watch()
    except KeyboardInterrupt:
        process.terminate()


def watch_poll() -> None:
    print("inotifywait not found; polling source mtimes", file=sys.stderr)
    stamp = source_mtime()
    try:
        while True:
            time.sleep(0.4)
            current = source_mtime()
            if current != stamp:
                stamp = current
                rebuild_from_watch()
    except KeyboardInterrupt:
        return


def source_mtime() -> float:
    return max(path.stat().st_mtime for path in source_paths() if path.is_file())


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        action="store_true",
        help="exit non-zero if BarWidget.qml does not match the bundled sources",
    )
    parser.add_argument(
        "--watch",
        action="store_true",
        help="rebuild BarWidget.qml when source QML files change",
    )
    args = parser.parse_args()
    try:
        if args.check and args.watch:
            raise BundleError("use either --check or --watch, not both")
        if args.check:
            return check_output()
        if args.watch:
            watch()
            return 0
        write_output(bundle())
        print(f"wrote {OUTPUT.relative_to(ROOT)}")
        return 0
    except BundleError as error:
        print(error, file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())

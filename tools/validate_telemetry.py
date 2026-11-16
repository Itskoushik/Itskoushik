"""Validate generated telemetry SVGs before the workflow commits them."""

from pathlib import Path
import argparse
import xml.etree.ElementTree as ET


FILES = (
    Path("assets/telemetry/github-stats.svg"),
    Path("assets/telemetry/top-languages.svg"),
    Path("assets/telemetry/github-streak.svg"),
)
ERROR_MARKERS = ("something went wrong", "error fetching", "rate limit exceeded")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--allow-pending",
        action="store_true",
        help="allow the clearly labelled initial cards during local setup checks",
    )
    args = parser.parse_args()
    readme = Path("README.md").read_text(encoding="utf-8")
    for path in FILES:
        if not path.is_file():
            raise SystemExit(f"Missing telemetry asset: {path}")
        try:
            root = ET.parse(path).getroot()
        except ET.ParseError as exc:
            raise SystemExit(f"Invalid SVG XML in {path}: {exc}") from exc
        if root.tag != "{http://www.w3.org/2000/svg}svg":
            raise SystemExit(f"Unexpected document root in {path}: {root.tag}")
        if root.get("width") != "380" or root.get("height") != "190":
            raise SystemExit(f"Unexpected dimensions in {path}; expected 380x190")
        content = path.read_text(encoding="utf-8").lower()
        if f"{path.as_posix()}\"" not in readme:
            raise SystemExit(f"README.md does not reference {path}")
        if not args.allow_pending and "awaiting first workflow run" in content:
            raise SystemExit(f"Generation did not replace the setup card: {path}")
        if any(marker in content for marker in ERROR_MARKERS):
            raise SystemExit(f"Error card detected in {path}")
        if "#f2ebdd" not in content or "#191715" not in content or "#51483b" not in content:
            raise SystemExit(f"Expected Project Kōdan palette missing from {path}")
        print(f"Validated {path} (380x190 SVG)")


if __name__ == "__main__":
    main()

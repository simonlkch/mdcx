#!/usr/bin/env python3
"""
MDCx CLI - Command-line interface for running the scraper.

Usage:
    python cli.py
"""

import sys

from mdcx.core.scraper import cli_main


def main():
    try:
        cli_main()
    except KeyboardInterrupt:
        print("\n⛔️  Scraping interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Fatal error: {str(e)}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()

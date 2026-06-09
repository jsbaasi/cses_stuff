'''
Create an Anki note for a solved CSES problem.

Front  : problem number + link + your categories
Back   : your sol.cpp, syntax-highlighted, on a blue background
Tags   : the categories you enter

How it works:
    AnkiConnect (addon 2055492159) runs an HTTP server *inside* the Anki app
    on http://localhost:8765, but only while Anki is open. There is no separate
    server to start: just have the Anki desktop app open, then run this script.

One-time setup:
    1. Anki -> Tools -> Add-ons -> Get Add-ons -> code 2055492159 -> restart Anki
    2. pip install Pygments

Usage:
    python anki.py <id>      (or just: python anki.py  and it will prompt)
'''
import sys
import json
import urllib.request
import urllib.error
from pathlib import Path

# ---- tweak these to taste -------------------------------------------------
DECK = "CSES"
MODEL = "Basic"                 # uses fields "Front" and "Back"
ANKICONNECT = "http://localhost:8765"
PROBLEM_URL = "https://cses.fi/problemset/task/{id}"
BACK_BG = "#cfe2ff"             # the "blue" background of the reverse side
PYGMENTS_STYLE = "friendly"     # light theme, reads well on light blue
LANG = "cpp"
# ---------------------------------------------------------------------------


def highlight(code: str) -> str:
    """Render code -> standalone highlighted HTML using Pygments inline styles."""
    try:
        from pygments import highlight as pyg_highlight
        from pygments.lexers import get_lexer_by_name
        from pygments.formatters import HtmlFormatter
    except ImportError:
        sys.exit("Pygments is not installed. Run:  pip install Pygments")

    lexer = get_lexer_by_name(LANG)
    # noclasses=True inlines all CSS so the note renders without editing the
    # note type's styling. The Syntax Highlighting (NG) addon uses Pygments too,
    # so this looks like what that addon would produce.
    formatter = HtmlFormatter(noclasses=True, style=PYGMENTS_STYLE)
    return pyg_highlight(code, lexer, formatter)


def invoke(action: str, **params):
    """Call an AnkiConnect action; raise on error."""
    payload = json.dumps({"action": action, "version": 6, "params": params}).encode()
    req = urllib.request.Request(ANKICONNECT, payload)
    try:
        resp = json.loads(urllib.request.urlopen(req, timeout=5).read().decode())
    except urllib.error.URLError:
        sys.exit(
            "Could not reach AnkiConnect at " + ANKICONNECT + ".\n"
            "Make sure the Anki desktop app is OPEN and the AnkiConnect addon\n"
            "(code 2055492159) is installed."
        )
    if resp.get("error") is not None:
        sys.exit(f"AnkiConnect error: {resp['error']}")
    return resp["result"]


def main():
    pid = sys.argv[1] if len(sys.argv) > 1 else input("enter id: ").strip()
    sol = Path(pid) / "sol.cpp"
    if not sol.exists():
        sys.exit(f"no solution found at {sol}")

    cats_raw = input("categories (comma separated): ").strip()
    cats = [c.strip() for c in cats_raw.split(",") if c.strip()]

    code = sol.read_text()
    url = PROBLEM_URL.format(id=pid)

    front = (
        f"<div>CSES Problem <b>{pid}</b></div>"
        f"<div><a href='{url}'>{url}</a></div>"
        + (f"<div>Categories: {', '.join(cats)}</div>" if cats else "")
    )
    back = (
        f"<div style='background:{BACK_BG}; padding:12px; border-radius:8px; "
        f"text-align:left;'>{highlight(code)}</div>"
    )

    # make sure the deck exists, then add the note
    invoke("createDeck", deck=DECK)
    note_id = invoke(
        "addNote",
        note={
            "deckName": DECK,
            "modelName": MODEL,
            "fields": {"Front": front, "Back": back},
            "tags": cats,
            "options": {"allowDuplicate": False,
                        "duplicateScope": "deck"},
        },
    )
    print(f"created note {note_id} in deck '{DECK}' with tags {cats}")


if __name__ == "__main__":
    main()

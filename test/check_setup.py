"""Prints one line per problem with the generator link in a generated project's SETUP.md.

A later session resumes setup from that link, so it must be a raw GitHub URL pinned to a
commit, or a local copy of the generator that exists.
"""

import os
import re
import sys
import urllib.error
import urllib.request

PINNED_URL = re.compile(r"https://raw\.githubusercontent\.com/[^/\s]+/[^/\s]+/[0-9a-f]{40}/GENERATOR\.md")

# Delimited forms come first so that a path with spaces is read whole, not as a bare tail.
LINK_PATTERNS = [
    re.compile(r"\]\(<([^>\n]*GENERATOR\.md)>\)"),  # [text](</path with spaces/GENERATOR.md>)
    re.compile(r"\]\(([^)\s]*GENERATOR\.md)\)"),  # [text](/path/GENERATOR.md)
    re.compile(r"<([^<>\n]*GENERATOR\.md)>"),  # <https://...> or </path>
    re.compile(r"`([^`\n]*GENERATOR\.md)`"),
    re.compile(r'"([^"\n]*GENERATOR\.md)"'),
    re.compile(r"(?:^|(?<=\s))((?:https?://|/|~/)\S*GENERATOR\.md)", re.MULTILINE),
]


def links(text):
    found, taken = [], []
    for pattern in LINK_PATTERNS:
        for match in pattern.finditer(text):
            start, end = match.span()
            if any(start < t_end and t_start < end for t_start, t_end in taken):
                continue
            taken.append((start, end))
            found.append(match.group(1).strip())
    return found


def resolves(url):
    try:
        with urllib.request.urlopen(urllib.request.Request(url, method="HEAD"), timeout=15):
            return None
    except urllib.error.HTTPError as e:
        return f"returns HTTP {e.code}"
    except (urllib.error.URLError, OSError) as e:
        return f"couldn't be reached ({e})"


project = sys.argv[1]
setup = os.path.join(project, "SETUP.md")
if os.path.isfile(setup):
    with open(setup, encoding="utf-8") as f:
        text = f.read()
    if "<commit>" in text:
        print("SETUP.md doesn't name the generator commit")
    resumable = False
    for target in links(text):
        if re.match(r"https?://", target):
            if not PINNED_URL.fullmatch(target):
                print(f"SETUP.md links a generator that isn't a raw URL pinned to a commit: {target}")
            elif (error := resolves(target)) is not None:
                print(f"SETUP.md links a generator URL that {error}: {target}")
            else:
                resumable = True
        else:
            path = os.path.join(project, os.path.expanduser(target))
            if os.path.isfile(path):
                resumable = True
            else:
                print(f"SETUP.md links a generator that doesn't exist: {target}")
    if not resumable:
        print("SETUP.md doesn't link a generator to resume from")

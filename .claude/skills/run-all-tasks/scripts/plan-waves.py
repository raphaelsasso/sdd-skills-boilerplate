#!/usr/bin/env python3
"""Compute a dependency-aware wave schedule from an SDD tasks.md file.

Reads the parent-task list ("## Tasks") and the dependency table
("Depends on" column) and emits a JSON execution plan: ordered waves where
every task in a wave can run in parallel because all of its HARD dependencies
finished in an earlier wave.

Parenthetical dependencies are classified:
  - "4.0 (+3.0)"                    -> +3.0 is an extra HARD dep
  - "2.0 (optional: +6.0, +8.0)"    -> labelled parenthetical -> SOFT dep
SOFT deps are reported as notes but never block scheduling, so a task can start
as early as its hard prerequisites allow.

Usage:
    python3 plan-waves.py <path/to/tasks.md>          # JSON to stdout
    python3 plan-waves.py <path/to/tasks.md> --pretty # human-readable summary

Exit codes: 0 ok, 1 file/parse error, 2 dependency cycle detected.
"""

import argparse
import json
import re
import sys

TASK_LINE = re.compile(r"^\s*-\s*\[(?P<done>[ xX])\]\s*(?P<id>\d+\.\d+)\s+(?P<title>.+?)\s*$")
VERSION = re.compile(r"\d+\.\d+")
PAREN = re.compile(r"\(([^)]*)\)")


def fail(msg, code=1):
    sys.stderr.write(f"ERROR: {msg}\n")
    sys.exit(code)


def parse_tasks(text):
    """Return ordered dict-like list of {id, title, done} from the ## Tasks list."""
    tasks = {}
    order = []
    in_tasks = False
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("## "):
            in_tasks = stripped.lower().startswith("## tasks")
            continue
        if not in_tasks:
            continue
        m = TASK_LINE.match(line)
        if m:
            tid = m.group("id")
            tasks[tid] = {
                "id": tid,
                "title": m.group("title").strip(),
                "done": m.group("done").lower() == "x",
            }
            order.append(tid)
    return tasks, order


def parse_dependency_cell(cell):
    """Split a 'Depends on' cell into (hard_deps, soft_deps)."""
    cell = cell.strip()
    if not cell or cell in {"-", "—", "--"}:
        return [], []
    soft = []
    # Labelled parentheticals (contain ':') hold soft deps; bare ones are hard.
    bare_parens = []
    for grp in PAREN.findall(cell):
        if ":" in grp:
            soft.extend(VERSION.findall(grp))
        else:
            bare_parens.extend(VERSION.findall(grp))
    outside = PAREN.sub(" ", cell)
    hard = VERSION.findall(outside) + bare_parens
    # De-dup, preserve order.
    hard = list(dict.fromkeys(hard))
    soft = [s for s in dict.fromkeys(soft) if s not in hard]
    return hard, soft


def parse_dep_table(text, valid_ids):
    """Return {id: {'hard': [...], 'soft': [...]}} parsed from the markdown table.

    Recognises the table by a row whose first cell is a task id and which has at
    least two more columns (Depends on, Parallelizable with)."""
    deps = {}
    for line in text.splitlines():
        if "|" not in line:
            continue
        cols = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cols) < 2:
            continue
        first = cols[0]
        if not re.fullmatch(r"\d+\.\d+", first):
            continue
        if first not in valid_ids:
            continue
        hard, soft = parse_dependency_cell(cols[1])
        # Only keep deps that are real tasks.
        hard = [d for d in hard if d in valid_ids and d != first]
        soft = [d for d in soft if d in valid_ids and d != first]
        deps[first] = {"hard": hard, "soft": soft}
    return deps


def compute_levels(ids, hard_deps):
    """Longest-path level per task over hard deps. Raises on cycle."""
    level = {}
    visiting = set()

    def resolve(tid, stack):
        if tid in level:
            return level[tid]
        if tid in visiting:
            cycle = " -> ".join(stack + [tid])
            fail(f"dependency cycle detected: {cycle}", code=2)
        visiting.add(tid)
        deps = [d for d in hard_deps.get(tid, []) if d in ids]
        lvl = 0 if not deps else 1 + max(resolve(d, stack + [tid]) for d in deps)
        visiting.discard(tid)
        level[tid] = lvl
        return lvl

    for tid in ids:
        resolve(tid, [])
    return level


def build_plan(path):
    try:
        with open(path, "r", encoding="utf-8") as fh:
            text = fh.read()
    except OSError as exc:
        fail(f"cannot read tasks file '{path}': {exc}")

    tasks, order = parse_tasks(text)
    if not tasks:
        fail("no parent tasks found under a '## Tasks' heading")

    valid_ids = set(tasks)
    deps = parse_dep_table(text, valid_ids)
    warnings = []

    if not deps:
        # Fallback: no dependency table -> strictly sequential by numeric order.
        warnings.append(
            "No dependency table found; falling back to sequential execution by task number."
        )
        seq = sorted(order, key=lambda t: tuple(int(p) for p in t.split(".")))
        deps = {tid: {"hard": [seq[i - 1]] if i else [], "soft": []} for i, tid in enumerate(seq)}

    hard = {tid: deps.get(tid, {}).get("hard", []) for tid in tasks}
    soft = {tid: deps.get(tid, {}).get("soft", []) for tid in tasks}

    levels = compute_levels(list(tasks), hard)

    # Group into waves by level, sorted within a wave by task number.
    def sort_key(t):
        return tuple(int(p) for p in t.split("."))

    waves = {}
    for tid, lvl in levels.items():
        waves.setdefault(lvl, []).append(tid)

    wave_list = []
    for idx, lvl in enumerate(sorted(waves)):
        members = sorted(waves[lvl], key=sort_key)
        wave_list.append(
            {
                "wave": idx,
                "tasks": [
                    {
                        "id": tid,
                        "title": tasks[tid]["title"],
                        "done": tasks[tid]["done"],
                        "hard_deps": hard[tid],
                        "soft_deps": soft[tid],
                    }
                    for tid in members
                ],
            }
        )

    for tid in tasks:
        if soft[tid]:
            warnings.append(
                f"Task {tid} has soft deps {soft[tid]} (full functionality may need them; not blocking)."
            )

    return {
        "tasks_file": path,
        "total_tasks": len(tasks),
        "pending_tasks": sum(1 for t in tasks.values() if not t["done"]),
        "waves": wave_list,
        "warnings": warnings,
    }


def pretty(plan):
    lines = [f"Execution plan for {plan['tasks_file']}",
             f"{plan['total_tasks']} tasks total, {plan['pending_tasks']} pending, "
             f"{len(plan['waves'])} waves.", ""]
    for wave in plan["waves"]:
        parallel = len([t for t in wave["tasks"] if not t["done"]])
        lines.append(f"Wave {wave['wave']}  ({parallel} in parallel):")
        for t in wave["tasks"]:
            mark = "[x]" if t["done"] else "[ ]"
            dep = f"  deps: {', '.join(t['hard_deps'])}" if t["hard_deps"] else ""
            soft = f"  soft: {', '.join(t['soft_deps'])}" if t["soft_deps"] else ""
            lines.append(f"  {mark} {t['id']} {t['title']}{dep}{soft}")
        lines.append("")
    if plan["warnings"]:
        lines.append("Notes:")
        lines.extend(f"  - {w}" for w in plan["warnings"])
    return "\n".join(lines)


def main():
    ap = argparse.ArgumentParser(description="Compute a wave schedule from a tasks.md file.")
    ap.add_argument("tasks_file", help="Path to the SDD tasks.md file.")
    ap.add_argument("--pretty", action="store_true", help="Human-readable output instead of JSON.")
    args = ap.parse_args()

    plan = build_plan(args.tasks_file)
    if args.pretty:
        print(pretty(plan))
    else:
        print(json.dumps(plan, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()

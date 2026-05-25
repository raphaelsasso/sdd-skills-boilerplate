# Troubleshooting the wave planner

Recovery steps for failures from `scripts/plan-waves.py` and from wave execution.

## Planner exit code 1 — parse / file error

Cause: the file path is wrong, the file is unreadable, or there is no parent-task
list under a `## Tasks` heading.

Fix:
- Confirm the path points at a real SDD `tasks.md` (e.g. `tasks/prd-[feature]/tasks.md`).
- Confirm the task list uses checkbox lines like `- [ ] 1.0 Title` under a `## Tasks` heading.
- If the file uses a different task-id format (not `N.N`), the planner will not detect tasks; align the file with the SDD `create-tasks` output.

## Planner exit code 2 — dependency cycle

Cause: the "Depends on" column forms a loop (e.g. A depends on B and B depends on A).

Fix:
- The planner prints the cycle path (`A -> B -> A`). Open `tasks.md` and correct the
  dependency table so dependencies form a DAG.
- Do NOT invent an execution order to work around a cycle — the wrong order will
  build tasks before their prerequisites exist.

## No dependency table found

The planner falls back to strict sequential execution (one task per wave) and warns.
This is correct but slow. To regain parallelism, add the "Dependencies and Parallelization"
table to `tasks.md` with a `Depends on` column listing each task's prerequisites.

## Dependency-cell syntax the planner understands

- `—` or empty → no dependencies.
- `2.0` → hard dependency on 2.0.
- `4.0 (+3.0)` → hard dependencies on 4.0 and 3.0 (bare parenthetical = hard).
- `2.0 (optional: +6.0, +8.0)` → hard dep 2.0; 6.0/8.0 are **soft** (labelled
  parenthetical, contains `:`), reported as notes and never blocking.

## A wave is larger than expected

Level-based scheduling places a task one level after its deepest hard dependency, so a
task may wait for an unrelated task in the previous wave. This is a safe, deterministic
approximation. To start a task earlier, dispatch it the moment its specific hard deps are
`done` rather than waiting for the whole previous wave — only do this if its hard deps are
confirmed complete.

## An agent finished but the checkbox is still unchecked

Treat the task as `failed`: the implementation may be incomplete or the agent forgot to
update `tasks.md`. Inspect briefly, fix the checkbox or re-dispatch the task, then re-run
the planner to refresh the `done` state before continuing.

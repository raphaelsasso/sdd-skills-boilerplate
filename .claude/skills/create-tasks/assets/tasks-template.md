# Implementation Task Summary for [Feature]

## Tasks

- [ ] 1.0 Task Title
- [ ] 2.0 Task Title
- [ ] 3.0 Task Title

## Dependencies and Parallelization

<!--
This table drives the `run-all-tasks` parallel orchestrator. Syntax for the "Depends on" cell:
  - `—` or empty            → no dependencies (can start immediately)
  - `2.0`                   → hard dependency on 2.0 (must finish first)
  - `4.0 (+3.0)`            → hard dependencies on 4.0 AND 3.0 (bare parenthetical = hard)
  - `2.0 (optional: +6.0)`  → hard dep 2.0; 6.0 is a SOFT dep (labelled parenthetical with ':') —
                              the task can start without it, but full functionality may need it
List only HARD prerequisites a task truly needs before it can begin. The fewer the dependencies,
the more tasks run in parallel. "Parallelizable with" is informational for humans.
-->

| Task | Depends on | Parallelizable with |
|---|---|---|
| 1.0 | — | — |
| 2.0 | 1.0 | 3.0 |
| 3.0 | 1.0 | 2.0 |

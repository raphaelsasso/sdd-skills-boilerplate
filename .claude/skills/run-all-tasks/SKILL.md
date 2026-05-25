---
name: run-all-tasks
description: Orchestrates end-to-end execution of an entire SDD task list. Reads a tasks.md file (e.g. tasks/prd-[feature]/tasks.md), computes a dependency-aware wave schedule, and dispatches the task-runner subagent for each task -- running independent tasks in parallel while respecting order, dependencies, and rigid chains. Isolates each task in its own subagent context to keep the orchestrator lean and finish as fast as possible. Use when a tasks.md is ready and multiple tasks should be implemented automatically in sequence and parallel. Don't use for creating PRDs, specs, or task lists, for running a single task (use run-task), or for code review and QA.
---

# Run All Tasks (Parallel Orchestrator)

Drive the implementation of a whole SDD task list by dispatching the `task-runner`
subagent per task, wave by wave, with maximum safe parallelism.

<critical>NEVER implement task code in this (orchestrator) context. Each task runs inside its own `task-runner` subagent. This is what protects the orchestrator context from degrading.</critical>
<critical>Within a wave, dispatch every parallelizable task in a SINGLE message with multiple Agent tool calls so they run concurrently. Then wait for all of them before starting the next wave.</critical>
<critical>Keep only a compact status table in this context. Do NOT read implementation diffs or full agent transcripts back into reasoning.</critical>

## Step 0: Locate the task list

1. Determine the `tasks.md` path from the caller's prompt (e.g. `tasks/prd-[feature]/tasks.md`).
2. If no path is given, search `tasks/prd-*/tasks.md`. If exactly one exists, use it. If several exist, ask the user which feature to run (use the ask user question tool). If none exist, stop and tell the user no task list was found.

## Step 1: Compute the wave schedule

1. Run the planner (it parses the task list and the "Depends on" table deterministically — do not parse the markdown by hand):
   `python3 .claude/skills/run-all-tasks/scripts/plan-waves.py <tasks_file> --pretty`
2. Run it again with JSON to drive orchestration:
   `python3 .claude/skills/run-all-tasks/scripts/plan-waves.py <tasks_file>`
3. Read the JSON `waves` array. Each wave lists tasks whose hard dependencies all completed in an earlier wave, so every pending task in a wave is safe to run in parallel.
4. Note `soft_deps` warnings: those tasks may start without their soft prerequisites, but their full functionality can depend on them — flag this in the agent prompt for that task.
5. If the planner exits non-zero, read `references/troubleshooting.md` and resolve before continuing (a dependency cycle, exit code 2, must be fixed in `tasks.md` first).

## Step 2: Confirm the plan once

1. Show the user the `--pretty` schedule: number of waves, which tasks run in parallel per wave, and the total pending count.
2. Ask for a single go-ahead to execute the whole plan (use the ask user question tool), unless the caller already said to proceed without asking or passed an explicit "run all / yes" intent.
3. Do not ask for per-task confirmation afterward — the point is to run fast.

## Step 3: Execute wave by wave

For each wave in order (lowest `wave` number first):

1. Build the runnable set: tasks in this wave with `done: false` AND with no hard dependency that is currently `failed`/`blocked`.
   - Skip tasks already `done: true` (their deps are considered satisfied).
   - Mark any task as `blocked` if a hard dependency is `failed`/`blocked`; record it and do not dispatch it.
2. Dispatch the runnable set **in one single message**, one `Agent` call per task, all with `subagent_type: "task-runner"`. Use the prompt template in Step 4. Concurrent calls in one message run in parallel.
3. Optional concurrency cap: if a wave has more than 6 runnable tasks, dispatch the first 6, wait, then dispatch the rest of that wave. Otherwise dispatch the whole wave at once.
4. Wait for every dispatched agent in the wave to return before moving on.
5. After the wave, run Step 5 (verify) and update the status table. Only then start the next wave.

## Step 4: Per-task subagent prompt

Give each `task-runner` a focused, self-contained prompt. Keep it short:

```
Execute task <ID> ("<title>") from <tasks_file>.

- Run the run-task skill for this task end to end (.claude/skills/run-task/SKILL.md).
- Consult Context7 (MCP) for any library/framework before using it.
- Hard dependencies <deps> are already implemented; build on them.
- Soft dependencies <soft_deps> may not exist yet — degrade gracefully, do not block on them.   # include only if soft_deps is non-empty
- Mark this task complete in <tasks_file> when finished.

Return ONLY a compact final report, no code dumps:
  STATUS: done | failed | blocked
  TASK: <ID>
  SUMMARY: 1-2 lines on what was implemented
  CHECKS: lint/typecheck/build/test result (pass/fail)
  BLOCKERS: anything left or reasons for failure (or "none")
```

<critical>Do not paste task source code, full file contents, or long logs into the agent prompt — point the agent at file paths and the task id instead.</critical>

## Step 5: Verify and track after each wave

1. From each agent's compact report, record one row per task in a status table held in this context: `ID | status | checks | one-line summary`. Discard the rest of the transcript.
2. Cross-check completion: confirm the task's checkbox is now `[x]` in `tasks.md`. If an agent reported `done` but the box is unchecked, mark it `failed` and note the discrepancy.
3. Handle failures:
   - A `failed`/`blocked` task does NOT halt the whole run. Continue with tasks that do not hard-depend on it.
   - Mark every not-yet-run task that hard-depends (directly or transitively) on a failed task as `blocked`.
   - If the failure is on the critical chain (e.g. `1.0 -> 2.0`, or `4.0 -> 5.0 -> 6.0 -> 7.0`), most later waves will block; surface this to the user and ask whether to retry the failed task or stop.
4. Re-running the planner between waves is safe and recommended after manual fixes — completed checkboxes are read back as `done`.

## Step 6: Final report

1. Print the final status table: every task with `done` / `failed` / `blocked`.
2. List remaining blockers and suggested next steps (e.g. "retry 5.0 then re-run from wave 4").
3. Do not run code review or QA here — recommend `run-review` / `run-qa` as the follow-up.

## Error Handling

- If `plan-waves.py` exits 1 (no `## Tasks` section / unreadable file), verify the path and that the file follows the SDD tasks format; read `references/troubleshooting.md`.
- If `plan-waves.py` exits 2 (dependency cycle), the dependency table in `tasks.md` is inconsistent — report the cycle to the user and stop; do not guess an order.
- If the dependency table is missing, the planner falls back to strict sequential order (one task per wave) and emits a warning — tell the user parallelism is disabled and why.
- If a `task-runner` returns without a recognizable STATUS line, treat the task as `failed` (do not assume success) and surface it.
- If a wave's runnable set is empty because everything is `done`, skip it; if empty because everything is `blocked`, stop and report.

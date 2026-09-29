---
on:
  workflow_dispatch:
  schedule: weekly on monday
permissions:
  contents: read
  pull-requests: read
  copilot-requests: write
engine: copilot
network: defaults
safe-outputs:
  create-pull-request:
    max: 1
    draft: true
    base-branch: main
    fallback-as-issue: false
    title-prefix: "chore(upstream): "
---

# Review PStack upstream changes

Compare this repository with `backnotprop/pstack` on its default branch. Fetch the
upstream branch and inspect every change since the common ancestor. If there is no
new upstream change, finish without opening a pull request.

Prepare one draft pull request that brings in the new upstream changes. Preserve
Plana-specific changes needed for Codex, Claude, Node, pnpm, and the shared
checkout. Resolve conflicts in favor of working behavior for both the original
Cursor use and these integrations. If a conflict needs a human decision, explain
it in the draft PR instead of silently discarding either side.

In the PR body, link the upstream commits, list any conflicts or adaptations, and
record the checks you ran. Do not merge the PR or change this workflow.

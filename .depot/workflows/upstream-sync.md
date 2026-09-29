---
on:
  workflow_dispatch:
  schedule: weekly on monday
runs-on: depot-ubuntu-latest
runs-on-slim: depot-ubuntu-latest
permissions:
  contents: read
  pull-requests: read
engine:
  id: copilot
  model: gpt-5.4-2026-03-05
  env:
    COPILOT_PROVIDER_BASE_URL: https://plana-solutions-1477-resource.services.ai.azure.com/openai/v1
    COPILOT_PROVIDER_API_KEY: ${{ secrets.AZURE_OPENAI_API_KEY }}
    COPILOT_PROVIDER_MODEL_ID: gpt-5.4
    COPILOT_PROVIDER_WIRE_API: responses
network:
  allowed:
    - defaults
    - plana-solutions-1477-resource.services.ai.azure.com
safe-outputs:
  runs-on: depot-ubuntu-latest
  threat-detection:
    runs-on: depot-ubuntu-latest
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

#!/bin/sh
set -eu

gh aw compile --dir .depot/workflows "$@"
node - <<'JS'
const fs = require('node:fs');
const depotFile = '.depot/workflows/upstream-sync.lock.yml';
const githubFile = '.github/workflows/upstream-sync.lock.yml';
const generated = fs.readFileSync(depotFile, 'utf8');
const sourcePath = '.github/workflows/upstream-sync.lock.yml';
const triggerStart = generated.indexOf('\non:\n');
const triggerEnd = generated.indexOf('\npermissions:', triggerStart);
if (!generated.includes(sourcePath) || triggerStart < 0 || triggerEnd < 0) {
  throw new Error('gh-aw output changed; inspect the compiled workflow');
}
// gh-aw activation verifies its source in .github/workflows even on Depot.
fs.mkdirSync('.github/workflows', { recursive: true });
fs.copyFileSync('.depot/workflows/upstream-sync.md', '.github/workflows/upstream-sync.md');
fs.writeFileSync(depotFile, generated.replaceAll(sourcePath, depotFile));
fs.writeFileSync(githubFile,
  generated.slice(0, triggerStart) +
  '\non:\n  push:\n    branches: [depot-workflow-disabled]\n' +
  generated.slice(triggerEnd));
JS

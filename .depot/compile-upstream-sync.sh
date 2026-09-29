#!/bin/sh
set -eu

gh aw compile --dir .depot/workflows "$@"
node - <<'JS'
const fs = require('node:fs');
const file = '.depot/workflows/upstream-sync.lock.yml';
const generated = fs.readFileSync(file, 'utf8');
const sourcePath = '.github/workflows/upstream-sync.lock.yml';
if (!generated.includes(sourcePath)) {
  throw new Error('gh-aw generated path changed; inspect the compiled workflow');
}
fs.writeFileSync(file, generated.replaceAll(sourcePath, '.depot/workflows/upstream-sync.lock.yml'));
JS

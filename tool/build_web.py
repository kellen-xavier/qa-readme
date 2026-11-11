#!/usr/bin/env python3
"""Build a self-contained release and generate its versioned offline cache."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
from urllib.parse import quote

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / 'build/web'
# Keep this output fixed so the generated worker always accompanies the release.
if any(arg == '-o' or arg.startswith('--output') for arg in sys.argv[1:]):
    raise SystemExit('O build PWA usa o diretório build/web.')
subprocess.run(
    ['flutter', 'build', 'web', *sys.argv[1:], '--release', '--no-web-resources-cdn'],
    cwd=ROOT, check=True,
)
files = sorted(
    p for p in OUTPUT.rglob('*')
    if p.is_file() and p.name not in {'service-worker.js', 'flutter_service_worker.js'}
    and not p.name.endswith('.map')
)
version = hashlib.sha256()
for path in files:
    version.update(path.relative_to(OUTPUT).as_posix().encode())
    version.update(path.read_bytes())
template = (ROOT / 'tool/service_worker.js').read_text()
version.update(template.encode())
worker = template.replace('__VERSION__', version.hexdigest()[:20]).replace(
    '__RESOURCES__', json.dumps([quote(p.relative_to(OUTPUT).as_posix(), safe='/') for p in files])
)
(OUTPUT / 'service-worker.js').write_text(worker)
print(f'PWA pronta: {len(files)} arquivos para uso offline em build/web.')

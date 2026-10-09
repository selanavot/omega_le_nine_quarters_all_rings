#!/usr/bin/env python3
"""Read-only verification of installed dependency sources against frozen pins.

Generated ignored .lake build artifacts are reused, not independently audited
by this script. No builds, downloads, source changes or installs are performed.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys


def git(path, *args):
    result = subprocess.run(
        ['git', '--no-pager', '-c', 'core.fsmonitor=false', '-C', str(path), *args],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        env=dict(os.environ, GIT_OPTIONAL_LOCKS='0'), check=False)
    if result.returncode:
        raise RuntimeError(f'Git failed in {path}: {result.stderr.decode(errors="replace").strip()}')
    return result.stdout


def verify(root):
    root = root.resolve()
    pins = json.loads((root / 'verification/comparator/pins.json').read_text())
    manifest_bytes = (root / 'lake-manifest.json').read_bytes()
    if hashlib.sha256(manifest_bytes).hexdigest() != pins['manifest_sha256']:
        raise RuntimeError('Manifest does not match frozen audit pins')
    if (root / 'lean-toolchain').read_text().strip() != pins['toolchain']:
        raise RuntimeError('Toolchain does not match frozen audit pins')
    manifest = json.loads(manifest_bytes)
    packages_dir = root / manifest['packagesDir']
    if packages_dir.resolve() != packages_dir:
        raise RuntimeError('Dependency directory or an ancestor is a symlink; use an independent physical cache')
    seen = set()
    for package in manifest['packages']:
        name = package['name']
        if name in seen or Path(name).name != name or package['type'] != 'git':
            raise RuntimeError(f'Invalid/duplicate/non-Git dependency: {name}')
        seen.add(name)
        revision = package['rev']
        if len(revision) != 40 or any(c not in '0123456789abcdef' for c in revision):
            raise RuntimeError(f'{name}: expected full immutable Git commit')
        path = packages_dir / name
        if path.resolve() != path:
            raise RuntimeError(f'{name}: expected physical dependency checkout, not a symlink')
        actual_root = Path(git(path, 'rev-parse', '--show-toplevel').decode().strip()).resolve()
        if actual_root != path or git(path, 'rev-parse', 'HEAD').decode().strip() != revision:
            raise RuntimeError(f'{name}: checkout does not match pinned revision/root')
        hidden = [x for x in git(path, 'ls-files', '-v', '-z').split(b'\0')
                  if x and (x[:1].islower() or x[:1] == b'S')]
        if hidden:
            raise RuntimeError(f'{name}: hidden assume-unchanged/skip-worktree entries')
        if git(path, 'diff', 'HEAD', '--name-only', '--no-ext-diff', '--no-textconv', '-z'):
            raise RuntimeError(f'{name}: modified tracked sources')
        if git(path, 'ls-files', '--others', '--exclude-standard', '-z'):
            raise RuntimeError(f'{name}: unexpected untracked files')
        for raw in git(path, 'ls-files', '--others', '--ignored', '--exclude-standard', '-z').split(b'\0'):
            if not raw:
                continue
            relative = Path(os.fsdecode(raw))
            if relative.parts[0] == '.lake':
                continue
            if relative.suffix == '.lean' or relative.name in {'lean-toolchain', 'lakefile.lean', 'lakefile.toml', 'lake-manifest.json'}:
                raise RuntimeError(f'{name}: ignored source/configuration override {relative}')
        print(f'PASS {name}: {revision} (clean)', flush=True)
    print(f'PASS: {len(seen)} dependencies match frozen pins; generated caches are outside this source audit.', flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('root', type=Path, nargs='?', default=Path(__file__).resolve().parents[1])
    try:
        verify(parser.parse_args().root)
    except (RuntimeError, OSError, KeyError, ValueError) as error:
        print(f'FAIL: {error}', file=sys.stderr)
        sys.exit(1)

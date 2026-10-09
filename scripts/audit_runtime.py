"""Shared audit serialization and source-snapshot helpers (standard library only)."""
from contextlib import contextmanager
import fcntl
import hashlib
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


@contextmanager
def exclusive_audit():
    """Use the build worker's lock, so audits cannot run beside another Lean job."""
    directory = ROOT / '.lake/ring-queue'
    directory.mkdir(parents=True, exist_ok=True)
    with (directory / 'worker.lock').open('a') as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as exc:
            raise RuntimeError('Stop the serialized build worker and let its build finish before running an audit.') from exc
        yield dict(os.environ, LEAN_NUM_THREADS='1')


def source_snapshot():
    paths = set()
    for name in ['lean', 'scripts', 'verification/comparator']:
        for path in (ROOT / name).rglob('*'):
            if path.is_file() and '__pycache__' not in path.parts and 'GeneratedControls' not in path.parts:
                paths.add(path)
    for name in ['lean-toolchain', 'lakefile.lean', 'lake-manifest.json', 'comparator.json']:
        paths.add(ROOT / name)
    return {str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in sorted(paths)}


def check_snapshot(before):
    after = source_snapshot()
    changed = sorted(path for path in before.keys() | after.keys() if before.get(path) != after.get(path))
    if changed:
        raise RuntimeError('Source changed during verification: ' + ', '.join(changed))

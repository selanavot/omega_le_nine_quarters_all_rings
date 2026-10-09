#!/usr/bin/env python3
"""Serialized local Lean builds. Root starts worker; agents only submit/status.

Logs and queue data stay under ignored .lake/ring-queue. Requests are module
names, never shell code. A filesystem lock prevents concurrent workers.
"""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]
QUEUE = ROOT / '.lake/ring-queue'


def save(path, data):
    tmp = path.with_suffix('.tmp')
    tmp.write_text(json.dumps(data, indent=2) + '\n')
    tmp.replace(path)


def source_hashes():
    return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted((ROOT / 'lean').rglob('*.lean'))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action', required=True)
    submit = sub.add_parser('submit')
    submit.add_argument('modules', nargs='+')
    submit.add_argument('--owner', default='root')
    sub.add_parser('status')
    sub.add_parser('stop')
    worker = sub.add_parser('worker')
    worker.add_argument('--idle-seconds', type=int, default=600)
    args = parser.parse_args()
    QUEUE.mkdir(parents=True, exist_ok=True)
    if args.action == 'stop':
        (QUEUE / 'stop').touch()
        print('Worker will stop after its current build.')
        return
    if args.action == 'submit':
        assert all(re.fullmatch(r'[A-Za-z][A-Za-z0-9_.]*', x) for x in args.modules)
        request_id = f'{time.time_ns()}-{uuid.uuid4().hex[:6]}'
        record = {'id': request_id, 'owner': args.owner,
                  'modules': args.modules, 'state': 'pending'}
        save(QUEUE / f'{request_id}.json', record)
        print(json.dumps(record))
        return
    if args.action == 'status':
        for path in sorted(QUEUE.glob('*.json')):
            record = json.loads(path.read_text())
            print(json.dumps({k: record[k] for k in
                  ('id', 'owner', 'modules', 'state', 'exit_code', 'log', 'changed_during_build')
                  if k in record}))
        return
    with (QUEUE / 'worker.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        (QUEUE / 'stop').unlink(missing_ok=True)
        child = None
        stopping = False

        def stop_worker(signum, frame):
            nonlocal stopping
            stopping = True
            if child is not None and child.poll() is None:
                os.killpg(child.pid, signal.SIGTERM)

        signal.signal(signal.SIGTERM, stop_worker)
        signal.signal(signal.SIGINT, stop_worker)
        lock.write(str(os.getpid()))
        lock.flush()
        idle_since = time.monotonic()
        while time.monotonic() - idle_since < args.idle_seconds:
            if stopping or (QUEUE / 'stop').exists():
                break
            pending = []
            for path in sorted(QUEUE.glob('*.json')):
                record = json.loads(path.read_text())
                if record['state'] == 'pending':
                    pending.append((path, record))
            if not pending:
                time.sleep(1)
                continue
            path, record = pending[0]
            before = source_hashes()
            log = QUEUE / (record['id'] + '.log')
            record.update(state='running', started=time.time(), log=str(log.relative_to(ROOT)))
            save(path, record)
            print('BUILD', record['owner'], *record['modules'], flush=True)
            env = dict(os.environ, LEAN_NUM_THREADS='1')
            with log.open('w') as out:
                child = subprocess.Popen(['lake', 'build', *record['modules']],
                                         cwd=ROOT, env=env, stdout=out,
                                         stderr=subprocess.STDOUT, start_new_session=True)
                returncode = child.wait()
                child = None
            after = source_hashes()
            record.update(state='interrupted' if stopping else
                          ('passed' if returncode == 0 else 'failed'),
                          exit_code=returncode, ended=time.time(),
                          changed_during_build=sorted(p for p in set(before) | set(after)
                                                      if before.get(p) != after.get(p)))
            save(path, record)
            print(record['state'].upper(), record['id'], 'log:', record['log'], flush=True)
            idle_since = time.monotonic()


if __name__ == '__main__':
    main()

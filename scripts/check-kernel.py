#!/usr/bin/env python3
"""Fresh Lean-kernel replay of the real theorem and guarded audit modules.

This is Lean's own kernel, not an independent kernel implementation. The build
worker must be stopped. The same exclusive lock prevents concurrent Lean jobs.
"""
import subprocess
import sys
from audit_runtime import ROOT, exclusive_audit, source_snapshot, check_snapshot


def main():
    with exclusive_audit() as env:
        before = source_snapshot()
        commands = [
            [sys.executable, 'scripts/check-specification.py'],
            [sys.executable, 'scripts/verify-dependencies.py'],
            ['lake', 'build', 'ComparatorAudit.KernelAudit'],
            ['lake', 'env', 'leanchecker', '--fresh', '--verbose', 'ComparatorAudit.KernelAudit'],
        ]
        for command in commands:
            subprocess.run(command, cwd=ROOT, env=env, check=True)
        check_snapshot(before)
        print('PASS: fresh replay in Lean kernel with unchanged source snapshot.', flush=True)


if __name__ == '__main__':
    try:
        main()
    except (RuntimeError, OSError, subprocess.CalledProcessError) as error:
        print(f'Kernel verification failed: {error}', file=sys.stderr)
        sys.exit(1)

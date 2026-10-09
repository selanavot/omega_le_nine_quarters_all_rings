#!/usr/bin/env python3
"""Fresh Lean-kernel replay of the complete six-claim dependency closure.

This is Lean's own kernel, not an independent kernel implementation. The build
worker must be stopped. The same exclusive lock prevents concurrent Lean jobs.
"""
import subprocess
import sys
import json
from audit_runtime import ROOT, exclusive_audit, source_snapshot, check_snapshot


def main():
    with exclusive_audit() as env:
        before = source_snapshot()
        commands = [
            [sys.executable, 'scripts/check-specification.py'],
            [sys.executable, 'scripts/verify-dependencies.py'],
            ['lake', 'build', 'ComparatorAudit.KernelAudit'],
        ]
        for command in commands:
            subprocess.run(command, cwd=ROOT, env=env, check=True)
        config = json.loads((ROOT / 'verification/comparator/config.json').read_text())
        export_path = ROOT / '.lake/kernel-claims.ndjson'
        targets = config['theorem_names'] + config['permitted_axioms'] + [
            'Quot', 'Quot.mk', 'Quot.lift', 'Quot.ind']
        # leanexport recursively includes every dependency of these declarations.
        # --from-export replays that closure into an empty kernel environment;
        # unlike --fresh MODULE, it does not replay unrelated Mathlib imports.
        with export_path.open('wb') as output:
            subprocess.run(['lake', 'env', 'leanexport', config['solution_module'],
                            '--', *targets], cwd=ROOT, env=env, stdout=output, check=True)
        subprocess.run(['lake', 'env', 'leanchecker', '--from-export', str(export_path)],
                       cwd=ROOT, env=env, check=True)
        check_snapshot(before)
        print('PASS: complete six-claim dependency closure replayed in a fresh Lean kernel; unchanged source snapshot.', flush=True)


if __name__ == '__main__':
    try:
        main()
    except (RuntimeError, OSError, subprocess.CalledProcessError) as error:
        print(f'Kernel verification failed: {error}', file=sys.stderr)
        sys.exit(1)

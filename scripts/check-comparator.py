#!/usr/bin/env python3
"""Compare the frozen ring model and six statements with the actual Lean proof.

Run only after stopping the serialized build worker. --trusted-local explicitly
disables the native Comparator sandbox. This is not a sandbox/provenance audit.
"""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import sys
from audit_runtime import ROOT, exclusive_audit, source_snapshot, check_snapshot

SPEC = ROOT / 'verification/comparator'
SOURCES = ROOT / 'lean'


def run(args, env):
    subprocess.run(list(map(str, args)), cwd=ROOT, env=env, check=True)


def verify_spec(env):
    run([sys.executable, ROOT / 'scripts/check-specification.py'], env)


def negative_controls(command, env):
    generated = SOURCES / 'ComparatorAudit/GeneratedControls'
    if generated.exists():
        raise RuntimeError(f'Refusing to overwrite existing control directory {generated}')
    config = json.loads((SPEC / 'config.json').read_text())
    challenge = (SOURCES / 'ComparatorAudit/Challenge.lean').read_text()
    solution = (SOURCES / 'ComparatorAudit/Solution.lean').read_text()
    cost = '  | .mul _ _ => 1'
    proof = 'matrix_multiplication_cost_le_nine_quarters_all_rings R ε hε'
    if challenge.count(cost) != 1 or solution.count(proof) != 1:
        raise RuntimeError('Negative-control source anchors changed')
    cases = [
        ('ChangedCost', 'challenge_module', challenge.replace(cost, '  | .mul _ _ => 0'),
         'Const does not match between challenge and target'),
        ('SorryProof', 'solution_module', solution.replace(proof, 'by sorry'),
         "Illegal axiom detected: 'sorryAx'"),
    ]
    generated.mkdir()
    try:
        for name, side, source, expected in cases:
            module = f'ComparatorAudit.GeneratedControls.{name}'
            (generated / f'{name}.lean').write_text(source)
            altered = dict(config)
            altered[side] = module
            cfg = generated / f'{name}.json'
            cfg.write_text(json.dumps(altered, indent=2) + '\n')
            run(['lake', 'build', module], env)
            result = subprocess.run(list(map(str, command + ['--config', cfg])), cwd=ROOT,
                                    env=env, text=True, capture_output=True)
            output = result.stdout + result.stderr
            log = ROOT / '.lake' / f'comparator-{name}.log'
            log.write_text(output)
            if result.returncode == 0 or expected not in output:
                print(output, file=sys.stderr)
                raise RuntimeError(f'{name} did not fail for the expected reason; see {log}')
            if name == 'ChangedCost' and 'OAI.MatrixMultiplication.Arithmetic.Gate.cost' not in output:
                raise RuntimeError('Changed-cost control failed on an unexpected declaration')
            print(f'PASS negative control {name}: exit {result.returncode}; {expected}', flush=True)
    finally:
        shutil.rmtree(generated)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--trusted-local', action='store_true',
                        help='Explicitly disable native build sandbox for trusted source')
    parser.add_argument('--negative-controls', action='store_true',
                        help='Require rejection of changed multiplication cost and sorry proof')
    args = parser.parse_args()
    if not args.trusted_local:
        raise RuntimeError('This local harness requires --trusted-local; no sandbox verification is claimed')
    with exclusive_audit() as env:
        before = source_snapshot()
        verify_spec(env)
        run([sys.executable, ROOT / 'scripts/verify-dependencies.py'], env)
        print('MODE: trusted local source, sandbox disabled; bundled independent kernels requested.', flush=True)
        run(['lake', 'build', 'ComparatorAudit.Challenge', 'ComparatorAudit.KernelAudit'], env)
        command = ['lake', 'comparator', '--inadvisably-no-sandbox', '--paranoid']
        run(command + ['--config', SPEC / 'config.json'], env)
        verify_spec(env)
        check_snapshot(before)
        print('PASS: six theorems, frozen definitions, standard axioms, bundled kernel checks.', flush=True)
        if args.negative_controls:
            negative_controls(command, env)
        verify_spec(env)
        check_snapshot(before)


if __name__ == '__main__':
    try:
        main()
    except (RuntimeError, OSError, subprocess.CalledProcessError) as error:
        print(f'Comparator verification failed: {error}', file=sys.stderr)
        sys.exit(1)

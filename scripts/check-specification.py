#!/usr/bin/env python3
"""Check the arithmetic model against the exact seven-substitution baseline."""
import hashlib
import json
from pathlib import Path
import subprocess
from specification import ring_port

ROOT = Path(__file__).resolve().parents[1]
PINS = json.loads((ROOT / 'verification/comparator/pins.json').read_text())
MARKER = b'\n-- COMPARATOR FROZEN MODEL ENDS HERE\n'


def verify():
    original = subprocess.check_output(
        ['git', 'show', f"{PINS['model_baseline']}:{PINS['model_path']}"], cwd=ROOT)
    expected = ring_port(original)
    if hashlib.sha256(original).hexdigest() != PINS['baseline_model_sha256']:
        raise RuntimeError('Immutable baseline model hash differs from audit pins')
    if hashlib.sha256(expected).hexdigest() != PINS['ring_model_sha256']:
        raise RuntimeError('Seven-substitution model hash differs from audit pins')
    if (ROOT / PINS['model_path']).read_bytes() != expected:
        raise RuntimeError('Model changed beyond exactly seven Field -> Ring substitutions')
    challenge = (ROOT / 'lean/ComparatorAudit/Challenge.lean').read_bytes()
    if challenge.count(MARKER) != 1 or challenge.split(MARKER)[0] != expected:
        raise RuntimeError('Challenge model differs from the frozen ring specification')
    if hashlib.sha256(challenge).hexdigest() != PINS['challenge_sha256']:
        raise RuntimeError('Frozen Challenge theorem statements changed')
    config = json.loads((ROOT / 'verification/comparator/config.json').read_text())
    names = ['omega_bound', 'admissible_bddBelow', 'admissible_nonempty',
             'omega_lower', 'epsilon_cost', 'exact_coefficients']
    required = {
        'challenge_module': 'ComparatorAudit.Challenge',
        'solution_module': 'ComparatorAudit.Solution',
        'theorem_names': ['ComparatorChecks.' + name for name in names],
        'permitted_axioms': ['propext', 'Classical.choice', 'Quot.sound'],
    }
    if config != required or json.loads((ROOT / 'comparator.json').read_text()) != required:
        raise RuntimeError('Comparator configuration changed (definition holes are forbidden)')
    if (ROOT / 'lean-toolchain').read_text().strip() != PINS['toolchain']:
        raise RuntimeError('Lean toolchain differs from frozen audit pins')
    if hashlib.sha256((ROOT / 'lake-manifest.json').read_bytes()).hexdigest() != PINS['manifest_sha256']:
        raise RuntimeError('Dependency manifest differs from frozen audit pins')
    print('PASS: Model and Challenge preserve every byte except seven Field -> Ring substitutions.', flush=True)
    print('PASS: Six frozen theorem statements, standard axioms only, no definition holes.', flush=True)
    return hashlib.sha256(challenge).hexdigest()


if __name__ == '__main__':
    verify()

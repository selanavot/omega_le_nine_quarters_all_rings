"""The complete allowed change to the frozen arithmetic model."""

def ring_port(source: bytes) -> bytes:
    if source.count(b"[Field F]") != 7:
        raise ValueError("Expected exactly seven Field assumptions in the immutable baseline")
    return source.replace(b"[Field F]", b"[Ring F]")

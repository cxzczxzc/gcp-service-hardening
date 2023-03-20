# Hello Pytest world

# --------   Code to be tested ------------

def add(this, that):
    result = this + that
    return result

# -------- tests -------------------


def test_add():
    assert add(10, 15) == 25

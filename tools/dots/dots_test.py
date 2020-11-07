import pytest
import os
from tree import Tree
from dots import _resolve_relative

def test_tree_creation():
    t = Tree(['home/user/.bashrc',
              'home/user/files/file.txt',
              'home/user/files/file2.txt',
              'config/file',
              'home/user/music',
              'groceries.txt'])
    assert 'root' in t.dirs
    assert 'groceries.txt' in t.dirs['root']
    assert 'config' in t.dirs
    assert 'home' in t.dirs
    assert 'user' in t.dirs['home']
    assert 'files' in t.dirs['home']['user']
    assert 'file' in t.dirs['config']['root']


def test_resolve_relative_paths():
    p = _resolve_relative('./some/path/to/file.txt', os.getcwd())
    assert p == '/some/path/to/file.txt'
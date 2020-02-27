import pytest
from tree import Tree

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


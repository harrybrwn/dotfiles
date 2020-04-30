#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import sys

BLUE = '\033[01;34m'
NOCOL = '\033[0m'

class Tree:
    '''build a tree from a list of directories and files'''
    def __init__(self, files, name=None):
        self.name = name or 'root'
        self.all = files
        self.dirs = {'root': []}
        self.split = [f.split(os.path.sep) for f in files]
        for p in self.split:
            self.expand(p, self.dirs)

    def expand(self, parts, dir=None):
        if len(parts) == 1:
            dir['root'].append(parts[0])
            return dir

        if parts[0] not in dir:
            dir[parts[0]] = {'root': []}

        return self.expand(parts[1:], dir[parts[0]])

    def walk(self, dir=None, prefix=''):
        if dir is None:
            dir = self.dirs
            name = self.name
        elif isinstance(dir, str):
            if dir == '.':
                path = os.getcwd()
                dir = os.listdir(os.getcwd())
            else:
                path = dir
                dir = self.dirs
            parts = path.split(os.path.sep)
            for p in parts:
                dir = dir[p]
            name = parts[-1]
            print(dir, path)
        else:
            name = None

        files = dir.pop('root', [])
        full_len = len(dir) + len(files)

        if name and not prefix:
            print(BLUE, name, NOCOL, sep='')

        for i, (name, d) in enumerate(dir.items()):
            if i == full_len - 1:
                print(prefix, '└── ', BLUE, name, sep='', end=f'{NOCOL}\n')
                self.walk(d, prefix + '   ')
            else:
                print(prefix, '├── ', BLUE, name, sep='', end=f'{NOCOL}\n')
                self.walk(d, prefix + '│  ')

        for i, f in enumerate(files):
            if i == len(files) - 1:
                print(prefix, '└── ', f, sep='')
            else:
                print(prefix, '├── ', f, sep='')

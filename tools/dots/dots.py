import sys
import os

from pathlib import Path
import shutil
import shlex
import subprocess as sp

from datetime import datetime
from contextlib import contextmanager

from dispatch import command, subcommand
from dispatch.types import Env


REPO_NAME = 'repo'
CONFIG_DIR = 'dots'
REMOTE = os.path.expandvars(f"$XDG_CONFIG_HOME/{CONFIG_DIR}/{REPO_NAME}")


def get_default_repo() -> str:
    if os.getenv('XDG_CONFIG_HOME'):
        return os.path.expandvars(f'$XDG_CONFIG_HOME/{CONFIG_DIR}/{REPO_NAME}')
    else:
        return os.path.join(Path.home(), f'.config/{CONFIG_DIR}/{REPO_NAME}')


def ask(q) -> bool:
    res = input(f'{q} (y/n): ').lower()
    return res == 'y' or res == 'yes'


def datenow() -> str:
    return str(datetime.now())


def err(msg) -> int:
    print('Error:', msg, file=sys.stderr)
    return 1


def is_git_folder(path) -> bool:
    if not os.path.isdir(path):
        return False
    objs = {'branches', 'hooks', 'info', 'objects',
            'refs', 'config', 'description', 'HEAD'}
    dir_list = set(os.listdir(path))
    return objs.issuperset(dir_list) or objs.issubset(dir_list)


LONG_COMMIT_MSG = False

def make_commit_msg(files, op):
    if LONG_COMMIT_MSG:
        files_list = ', '.join(os.path.join(*f.split(os.path.sep)[-2:]) for f in files)
    else:
        files_list = ', '.join(f.split(os.path.sep)[-1] for f in files)
    return f'{datetime.now():%F %X}: {op} {files_list}'


class Git:
    def __init__(self, remote=None, work_tree=None):
        self.remote_dir = remote
        self.work_tree = work_tree

    def add(self, *files) -> int:
        if not files:
            raise ValueError(f'no file given: {files}')
        return self._exec('add', *files)

    def commit(self, msg) -> int:
        return self._exec('-c', 'color.status=always', 'commit', '-m', f'{msg}')

    def delete(self):
        shutil.rmtree(self.remote_dir)

    def has_changed(self) -> bool:
        index = self._exec('diff-index', '--quiet', '--ignore-submodules', '--cached', 'HEAD', '--')
        files = self._exec('diff-files', '--quiet', '--ignore-submodules')
        return index == 0 and files == 0

    def has_remote(self) -> bool:
        out = self._capture_exec('remote')
        return bool(out)

    def tracked_files(self) -> list:
        raw = self._capture_exec('ls-tree', 'HEAD', '-r', '--full-tree', '--name-only')
        return [f for f in raw.split('\n') if f]

    def changed_files(self) -> list:
        raw = self._capture_exec('ls-files-root', '-m')
        return [f for f in raw.split('\n') if f]

    def ls_files(self) -> int:
        '''
        Lists all files from the root of the repo no matter
        where the current directory is.
        '''
        return self._exec('ls-tree', 'HEAD', '-r', '--full-tree', '--name-only')

    def all_files(self):
        res = self._capture_exec('ls-files-root')
        return res.split('\n')[:-1]

    def config_get(self, name) -> str:
        return self._capture_exec('config', '--local', '--get', name)

    def config_set(self, name, val) -> int:
        return self._exec('config', '--local', name, val)

    def _command_args(self, *others):
        return [
            'git',
            '--git-dir', self.remote_dir,
            '--work-tree', self.work_tree,
            *others,
        ]

    def _exec(self, *command, verbose=False) -> int:
        args = self._command_args(*command)
        return sp.run(args).returncode

    def _capture_exec(self, *commands) -> str:
        args = self._command_args(*commands)
        with sp.Popen(args,  stdout=sp.PIPE, stderr=sp.PIPE) as proc:
            out, err = proc.communicate()
        return out.decode('utf8')

    def _proc(self, *commands):
        args = self._command_args(*commands)
        return sp.Popen(args, stdout=sp.PIPE, stderr=sp.PIPE)

CONFIG_LS_ROOT_ALIAS = '!git ls-files'
LS_ROOT = 'ls-files-root'


@command
class dots:
    '''Manage your dot files in peace.
    '''
    repo_path: str = get_default_repo()
    root_path: Env = Env('HOME')

    def __init__(self):
        self._g = Git(self.repo_path, self.root_path)
        if not os.path.exists(self.repo_path):
            os.makedirs(self.repo_path)
            os.system(f'git init --bare {self.repo_path}')

        untracked = self._g.config_get('status.showUntrackedFiles')
        if not untracked or untracked != 'no':
            self._g.config_set('status.showUntrackedFiles', 'no')

        alias = self._g.config_get(f'alias.{LS_ROOT}')
        if not alias or alias != CONFIG_LS_ROOT_ALIAS:
            self._g.config_set(f'alias.{LS_ROOT}', CONFIG_LS_ROOT_ALIAS)

    def exec(self, *args):
        '''Execute a git command for the dots repo'''
        g = self._git()
        if len(args) == 1:
            g._exec(*shlex.split(args[0]))
        else:
            g._exec(*args)
    git = exec

    @subcommand(usage='dots ls [path] [flags]')
    def ls(self, *args, verbose: bool):
        '''list the files in the repo

        :v verbose:'''
        from tree import Tree, BLUE, NOCOL
        fs = self._git().all_files()
        t = Tree(fs, 'dots')
        if args:
            try:
                t.walk(args[0])
            except KeyError:
                return err(f'could not find {args[0]!r}')
        else:
            t.walk()
    list = ls

    def add(self, *args):
        '''add a file'''
        if not args:
            print('no files given', file=sys.stderr)
            sys.exit(1)
        g = self._git()
        g.add(*args)
        return g.commit(msg=make_commit_msg(args, 'added'))

    def update(self, *args, silent: bool, check: bool):
        '''update any changed made to tracked files'''
        g = self._git()
        files = [os.path.join(self.root_path, f) for f in g.changed_files()]
        if not files and not args:
            return err('no changes found')

        if args:
            fset = set(files)
            files = []
            for f in args:
                f = os.path.expanduser(f)
                if not os.path.isabs(f):
                    f = os.path.realpath(f)
                if f in fset:
                    files.append(f)

        if not files:
            return err('file(s) not tracked')

        if not silent:
            for f in files:
                print('updating', f)
        if check:
            return
        print()
        g.add(*files)
        return g.commit(msg=make_commit_msg(files, 'updated'))

    def status(self, stat: bool):
        '''check if your files are up to date or not
        :s stat: show diff stats
        '''
        g = self._git()

        if stat:
            res = g._exec('--no-pager', '-c', 'color.status=always', 'diff', '--stat')
            if res != 0:
                return res
            print()  # for the \n

        out = g._capture_exec('-c', 'color.status=always', 'status').split('\n')
        for ln in out[1:-2]:
            if '(use' in ln:
                continue
            print(ln)

    @subcommand(usage='rm [files...] [flags]')
    def rm(self, *args, recursive: bool = False):
        '''Remove a file or directory from the tracking list (will not delete from disk)

        :r recursive: remove a directory'''
        if not args:
            return err(self.delete.helptext())

        g = self._git()
        files = [os.path.expanduser(f) for f in args]

        if recursive:
            g._exec('rm', '--cached', '-r', *files)
        else:
            g._exec('rm', '--cached', *files)
        g.commit(msg=make_commit_msg(files, 'removed'))
    delete = rm

    def sync(self, *args, path: bool):
        '''
        Sync with the remote repository

        :p path: Get the remote path or url'''
        g = self._git()

        if path:
            return g._exec('remote', '-v')

        if args:
            # TODO: if args: add args[0] as a remote repo
            path = os.path.abspath(args[0])
            if not os.path.exists(path):
                return err('that folder does not exist')
            if is_git_folder(path):
                print('we all good:', path)
            else:
                return err("this is not a valid git folder")
            return

        if g.has_remote():
            pull = g._exec('pull', 'origin', 'master')
            print()
            push = g._exec('push', 'origin', 'master')
            return int(pull != 0 or push != 0)
        else:
            return err('no remote repo to sync')

    @subcommand(hidden=True)
    def test(self, *args):
        err('no testing being done')

    def _git(self):
        return self._g


if __name__ == "__main__":
    dots()

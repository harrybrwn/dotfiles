config: ...  # type: ignore

from canvas import NamingScheme
import re, os


class SimpleNamingScheme(NamingScheme):
    def rename_dir(self, dirname: str, **kwrgs) -> str:
        return dirname.replace(' ', '').lower()
    def rename_file(self, filename: str, **kwrgs) -> str:
        return filename.replace(' ', '').lower()


class BasicNamingScheme(NamingScheme):
    lecture_re = re.compile('.*?/(Lecture [A-Za-z]*?)/.*')
    date_re = re.compile('([0-9]{2,4})-([0-9]{1,2})-([0-9]{1,2})')

    def rename_dir(self, dirname: str, **kwrgs) -> str:
        lect_res = self.lecture_re.search(dirname)
        if lect_res:
            print(lect_res.groups())
            return dirname.replace(lect_res.group(1), 'lectures')
        if 'Lecture Materials' in dirname:
            return dirname.replace('Lecture Materials', 'lectures')

        if 'Lecture' in dirname or 'Lab' in dirname:
            dirname = dirname.lower()

        parts = dirname.split('/')
        if len(parts) > 1 and ' ' not in parts[-2]:
            dirname = dirname.replace(parts[-2], parts[-2].lower())

        return dirname.replace(' ', '').replace("'", '')

    def rename_file(self, file): return file


class PoliNamingScheme(NamingScheme):
    def __init__(self, base_dir='poli3'):
        self.base_dir = base_dir

    def rename_file(self, file, **kwrgs):
        newdir = 'readings'
        if 'Week' in file:
            newdir = 'lectures'
        elif 'Syllabus' in file:
            newdir = 'syllabus'
        # dr = os.path.join(self.base_dir, newdir)
        return f'{newdir}/{file}'

    def rename_dir(self, dirname, **kwrgs): return dirname


class AINamingScheme(BasicNamingScheme):
    def rename_dir(self, dirname, **kwrgs):
        if 'Programming Assignment #' in dirname:
            return dirname.replace('Programming Assignment #', 'assignment')
        if 'Programs' in dirname:
            return dirname.replace('Programs', 'assignments')
        return super().rename_dir(dirname, **kwrgs).lower()


class BioNamingScheme(BasicNamingScheme):
    disc_re = re.compile('.*([dD]iscussion).*')

    def rename_file(self, filename, **kwrgs):
        if filename.endswith('.pptx'):
            return filename.replace(' ', '_')
        return super().rename_file(filename, **kwrgs)

    def rename_dir(self, dirname, **kwrgs):
        dirname = super().rename_dir(dirname)
        res = self.disc_re.search(dirname)
        if res is not None:
            dirname = dirname.replace(res.group(1), '')
        return dirname


class Scheme(NamingScheme):
    def rename_file(self, filename, **kwrgs):
        return filename

    def rename_dir(self, dirname, **kwrgs):
        return dirname


class WriNamingScheme(SimpleNamingScheme):
    def rename_file(self, filename, **kwrgs):
        if filename.startswith('Assignment - '):
            filename = filename.replace('Assignment - ', 'assignments/')
        elif filename.startswith('Reading - '):
            filename = filename.replace('Reading - ', 'readings/')

        filename = filename.replace('+-+', '-')
        return filename.replace(' ', '').replace('+', '-')


class Engr45NamingScheme(NamingScheme):
    def rename_file(self, filename, **kwrgs):
        return filename.replace(' ', '').lower()

    def rename_dir(self, dirname, **kwrgs):
        return dirname.replace(' ', '')


class CSE31NamingScheme(SimpleNamingScheme):
    def rename_dir(self, dirname, **kwrgs):
        dirname = super().rename_dir(dirname, **kwrgs)
        if 'lab#' in dirname:
            dirname = dirname.replace('lab#', 'lab')
        return dirname

    def rename_file(self, filename, **kwrgs):
        if os.path.splitext(filename)[1] == '.pdf':
            return super().rename_file(filename)
        return filename


schemes = {
    config['classids']['yr3/ai']: AINamingScheme(),
    config['classids']['yr3/bio3']: BioNamingScheme(),
    config['classids']['yr3/cse30']: BasicNamingScheme(),
    config['classids']['yr3/poli3']: PoliNamingScheme('poli3'),

    config['classids']['cse31']: CSE31NamingScheme(),
    config['classids']['math24']: SimpleNamingScheme(),
    config['classids']['wri119']: WriNamingScheme(),
    config['classids']['engr45']: Engr45NamingScheme(),
}

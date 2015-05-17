import emigrate
import sys


class FileViewer(object):

    electromigration = None

    def __init__(self, file):
        self.electromigration = emigrate.Electromigration('', file, True)
        self.viewer()

    def viewer(self):
        for line in iter(sys.stdin.readline, ''):
            frame = int(line)
            print self.electromigration[frame].serialize(True)
            sys.stdout.flush()

if __name__ == '__main__':
    file = '/Users/lewis/Documents/github/emigrate/test.hdf5'
    FileViewer(file)

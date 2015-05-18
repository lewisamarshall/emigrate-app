import emigrate
import sys
import json


class FileViewer(object):

    electromigration = None

    def __init__(self, file):
        self.electromigration = emigrate.Electromigration(filename=file,
                                                          mode='r')
        self.viewer()

    def viewer(self):
        for line in iter(sys.stdin.readline, ''):
            frame = int(line)
            serial = self.electromigration[frame].serialize()
            serial['n_electrolytes'] = \
                len(self.electromigration.electrolytes.keys())
            print json.dumps(serial)
            sys.stdout.flush()

if __name__ == '__main__':
    file = '/Users/lewis/Documents/github/emigrate/test.hdf5'
    FileViewer(file)

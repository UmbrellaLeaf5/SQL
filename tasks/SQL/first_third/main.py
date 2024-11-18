#!/usr/bin/python3

import csv
import sqlite3
import sys


def main(fname):
    data = []

    with open(fname) as fin:
        for ts, sn, result in csv.reader(fin):
            ts = int(ts)
            result = int(result)
            assert result in (0, 1), f'Unexpected result code: {result}'
            data.append((ts, sn, result))

        data.sort()

    with sqlite3.connect('dev-tests.s3db') as conn:
        cur = conn.cursor()
        for ts, sn, result in data:
            cur.execute('INSERT OR IGNORE INTO devices (sn) VALUES (?)', [sn])
            cur.execute(
                'INSERT INTO tests (device_id, ts, result)'
                ' VALUES ((SELECT id FROM devices WHERE sn = ?), ?, ?)',
                (sn, ts, result)
            )
        conn.commit()


if __name__ == '__main__':
    main(sys.argv[1])


# python3 main.py dev-tests-large.csv
# сделать свой SELECT

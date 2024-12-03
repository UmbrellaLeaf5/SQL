#!/usr/bin/python3

import pandas as pd
import sqlite3


def main():
    log_file = 'log1.csv'
    users_file = 'users1.csv'

    log_df = pd.read_csv(
        log_file, names=['user_id', 'time', 'bet', 'win'], encoding='utf-8', sep=',')

    users_df = pd.read_csv(
        users_file, names=['user_id', 'mail', 'geo'], encoding='koi8-r', sep='\t')

    conn = sqlite3.connect('log_users.s3db')

    log_df.to_sql('LOG', conn, if_exists='replace', index=False)
    users_df.to_sql('USERS', conn, if_exists='replace', index=False)

    conn.close()


if __name__ == '__main__':
    main()

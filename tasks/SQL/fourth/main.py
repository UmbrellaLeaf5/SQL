#!/usr/bin/python3

import pandas as pd
import sqlite3
import os


def IsFileInFolder(file_name: str, folder_name: str = os.getcwd()) -> bool:
    """
    Проверяет, существует ли файл в указанной папке.

    Args:
      folder_name: путь к папке, в которой нужно проверить наличие файла.
      file_name: путь к файлу, который нужно проверить.

    Returns:
      True, если файл существует в папке, в противном случае False.
    """

    full_file_name = os.path.join(folder_name, file_name)
    return os.path.exists(full_file_name)


def main():
    log_file: str
    users_file: str

    if IsFileInFolder('log1.csv'):
        log_file = 'log1.csv'
    else:
        log_file = 'log(1).csv'

    if IsFileInFolder('users1.csv'):
        users_file = 'users1.csv'
    else:
        users_file = 'users(1).csv'

    log_df = pd.read_csv(
        log_file, names=['user_id', 'time', 'bet', 'win'], encoding='utf-8', sep=',')

    users_df = pd.read_csv(
        users_file, names=['user_id', 'mail', 'geo'], encoding='koi8-r', sep='\t')

    conn = sqlite3.connect('log_users.s3db')

    log_df.to_sql('LOG', conn, if_exists='append', index=False)
    users_df.to_sql('USERS', conn, if_exists='append', index=False)

    conn.close()


if __name__ == '__main__':
    main()

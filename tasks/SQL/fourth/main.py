#!/usr/bin/python3

import pandas as pd
import sqlite3
import os

# 1. В группе лежит два файла .csv: users(1) и log(1). Надо скачать.
# 2. В этих файлах лежит информация о пользователях, делавших ставки, времени захода на платформу и выигрышах/проигрышах.


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

    # В инструкции написаны файлы со скобками,
    # а в группе даны без, так что нахожу, какие есть

    if IsFileInFolder('log1.csv'):
        log_file = 'log1.csv'
    else:
        log_file = 'log(1).csv'

    if IsFileInFolder('users1.csv'):
        users_file = 'users1.csv'
    else:
        users_file = 'users(1).csv'

    #! Чтение .csv файлов в pd.DataFrame

    # 3. B log(1).csv есть данные идентификатора пользователя, времени посещения, дате посещения, размере ставки и размере выигрыша.
    # 4. Данные из файла log(1).csv надо будет закачать в таблицу с колонками user_id, time, bet, win.
    log_df = pd.read_csv(
        log_file, names=['user_id', 'time', 'bet', 'win'], encoding='utf-8', sep=',')

    # 5. Файл users(1).csv в кодировке koi8_r. Перед обработкой надо перекодировать, либо научиться закачивать данные из этой кодировки.
    # 6. Данные из файла users(1).csv надо загрузить в таблицу со столбцами user_id, email, geo.
    users_df = pd.read_csv(
        users_file, names=['user_id', 'mail', 'geo'], encoding='koi8-r', sep='\t')

    #! Сохранение pd.DataFrame в базу данных SQL

    conn = sqlite3.connect('log_users.s3db')

    # 4. Данные из файла log(1).csv надо будет закачать в таблицу LOG...
    log_df.to_sql('LOG', conn, if_exists='append', index=False)

    # 6. Данные из файла users(1).csv надо загрузить в таблицу USERS...
    users_df.to_sql('USERS', conn, if_exists='append', index=False)

    conn.close()


if __name__ == '__main__':
    main()

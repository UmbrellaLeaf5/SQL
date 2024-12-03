#!/usr/bin/bash

# Удаление предыдущей генерации (необязательно)
touch log_users.s3db
rm log_users.s3db

# Загрузка scheme.sql в базу данных
sqlite3 log_users.s3db < scheme.sql

# Загрузка сырых .csv в базу данных с помощью Python
.venv/Scripts/python main.py || .venv/Scripts/python3 main.py || python main.py || python3 main.py

# Чистка данных в базе данных
sqlite3 log_users.s3db < update.sql
#!/usr/bin/bash

touch log_users.s3db
rm log_users.s3db
sqlite3 log_users.s3db < scheme.sql
.venv/Scripts/python main.py || .venv/Scripts/python3 main.py || python main.py || python3 main.py
sqlite3 log_users.s3db < update.sql
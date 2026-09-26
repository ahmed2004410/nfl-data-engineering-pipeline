# NFL Data Engineering Pipeline

End-to-end data engineering project on NFL 2018 Play-by-Play data.

## Stack
PostgreSQL, Python, SQL, Apache Airflow (Docker), Power BI

## Architecture
CSV → staging → dwh (dimensions + facts) → marts → Power BI
Orchestrated with Airflow.

## Data Source
Kagle

## Setup
1. `python -m venv venv` + `pip install -r requirements.txt`
2. اعمل `.env` من `.env.example`
3. `docker compose up -d`
4. افتح Airflow على localhost:8081 وشغّل الـ DAG

## Dashboard
<img width="1235" height="692" alt="Screenshot 2026-09-26 153551" src="https://github.com/user-attachments/assets/1fffeba0-ef76-451f-82f4-0c4bdb787ea8" />

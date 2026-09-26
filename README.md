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
### First Page
<img width="1235" height="692" alt="Screenshot 2026-09-26 153551" src="https://github.com/user-attachments/assets/1fffeba0-ef76-451f-82f4-0c4bdb787ea8" />

### Season Overview
<img width="1237" height="690" alt="Screenshot 2026-09-26 153539" src="https://github.com/user-attachments/assets/83b0cc52-0397-4f47-bde6-49b53bd522b1" />

### Team & Formation Analysis
<img width="1232" height="693" alt="Screenshot 2026-09-26 153528" src="https://github.com/user-attachments/assets/08bc41d9-fc99-4c46-9d09-7b54f01d53c3" />

###  Situational Analysis
<img width="1237" height="693" alt="Screenshot 2026-09-26 153512" src="https://github.com/user-attachments/assets/d467fbe6-ef9e-48a3-8bd0-d9c26229d63f" />

###  Receiver Speed & Routes
<img width="1236" height="690" alt="Screenshot 2026-09-26 153450" src="https://github.com/user-attachments/assets/5f8521eb-969c-41c2-9b2c-189d41558bb2" />

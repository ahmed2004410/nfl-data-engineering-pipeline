from pathlib import Path

from db import get_engine

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
DDL_FILE = ROOT / "sql" / "staging" / "01_create_staging_tables.sql"

# اسم الجدول في الـ database : اسم ملف الـ CSV
TABLES = {
    "staging.games": "games.csv",
    "staging.players": "players.csv",
    "staging.plays": "plays.csv",
    "staging.week_data": "week_data.csv",

}


def create_tables(engine):
    sql = DDL_FILE.read_text(encoding="utf-8")
    with engine.begin() as conn:
        conn.exec_driver_sql(sql)
    print("Staging tables created.")


def load_csv(engine, table, csv_path):
    raw = engine.raw_connection()
    try:
        with raw.cursor() as cur:
            cur.execute(f"TRUNCATE TABLE {table}")
            with open(csv_path, "r", encoding="utf-8") as f:
                cur.copy_expert(
                    f"COPY {table} FROM STDIN WITH (FORMAT csv, HEADER true)", f
                )
            cur.execute(f"SELECT COUNT(*) FROM {table}")
            print(f"{table}: {cur.fetchone()[0]} rows loaded")
        raw.commit()
    except Exception:
        raw.rollback()
        raise
    finally:
        raw.close()


if __name__ == "__main__":
    engine = get_engine()
    create_tables(engine)
    for table, filename in TABLES.items():
        load_csv(engine, table, RAW / filename)
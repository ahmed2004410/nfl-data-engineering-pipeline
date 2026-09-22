import sys
from pathlib import Path

from db import get_engine

ROOT = Path(__file__).resolve().parent.parent


def run_sql_file(relative_path):
    path = ROOT / relative_path
    sql = path.read_text(encoding="utf-8")

    raw = get_engine().raw_connection()
    try:
        with raw.cursor() as cur:
            cur.execute(sql)
        raw.commit()
        print(f"Executed: {relative_path}")
    except Exception:
        raw.rollback()
        raise
    finally:
        raw.close()


if __name__ == "__main__":
    for p in sys.argv[1:]:
        run_sql_file(p)
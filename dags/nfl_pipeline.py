import sys
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import (
    SQLExecuteQueryOperator,
    SQLValueCheckOperator,
)

sys.path.append("/opt/airflow/src")

from load_staging import create_tables, load_csv, TABLES, RAW  # noqa: E402
from db import get_engine  # noqa: E402


def run_load_staging():
    engine = get_engine()
    create_tables(engine)
    for table, filename in TABLES.items():
        load_csv(engine, table, RAW / filename)


default_args = {
    "owner": "ahmed",
    "retries": 2,
    "retry_delay": timedelta(minutes=2),
}

with DAG(
    dag_id="nfl_pipeline",
    description="NFL data engineering pipeline: staging -> dwh -> marts",
    default_args=default_args,
    schedule=None,
    start_date=datetime(2026, 1, 1),
    catchup=False,
    template_searchpath=["/opt/airflow/sql"],
    tags=["nfl"],
) as dag:

    load_staging = PythonOperator(
        task_id="load_staging",
        python_callable=run_load_staging,
    )

    dim_team = SQLExecuteQueryOperator(
        task_id="dim_team", conn_id="nfl_postgres", sql="dwh/01_dim_team.sql",
    )
    dim_date = SQLExecuteQueryOperator(
        task_id="dim_date", conn_id="nfl_postgres", sql="dwh/02_dim_date.sql",
    )
    dim_formation = SQLExecuteQueryOperator(
        task_id="dim_formation", conn_id="nfl_postgres", sql="dwh/03_dim_formation.sql",
    )
    dim_game = SQLExecuteQueryOperator(
        task_id="dim_game", conn_id="nfl_postgres", sql="dwh/04_dim_game.sql",
    )
    dim_player = SQLExecuteQueryOperator(
        task_id="dim_player", conn_id="nfl_postgres", sql="dwh/05_dim_players.sql",
    )

    fact_plays = SQLExecuteQueryOperator(
        task_id="fact_plays", conn_id="nfl_postgres", sql="dwh/06_fact_plays.sql",
    )
    fact_tracking = SQLExecuteQueryOperator(
        task_id="fact_tracking", conn_id="nfl_postgres", sql="dwh/07_fact_tracking.sql",
    )

    # كل quality check بقى task منفصل بدل ملف واحد مجمّع
    check_fact_plays_rowcount = SQLValueCheckOperator(
        task_id="check_fact_plays_rowcount",
        conn_id="nfl_postgres",
        sql="SELECT COUNT(*) FROM dwh.fact_plays;",
        pass_value=19239,
        tolerance=0,
    )

    check_fact_plays_null_keys = SQLValueCheckOperator(
        task_id="check_fact_plays_null_keys",
        conn_id="nfl_postgres",
        sql="""
            SELECT COUNT(*) FROM dwh.fact_plays
            WHERE game_key IS NULL OR date_key IS NULL;
        """,
        pass_value=0,
        tolerance=0,
    )

    check_fact_tracking_rowcount = SQLValueCheckOperator(
        task_id="check_fact_tracking_rowcount",
        conn_id="nfl_postgres",
        sql="SELECT COUNT(*) FROM dwh.fact_tracking;",
        pass_value=932240,
        tolerance=0,
    )

    mart_team_performance = SQLExecuteQueryOperator(
        task_id="mart_team_performance", conn_id="nfl_postgres",
        sql="marts/01_mart_team_performance.sql",
    )
    mart_formation_analysis = SQLExecuteQueryOperator(
        task_id="mart_formation_analysis", conn_id="nfl_postgres",
        sql="marts/02_mart_formation_analysis.sql",
    )
    mart_situational = SQLExecuteQueryOperator(
        task_id="mart_situational", conn_id="nfl_postgres",
        sql="marts/03_mart_situational.sql",
    )
    mart_receiver_speed = SQLExecuteQueryOperator(
        task_id="mart_receiver_speed", conn_id="nfl_postgres",
        sql="marts/04_mart_receiver_speed.sql",
    )

    dimensions = [dim_team, dim_date, dim_formation, dim_game, dim_player]
    facts = [fact_plays, fact_tracking]
    checks = [
        check_fact_plays_rowcount,
        check_fact_plays_null_keys,
        check_fact_tracking_rowcount,
    ]
    marts = [
        mart_team_performance,
        mart_formation_analysis,
        mart_situational,
        mart_receiver_speed,
    ]

    load_staging >> dimensions >> facts >> checks >> marts
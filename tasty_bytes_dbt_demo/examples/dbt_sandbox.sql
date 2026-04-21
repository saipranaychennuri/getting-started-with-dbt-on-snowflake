SHOW TABLES IN DATABASE tasty_bytes_dbt_db;

SHOW VIEWS IN DATABASE tasty_bytes_dbt_db;

SHOW DBT PROJECTS LIKE 'tasty%';

CREATE OR REPLACE TASK TASTY_BYTES_DBT_DB.DEV.TASTY_BYTES_DBT_TASK
  WAREHOUSE = 'TASTY_BYTES_DBT_WH'
  SCHEDULE = 'USING CRON 0 * * * * America/Los_Angeles'
AS
  EXECUTE DBT PROJECT "TASTY_BYTES_DBT_DB"."DEV"."TASTY_BYTES_DBT_PROJECT"
    ARGS = 'build';

-- Tasks are created in a suspended state; resume to activate:
ALTER TASK TASTY_BYTES_DBT_DB.DEV.TASTY_BYTES_DBT_TASK suspend;

CREATE OR REPLACE TASK tasty_bytes_dbt_db.dev.run_prepped_data_dbt
  WAREHOUSE=tasty_bytes_dbt_wh
  SCHEDULE ='USING CRON 1 * * * * America/Los_Angeles'
AS
  EXECUTE DBT PROJECT tasty_bytes_dbt_project ARGS='run --select customer_loyalty_metrics --target dev';
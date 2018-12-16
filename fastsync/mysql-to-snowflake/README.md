FastSync - MySQL to Snowflake
-----------------------------

Sync mysql tables to snowflake with the most optimal steps:

* Get binlog position
* Generate Snowflake compatible DDL to create destination table
* Export to CSV
* Zip (TODO: split to multiple files up to 100MB/file)
* Upload to S3
* CREATE OR REPLACE target and temp table in Snowflake
* Load into Snowflake temp table with COPY
* Obfuscate columns in Snowflake temp table with UPDATE
* Swap temp to to final destination table in snowflake
* Write binlog position to singer state file

`mysql-to-snowflake --mysql-config [MYSQL_TAP_CONFIG] --snowflake-config [SNOWFLAKE_TARGET_CONFIG] --transform-config [TRANSFORMATIONS_CONFIG] --state [MYSQL_TAP_STATE] --target-schema [SNOWFLAKE_SCHEMA] --tables [LIST_OF_TABLES] --export-dir [TEMP_PATH_DIR]`

Sample config files

## mysql-config.json

```
  {
    "host": "localhost",
    "port": 5432,
    "dbname": "my_database",
    "user": "my_user",
    "password": "<PASSWORD>",
    "batch_size": 20000
  }
```

## snowflake-config.json

```
  {
      "account": "rt123456.eu-central-1",
      "aws_access_key_id": "<ACCESS_KEY_ID>",
      "aws_secret_access_key": "<SECRET_ACCESS_KEY>",
      "dbname": "analytics_db",
      "password": "<PASSWORD>",
      "s3_bucket": "tw-analyticsdb-etl",
      "s3_key_prefix": "snowflake-imports/",
      "user": "analyticsdb_etl",
      "warehouse": "LOAD_WH"
  }
```

## transformation.json

```
  {
    "transformations": [
      {
        "stream": "user_profile",
        "fieldId": "last_name",
        "type": "HASH"
      },
      {
        "stream": "user_profile",
        "fieldId": "registration_number",
        "type": "SET_NULL"
      }
    }
  }
```
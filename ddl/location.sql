--create a database
CREATE DATABASE SWIGGY ;
--create a schema
CREATE SCHEMA SWIGGY_LANDING;

--creata a integration this helps to connect to s3
--create a IAM role in AWS with account ID category that requires external token and provide the ARN here 
CREATE OR REPLACE STORAGE INTEGRATION SWIGGY_S3_INTEGRATION
TYPE = external_stage
STORAGE_PROVIDER ='S3'
ENABLED = TRUE 
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::533267217250:role/swiggy-dbt-airflow'
STORAGE_ALLOWED_LOCATIONS = ('s3://swiggy-dbt/');

--grant the usage to the role
GRANT USAGE ON INTEGRATION SWIGGY_S3_INTEGRATION TO ROLE ACCOUNTADMIN;

--use the below command to list the integrations and take the external credentials , now replace them in your AWS IAM role
DESC INTEGRATION SWIGGY_S3_INTEGRATION ;

--file format creation
create file format if not exists SWIGGY_LANDING.CSV_FILE_FORMAT 
        type = 'csv' 
        compression = 'auto' 
        field_delimiter = ',' 
        record_delimiter = '\n' 
        skip_header = 1 
        field_optionally_enclosed_by = '\042' 
        null_if = ('\\N');

--create a stage to load the data from s3
CREATE OR REPLACE STAGE MOVE_IT_IN
STORAGE_INTEGRATION = SWIGGY_S3_INTEGRATION
FILE_FORMAT = CSV_FILE_FORMAT
URL = 's3://swiggy-dbt/';

LIST  @MOVE_IT_IN;  

--table creation for location
create table SWIGGY_LANDING.location (
    locationid text,
    city text,
    state text,
    zipcode text,
    activeflag text,
    createddate text,
    modifieddate text,
    _stg_file_name text,
    _stg_file_load_ts timestamp,
    _stg_file_md5 text,
    _copy_data_ts timestamp default current_timestamp
);

copy into SWIGGY_LANDING.location FROM @MOVE_IT_IN
file_format = (format_name = 'csv_file_format')
PATTERN ='.*location-.*\.csv'
on_error = abort_statement;

--load data from the stage to the table 
copy into location (locationid, city, state, zipcode, activeflag, 
                    createddate, modifieddate, _stg_file_name, 
                    _stg_file_load_ts, _stg_file_md5, _copy_data_ts)
from (
    select 
        t.$1::text as locationid,
        t.$2::text as city,
        t.$3::text as state,
        t.$4::text as zipcode,
        t.$5::text as activeflag,
        t.$6::text as createddate,
        t.$7::text as modifieddate,
        metadata$filename as _stg_file_name,
        metadata$file_last_modified as _stg_file_load_ts,
        metadata$file_content_key as _stg_file_md5,
        current_timestamp as _copy_data_ts
    from @MOVE_IT_IN/Location/Incremental/day02-location.csv t
)
file_format = (format_name = 'csv_file_format')
on_error = abort_statement;






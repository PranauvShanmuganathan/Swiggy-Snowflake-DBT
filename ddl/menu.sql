create or replace table menu (
    menu_id text ,                   -- primary key as text
    restaurant_id text ,             -- foreign key reference as text (no constraint in snowflake)
    item_name text,                 -- item name as text
    description text,              -- description as text
    price text,                    -- price as text (no decimal constraint)
    category text,                 -- category as text
    availability text,             -- availability as text
    item_type text,                 -- item type as text
    created_date text,              -- created date as text
    modified_date text,             -- modified date as text
    _stg_file_name text,
    _stg_file_load_ts timestamp,
    _stg_file_md5 text,
    _copy_data_ts timestamp default current_timestamp
);
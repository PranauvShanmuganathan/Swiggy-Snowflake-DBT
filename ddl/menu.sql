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


copy into menu (menu_id, restaurant_id, item_name, description, price, category, 
                availability, item_type, created_date, modified_date,
                _stg_file_name, _stg_file_load_ts, _stg_file_md5, _copy_data_ts)
from (
    select 
        t.$1::text as menuid,
        t.$2::text as restaurantid,
        t.$3::text as itemname,
        t.$4::text as description,
        t.$5::text as price,
        t.$6::text as category,
        t.$7::text as availability,
        t.$8::text as itemtype,
        t.$9::text as createddate,
        t.$10::text as modifieddate,
        metadata$filename as _stg_file_name,
        metadata$file_last_modified as _stg_file_load_ts,
        metadata$file_content_key as _stg_file_md5,
        current_timestamp as _copy_data_ts
    from @MOVE_IT_IN/Menu/ t
)
file_format = (format_name = 'csv_file_format')
on_error = abort_statement;
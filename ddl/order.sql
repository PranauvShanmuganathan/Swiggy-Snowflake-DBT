create or replace table orders (
    order_id text ,
    customer_id text ,
    restaurant_id text ,
    order_date text,    
    total_amount text,  
    status text,        
    payment_method text,
    created_date text,  
    modified_date text, 
    _stg_file_name text,
    _stg_file_load_ts timestamp,
    _stg_file_md5 text,
    _copy_data_ts timestamp default current_timestamp
);

copy into orders (order_id, customer_id, restaurant_id, order_date, total_amount, 
                  status, payment_method, created_date, modified_date,
                  _stg_file_name, _stg_file_load_ts, _stg_file_md5, _copy_data_ts)
from (
    select 
        t.$1::text as orderid,
        t.$2::text as customerid,
        t.$3::text as restaurantid,
        t.$4::text as orderdate,
        t.$5::text as totalamount,
        t.$6::text as status,
        t.$7::text as paymentmethod,
        t.$8::text as createddate,
        t.$9::text as modifieddate,
        metadata$filename as _stg_file_name,
        metadata$file_last_modified as _stg_file_load_ts,
        metadata$file_content_key as _stg_file_md5,
        current_timestamp as _copy_data_ts
    from @MOVE_IT_IN/Order/ t
)
file_format = (format_name = 'csv_file_format')
on_error = abort_statement;
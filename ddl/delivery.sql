--delivery table creation
CREATE OR REPLACE TABLE delivery (
    delivery_sk INT AUTOINCREMENT PRIMARY KEY ,
    delivery_id INT NOT NULL ,
    order_id NUMBER NOT NULL ,                       
    delivery_agent_id NUMBER NOT NULL ,
    delivery_status STRING,                
    estimated_time STRING,                 
    customer_address_id NUMBER NOT NULL  ,
    delivery_date TIMESTAMP,              
    created_date TIMESTAMP,               
    modified_date TIMESTAMP,              
    _stg_file_name STRING,                
    _stg_file_load_ts TIMESTAMP,          
    _stg_file_md5 STRING,                 
    _copy_data_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);
LIST @MOVE_IT_IN;
copy into delivery (
    delivery_id,
    order_id,
    delivery_agent_id,
    delivery_status, 
    estimated_time,
    customer_address_id, 
    delivery_date, 
    created_date, 
    modified_date,
    _stg_file_name,
    _stg_file_load_ts, 
    _stg_file_md5,
    _copy_data_ts)
from (
    select 
        t.$1::text as deliveryid,
        t.$2::text as orderid,
        t.$3::text as deliveryagentid,
        t.$4::text as deliverystatus,
        t.$5::text as estimatedtime,
        t.$6::text as addressid,
        t.$7::text as deliverydate,
        t.$8::text as createddate,
        t.$9::text as modifieddate,
        metadata$filename as _stg_file_name,
        metadata$file_last_modified as _stg_file_load_ts,
        metadata$file_content_key as _stg_file_md5,
        current_timestamp as _copy_data_ts
    from @MOVE_IT_IN/Delivery/ t
)
file_format = (format_name = 'csv_file_format')
on_error = abort_statement;
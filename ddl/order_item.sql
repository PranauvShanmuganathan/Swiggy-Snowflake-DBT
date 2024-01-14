CREATE OR REPLACE TABLE order_item (
    order_item_sk NUMBER AUTOINCREMENT primary key ,
    order_item_id NUMBER  NOT NULL UNIQUE ,
    order_id_fk NUMBER  NOT NULL ,
    menu_id_fk NUMBER  NOT NULL ,
    quantity NUMBER(10, 2),      
    price NUMBER(10, 2),         
    subtotal NUMBER(10, 2),      
    created_dt TIMESTAMP,        
    modified_dt TIMESTAMP,       
    _stg_file_name VARCHAR(255),       
    _stg_file_load_ts TIMESTAMP,       
    _stg_file_md5 VARCHAR(255),        
    _copy_data_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);


copy into order_item (order_item_id, order_id_fk, menu_id_fk, quantity, price, 
                     subtotal, created_dt, modified_dt,
                     _stg_file_name, _stg_file_load_ts, _stg_file_md5, _copy_data_ts)
from (
    select 
        t.$1::text as orderitemid,
        t.$2::text as orderid,
        t.$3::text as menuid,
        t.$4::text as quantity,
        t.$5::text as price,
        t.$6::text as subtotal,
        t.$7::text as createddate,
        t.$8::text as modifieddate,
        metadata$filename as _stg_file_name,
        metadata$file_last_modified as _stg_file_load_ts,
        metadata$file_content_key as _stg_file_md5,
        current_timestamp as _copy_data_ts
    from @MOVE_IT_IN/Order_Item/order-item-initial-v2.csv t
)
file_format = (format_name = 'csv_file_format')
on_error = abort_statement;
CREATE OR REPLACE TABLE order_item (
    order_item_sk NUMBER AUTOINCREMENT primary key ,    -- Auto-incremented unique identifier for each order item
    order_item_id NUMBER  NOT NULL UNIQUE ,
    order_id_fk NUMBER  NOT NULL comment ,                  -- Foreign key reference for Order ID
    menu_id_fk NUMBER  NOT NULL comment ,                   -- Foreign key reference for Menu ID
    quantity NUMBER(10, 2),                 -- Quantity as a decimal number
    price NUMBER(10, 2),                    -- Price as a decimal number
    subtotal NUMBER(10, 2),                 -- Subtotal as a decimal number
    created_dt TIMESTAMP,                 -- Created date of the order item
    modified_dt TIMESTAMP,                -- Modified date of the order item
    _stg_file_name VARCHAR(255),            -- File name of the staging file
    _stg_file_load_ts TIMESTAMP,            -- Timestamp when the file was loaded
    _stg_file_md5 VARCHAR(255),             -- MD5 hash of the file for integrity check
    _copy_data_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp when data is copied into the clean layer
);

LIST @MOVE_IT_IN/Order_Item;

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
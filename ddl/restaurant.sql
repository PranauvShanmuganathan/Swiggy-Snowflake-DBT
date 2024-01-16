create or replace table restaurant (
    restaurantid text,      
    name text ,                                         -- restaurant name, required field
    cuisinetype text,                                    -- type of cuisine offered
    pricing_for_2 text,                                  -- pricing for two people as text
    restaurant_phone text,                               -- phone number as text
    operatinghours text,                                 -- restaurant operating hours
    locationid text ,                                    -- location id, default as text
    activeflag text ,                                    -- active status
    openstatus text ,                                    -- open status
    locality text,                                       -- locality as text
    restaurant_address text,                             -- address as text
    latitude text,                                       -- latitude as text for precision
    longitude text,                                      -- longitude as text for precision
    createddate text,                                    -- record creation date
    modifieddate text,                                   -- last modified date
    _stg_file_name text,
    _stg_file_load_ts timestamp,
    _stg_file_md5 text,
    _copy_data_ts timestamp default current_timestamp
);


copy into restaurant (restaurantid, name, cuisinetype, pricing_for_2, restaurant_phone, 
                      operatinghours, locationid, activeflag, openstatus, 
                      locality, restaurant_address, latitude, longitude, 
                      createddate, modifieddate, 
                      _stg_file_name, _stg_file_load_ts, _stg_file_md5, _copy_data_ts)
from @MOVE_IT_IN/Restaurant t
file_format = (format_name = 'csv_file_format')
on_error = abort_statement;
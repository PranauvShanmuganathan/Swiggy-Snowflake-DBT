{{
  config(
    materialized = 'table' ,
    alias = 'CUSTOMER_DETAILS'
    )
}}


WITH CUSTOMER_DETAIL AS (SELECT CUSTOMERID , NAME , MOBILE , EMAIL ,
CONCAT ('FLAT_NO :', FLAT_NO, ',',' ','HOUSE_NO :' ,HOUSE_NO ,', ',
CASE WHEN FLOOR=1 THEN CONCAT(FLOOR,'st', ' Floor')
     WHEN FLOOR=2 THEN CONCAT(FLOOR,'nd', ' Floor')
     WHEN FLOOR=3 THEN CONCAT(FLOOR,'rd', ' Floor')
     ELSE CONCAT(FLOOR,'th', ' Floor') 
     END , ', ' , BUILDING, ', ', LANDMARK, ', ' , LOCALITY , ', ', CITY, ', ' , PINCODE , ' -' , STATE ) AS ADDRESS  , GENDER  FROM CUSTOMER CUST
LEFT JOIN CUSTOMER_ADDRESS CUST_ADD
ON CUST_ADD.CUSTOMER_ID_FK = CUST.CUSTOMERID )
SELECT * FROM CUSTOMER_DETAIL
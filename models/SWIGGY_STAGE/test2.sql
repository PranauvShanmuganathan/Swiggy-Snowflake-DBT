WITH CTE AS (SELECT * FROM {{ref("CUSTOMER_DETAILS")}}
)
SELECT * FROM CTE
WITH CTE3 AS (
  SELECT * FROM {{ ref('test3') }}
)
SELECT * FROM CTE3
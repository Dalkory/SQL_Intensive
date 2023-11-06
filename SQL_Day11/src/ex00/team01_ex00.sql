SELECT distinct
    COALESCE(u.name,'not defined')  AS name, 
    COALESCE(u.lastname,'not defined')  AS lastname, 
    parsed.type,
    parsed.volume, 
    COALESCE(c.name,'not defined')  AS currency_name,
    COALESCE(c.rate_to_usd,1)  AS last_rate_to_usd,
    parsed.volume * COALESCE(c.rate_to_usd,1) as total_volume_in_usd
FROM 
(
    SELECT user_id, SUM(money) as volume, type, currency_id
    FROM balance
    GROUP BY user_id, type, currency_id
    ORDER BY 1
) AS parsed
LEFT JOIN "user" u on u.id = parsed.user_id
LEFT JOIN 
    (
        SELECT c.id, c.name, c.rate_to_usd, c.updated
        FROM currency c
        WHERE c.updated = (SELECT MAX(updated) 
        FROM currency WHERE name = c.name)
    ) c on c.id = parsed.currency_id 

ORDER BY 1 DESC, 2, 3 ASC
;

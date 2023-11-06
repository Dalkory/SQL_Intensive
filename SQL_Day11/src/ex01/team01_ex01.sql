insert into currency values (100, 'EUR', 0.85, '2022-01-01 13:29');
insert into currency values (100, 'EUR', 0.79, '2022-01-08 13:29');

SELECT DISTINCT
COALESCE(u.name, 'not defined') AS name,
COALESCE(u.lastname, 'not defined') AS last_name,
c.name AS currency_name,
b.money * 
CASE
WHEN c.name = 'EUR' THEN
    (SELECT rate_to_usd FROM currency WHERE name = c.name ORDER BY updated DESC LIMIT 1)
ELSE
    COALESCE((SELECT rate_to_usd FROM currency WHERE name = c.name AND updated <= b.updated ORDER BY updated DESC LIMIT 1),(SELECT rate_to_usd FROM currency WHERE name = c.name AND updated > b.updated ORDER BY updated ASC LIMIT 1))
END AS currency_in_usd
FROM 
"user" u RIGHT JOIN balance b ON u.id = b.user_id 
JOIN currency c ON b.currency_id = c.id

ORDER BY name DESC, last_name, currency_name ;

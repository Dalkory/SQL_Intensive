SELECT object_name
FROM (
	SELECT name AS object_name, 1 AS table_order
	FROM person
	UNION ALL
	SELECT pizza_name AS object_name, 2 AS table_order
	FROM menu
)
ORDER BY table_order, object_name;

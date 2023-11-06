WITH pathes AS (
	WITH RECURSIVE R AS 
	(
		SELECT array['a'] AS n, 0 AS index, 0 AS cost
		UNION ALL
		SELECT n || array[nodes.point1] AS n, R.index + 1 AS index, R.cost + ns.cost AS cost
		FROM nodes
		INNER JOIN R on nodes.point1 != ALL(R.n)
		INNER JOIN nodes ns on ns.point2 = R.n[R.index + 1] AND ns.point1 = nodes.point1
	)
	SELECT DISTINCT
		n[array_length(n, 1)] AS last_element,
		'a' AS end,
		n || array['a'] AS path,
		R.cost + ns.cost AS cost
	FROM R
	INNER JOIN nodes ns on ns.point1 = n[array_length(n, 1)] AND ns.point2 = 'a'
	WHERE array_length(n, 1) > 3
)
SELECT cost, path FROM pathes
ORDER BY 1, 2 
;
CREATE TABLE nodes 
(
    id bigint primary key,
    point1 varchar not null,
    point2 varchar not null,
	cost integer not null
);

INSERT INTO nodes (id, point1, point2, cost)
VALUES
    (1, 'a', 'b', 10),
    (2, 'a', 'c', 15),
    (3, 'a', 'd', 20),

    (4, 'b', 'a', 10),
    (5, 'b', 'c', 35),
    (6, 'b', 'd', 25),

    (7, 'c', 'a', 15),
    (8, 'c', 'b', 35),
    (9, 'c', 'd', 30),

    (10, 'd', 'a', 20),
    (11, 'd', 'b', 25),
    (12, 'd', 'c', 30);



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
WHERE cost=(SELECT min(cost) FROM pathes)
ORDER BY 1, 2 
;
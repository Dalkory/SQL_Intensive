CREATE INDEX idx_person_name ON person (UPPER(name));

SET ENABLE_SEQSCAN = false;
SET ENABLE_INDEXSCAN = true;

EXPLAIN ANALYSE
SELECT name
FROM person
WHERE UPPER(name) = 'DMITRIY'
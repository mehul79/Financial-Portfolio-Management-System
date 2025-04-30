DROP TABLE IF EXISTS test_table;
CREATE TABLE test_table (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);
INSERT INTO test_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');
SELECT * FROM test_table;
DROP TABLE test_table;
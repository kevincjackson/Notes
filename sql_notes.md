# SQL

## Basic Commands

```sql
INSERT INTO users (col1, col2, col3) VALUES ('val1', 'val2', 'val3')

SELECT col1, col2, col3 FROM users WHERE id < 12 ORDER BY asc

SELECT col1 FROM users JOIN table2 ON users.id=table2.user_id

UPDATE users SET col1='val1' WHERE id=2

DELETE FROM users WHERE id=2
```

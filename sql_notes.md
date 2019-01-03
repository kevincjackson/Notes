# SQL

## Code & Database Syncing
Keeping your application code and database schema
in sync is critical!

Keep a log of all commands which alter your database or save database schemas to source control.


## Basic Commands

Comment
```sql
/* An sql comment */
```

Syntax
```sql
/* Ending semicolons required. */;
/* YOUR COMMAND */;
```
Get / set data
```sql
/* Add data */
INSERT INTO users (col1, col2, col3) VALUES ('val1', 'val2', 'val3');

/* Get data */
SELECT col1, col2, col3 FROM users WHERE id < 12 ORDER BY asc;

/* Get data from multiple tables */
SELECT col1 FROM users JOIN table2 ON users.id=table2.user_id;

/* Change data */
UPDATE users SET col1='val1' WHERE id=2;

/* Delete data */
DELETE FROM users WHERE id=2;
```

More

```sql
/* Make a new table */
CREATE TABLE users (name varchar(256));

/* Add a column to a table */
ALTER TABLE users ADD age smallint;

/* Add complete row of data */
INSERT INTO users VALUES ('dave', 20 );

/* Specify specific field to add */
INSERT INTO login (email) VALUES ('sally@gmail.com');

/* Get complete table */
SELECT * FROM users;

/* Delete a row */
DELETE FROM users WHERE name = 'john';

/* Delete a table */
DROP TABLE login;
```

Regex
```sql
/* Get all names starting with 'a' */
SELECT * FROM users WHERE name LIKE 'a%'

/* Get all names ending with 'a' */
SELECT * FROM users WHERE name LIKE '%a'
```

Sorting
```sql
/* Syntax */
ORDER BY col ASC / DESC

/* Get users starting with youngest */
SELECT * FROM users ORDER BY age ASC

/* Get users starting with oldest */
SELECT * FROM users ORDER BY age ASC
```

Functions  

```sql
SELECT COUNT(age) FROM users;
SELECT AVG(age) FROM users;
SELECT SUM(age) FROM users;
```

Join
```sql
/* Combine two tables where a certain column matches */
SELECT * FROM users JOIN tweets ON users.id = tweets.user_id
```

### Database Commands

`ALTER`, `CREATE`, `DROP`, `USE`

### Table Commands

`CREATE`, `DROP`
`ALTER`, `BACKUP`, `DESCRIBE`, `RENAME`, `TRUNCATE`, `LOCK`, `UNLOCK`

### Row Commands

`DELETE`, `INSERT`, `UPDATE`

### User Commands

`GRANT`, `HELP`, `EXIT`, `QUIT`, `SHOW`, `SOURCE`, `STATUS`

# Postgresql

## Documentation

| Link | Description |
| - | - |
| <https://www.postgresql.org/docs/> | Complete Docs |
| <https://www.techonthenet.com/postgresql/datatypes.php> | Easy to read datatype table |

## Installation

```sh
brew install postgresql
```

For a free GUI, download and install **Psequel** from <www.psequel.com>

## Serve

```sh
brew services start postgresql # Start
brew services stop postgresql # Stop
```

## Make a database

```sh
createdb 'test'
```

## Command line

Launch repl

```sh
psql 'test'
```

Basic commands

```sql
\q  # Quit
\d  # Show schema
```


Primary Key Command

```sql
CREATE TABLE users(
    id SERIAL NOT NULL PRIMARY KEY,
    email text UNIQUE NOT NULL,
    hash varchar(100) NOT NULL
);
```

## Good Learning Exercises
- <https://www.khanacademy.org/computing/computer-programming/sql>
- <https://www.codeacademy.com/learn/learn-sql>

## Node Database Helpers
- <https://knexjs.org/> User friendly
- <https://www.npmjs.com/package/pg-promise>, Basic no frills

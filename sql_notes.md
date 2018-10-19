# SQL

## Basic Commands

```sql
INSERT INTO users (col1, col2, col3) VALUES ('val1', 'val2', 'val3');

SELECT col1, col2, col3 FROM users WHERE id < 12 ORDER BY asc;

SELECT col1 FROM users JOIN table2 ON users.id=table2.user_id;

UPDATE users SET col1='val1' WHERE id=2;

DELETE FROM users WHERE id=2;
```

More

```sql
CREATE TABLE users (name varchar(256));

ALTER TABLE users ADD age smallint;

INSERT INTO users VALUES ('dave', 20 );

INSERT INTO login (email) VALUES ('sally@gmail.com');

SELECT * FROM users;

DELETE FROM users WHERE name = 'john';

DROP TABLE login;
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

# Posgresql

## Documentation

<https://www.postgresql.org/docs/>

## Installation

```sh
brew install posgresql
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

Functions

```sql
SELECT COUNT(age) FROM users;
SELECT AVG(age) FROM users;
SELECT SUM(age) FROM users;
```

Primary Key Command

```sql
CREATE TABLE users(
    id SERIAL NOT NULL PRIMARY KEY,
    email text UNIQUE NOT NULL,
    hash varchar(100) NOT NULL
);
```

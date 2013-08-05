-- How to add "VPD" like capabilities:
--  1. Create a similar table with an added column: tenant_id
--  2. Drop the table
--  3. Define a function that returns the tenant_id
--  4. Create a view with the same name of the table, without the tenant_id extra column, which is extracted from the function create above
--  5. Create a set of triggers for (INSERT, UPDATE) to coerce the tenant
--  6. Before each statement, set the appropriate context variables for the function in step 3. to work properly
--  7. The models should only use the view

SHOW VARIABLES LIKE "log_bin_trust_function_creators";

DROP TABLE IF EXISTS books;
CREATE TABLE books (
    id           INT AUTO_INCREMENT NOT NULL,
    title        VARCHAR(80),
    author       VARCHAR(20),
    cover        BLOB,
    description  TEXT,
    owner        VARCHAR(30), -- to store book's owner
    /* Keys */
    PRIMARY KEY (id)
);

INSERT INTO books VALUES (10, 'title A', 'author A', null, 'book A', 'ownerA');
INSERT INTO books VALUES (20, 'title A1', 'author A1', null, 'book A1', 'ownerA');
INSERT INTO books VALUES (30, 'title B', 'author B', null, 'book B', 'ownerB');
INSERT INTO books VALUES (40, 'title B1', 'author B1', null, 'book B1', 'ownerB');

DROP FUNCTION IF EXISTS p1;
DELIMITER $$
CREATE FUNCTION p1()
RETURNS TEXT
LANGUAGE SQL
BEGIN
    RETURN @p1;
END;
$$
DELIMITER ;

DROP VIEW IF EXISTS owned_books;
CREATE VIEW owned_books(
    title,
    author,
    cover,
    descrition
)
AS
SELECT
books.title AS title,
books.author AS author,
books.cover AS cover,
books.description AS descrition
FROM books
WHERE
(books.owner = (SELECT p1()));

DROP TRIGGER IF EXISTS tr_books_before_insert;
DELIMITER $$
CREATE TRIGGER tr_books_before_insert
BEFORE INSERT
ON books
FOR EACH ROW
BEGIN
    SET NEW.owner = (SELECT p1());
END;
$$
DELIMITER ;

DROP TRIGGER IF EXISTS tr_books_before_update;
DELIMITER $$
CREATE TRIGGER tr_books_before_update
BEFORE UPDATE
ON books
FOR EACH ROW
BEGIN
    SET NEW.owner = (SELECT p1());
END;
$$
DELIMITER ;

SELECT @p1 := 'ownerA';
SELECT * FROM books;
SELECT * FROM owned_books;

SELECT @p1 := 'ownerA';
INSERT INTO owned_books VALUES ('title A3', 'author A', null, 'book A');
SELECT @p1 := 'ownerB';
INSERT INTO owned_books VALUES ('title A3', 'author A', null, 'book A');
SELECT * FROM books;
UPDATE owned_books SET title = 'title A3fix' WHERE title = 'title A3';
SELECT * FROM books;
DELETE FROM owned_books WHERE title = 'title A3fix';
SELECT * FROM books;


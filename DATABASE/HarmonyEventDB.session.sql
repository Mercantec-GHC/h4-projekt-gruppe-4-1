-- @block
DROP DATABASE saaapidk_db

--@block
CREATE DATABASE IF NOT EXISTS saaapidk_db;

--@block
CREATE TABLE POCTest (
    TestID int,
    LastName varchar(255),
    FirstName varchar(255)
);

--@block
DROP TABLE POCTest (
    TestID int,
    LastName varchar(255),
    FirstName varchar(255)
);

--@block
INSERT INTO Users (FirstName, LastName, Email, Username, PasswordBackdoor)
VALUES ('To', 'Kula', 'to@kula.dk', 'Søren', 'Søren_1');

--@block
SELECT * FROM Users
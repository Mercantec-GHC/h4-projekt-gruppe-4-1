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
DROP TABLE POCTest (
    TestID int,
    LastName varchar(255),
    FirstName varchar(255)
);
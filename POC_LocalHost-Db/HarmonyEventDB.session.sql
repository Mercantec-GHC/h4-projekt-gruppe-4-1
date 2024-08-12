-- @block
DROP DATABASE saaapidk_db

--@block
CREATE DATABASE IF NOT EXISTS saaapidk_db;

--@block
CREATE TABLE IF NOT EXISTS POCTest (
    TestID int,
    LastName varchar(255),
    FirstName varchar(255)
);
--@block
DROP TABLE POCTest;
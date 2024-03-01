CREATE DATABASE DBTRAN
GO
USE [DB_OBJECTS]

create table Reservation
(
Aircraft_Code varchar(10), 
No_of_Seats int, 
Class_Code varchar(10)
)


INSERT INTO Reservation VALUES ('AI01', 21, 'ECO')			
INSERT INTO Reservation VALUES ('AI02', 22, 'ECO')	


USE DBTRAN

BEGIN TRANSACTION T1
INSERT INTO Reservation VALUES ('AI03', 21, 'ECO')
INSERT INTO Reservation VALUES ('AI04', 22, 'ECO')


ROLLBACK

USE MASTER  
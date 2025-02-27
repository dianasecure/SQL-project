-- Database Testing

-- a table with a single-column primary key and no foreign keys - FEST
	create table Fest(
		festID int not null,
		constraint pk_fest primary key(festID)
	)

	drop table Fest
-- a table with a single-column primary key and at least one foreign key - SPONSOR
	create table Sponsor(
		sponsorID int not null,
		constraint pk_sponsor primary key (sponsorID),
		festID int references Fest(festID)
	)
	drop table Sponsor
-- a table with a multicolumn primary key - CHECKED TICKET
	create table CheckedTicket(
		personID int not null,
		ticketID int not null,
		constraint pk_checkedTicket primary key(personID, ticketID)
	)
	drop table checkedticket

	create table aux (id int not null, constraint pk_aux primary key(id))

	insert into aux values (1), (2), (3)

	drop table aux

-- a view with a SELECT statement operating on one table:
go
create or alter view viewFestival
as
	select * from Fest
go
-- a view with a SELECT statement that operates on at least 2 different tables and contains at least one JOIN operator:
go
create or alter view viewSponsor
as
	select Sponsor.sponsorID
	from Sponsor inner join Fest on Sponsor.festID = Fest.festID
go
-- a view with a SELECT statement that has a GROUP BY clause, operates on at least 2 different tables and contains at least one JOIN operator:
go
create or alter view viewCheckedTicket
as
	select CheckedTicket.personID, COUNT(CheckedTicket.ticketID) as TicketCount
	from CheckedTicket
	inner join aux on aux.id = CheckedTicket.personID
	group by CheckedTicket.personID;
go


-- Tables: 
create table Tables(
	tableID int primary key identity (1, 1) NOT NULL, 
	title varchar(50)
)

insert into tables values ('Festival'), ('Sponsor'), ('CheckedTicket')
select * from tables

-- Views:
create table Views(
	viewsID int primary key identity (1, 1) NOT NULL,
	title varchar(100)
)

insert into views values ('viewFestival'), ('viewSponsor'), ('viewCheckedTicket')
select * from views

create table Tests(
	testID int primary key identity (1, 1) NOT NULL,
	title varchar(50)
)

insert into Tests values('select_view'), ('insert_festival'), ('delete_festival')
insert into Tests values('insert_sponsor'), ('delete_sponsor')
insert into Tests values('insert_ticket'), ('delete_ticket')
select* from tests


create table TestViews(
	testID int foreign key references Tests(testID),
	viewsID int foreign key references Views(viewsID)
)

insert into testViews values (1, 1), (1, 2), (1, 3)
select * from TestViews

create table TestTables (
	testID int foreign key references Tests(testID),
	tableID int foreign key references Tables(tableID),
	NoOfRows int,
	Position int
)


insert into TestTables values (2, 1, 100, 2)
insert into TestTables values (4, 2, 100, 1)
insert into TestTables values (6, 3, 100, 3)
select * from TestTables


GO
CREATE OR ALTER PROC insert_festival
AS 
	DECLARE @i INT = 1
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestId = 2
	--PRINT (@rows)
	WHILE @i <= @rows 
	BEGIN 
		INSERT INTO Fest VALUES (@i + 1)
		SET @i = @i + 1 
	END 
GO 

CREATE OR ALTER PROC delete_festival
AS 
	DELETE FROM Fest WHERE festID>1;

GO 

CREATE OR ALTER PROC insert_sponsor
AS 
	DECLARE @i INT = 1
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestId = 4
	WHILE @i <= @rows 
	BEGIN 
		INSERT INTO Sponsor VALUES (@i, 2)
		SET @i = @i + 1 
	END 

GO 
CREATE OR ALTER PROC delete_sponsor
AS 
	DELETE FROM Sponsor;

GO
CREATE OR ALTER PROC insert_ticket
AS 
	DECLARE @i INT = 1
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestId = 6
	--PRINT (@rows)
	WHILE @i <= @rows 
	BEGIN 
		INSERT INTO CheckedTicket VALUES (@i, @i)
		SET @i = @i + 1 
	END 

GO 
CREATE OR ALTER PROC delete_ticket
AS 
	DELETE FROM CheckedTicket;


create table TestRuns(
	TestRunID int primary key identity(1, 1),
	descr varchar(200),
	StartAt datetime,
	EndAt datetime
)
drop table TestRuns

create table TestRunTables (
	TestRunID int foreign key references TestRuns(TestRunID),
	tableID int foreign key references Tables(tableID),
	StartAt datetime,
	EndAt datetime
)
drop table TestRunTables

create table TestRunViews (
	TestRunID int foreign key references TestRuns(TestRunID),
	viewsID int foreign key references Views(viewsID),
	StartAt datetime,
	EndAt datetime
)
drop table TestRunViews

GO
CREATE OR ALTER PROC TestRunViewsProc
AS 
	DECLARE @start1 DATETIME;
	DECLARE @start2 DATETIME;
	DECLARE @start3 DATETIME;
	DECLARE @end1 DATETIME;
	DECLARE @end2 DATETIME;
	DECLARE @end3 DATETIME;
	
	SET @start1 = GETDATE();
	PRINT ('executing select * from fest')
	EXEC ('SELECT * FROM viewFestival');
	SET @end1 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_view', @start1, @end1)
    INSERT INTO TestRunViews VALUES (@@IDENTITY, 1, @start1, @end1);

	SET @start2 = GETDATE();
	PRINT ('executing select * from sponsor')
	EXEC ('SELECT * FROM viewSponsor');
	SET @end2 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_view2', @start2, @end2)
    INSERT INTO TestRunViews VALUES (@@IDENTITY, 2, @start2, @end2);


	SET @start3 = GETDATE();
	PRINT ('executing select * from checked ticket')
	EXEC ('SELECT * FROM viewCheckedTicket');
	SET @end3 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_view3', @start3, @end3)
    INSERT INTO TestRunViews VALUES (@@IDENTITY, 3, @start3, @end3);

GO
CREATE OR ALTER PROC TestRunTablesProc
AS 
	DECLARE @start1 DATETIME;
	DECLARE @start2 DATETIME;
	DECLARE @start3 DATETIME;
	DECLARE @start4 DATETIME;
	DECLARE @start5 DATETIME;
	DECLARE @start6 DATETIME;
	DECLARE @end1 DATETIME;
	DECLARE @end2 DATETIME;
	DECLARE @end3 DATETIME;
	DECLARE @end4 DATETIME;
	DECLARE @end5 DATETIME;
	DECLARE @end6 DATETIME;

	SET @start2 = GETDATE();
	PRINT('deleting data from Festival')
	EXEC delete_festival;
	SET @end2 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_delete_festival',@start2, @end2);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 1, @start2, @end2);

	SET @start1 = GETDATE();
	PRINT('inserting data into Festival')
	EXEC insert_festival;
	SET @end1 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_insert_festival',@start1, @end1);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 1, @start1, @end1);

	SET @start4 = GETDATE();
	PRINT('deleting data from Sponsor')
	EXEC delete_sponsor;
	SET @end4 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_delete_sponsor',@start4, @end4);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 2, @start4, @end4);

	SET @start3 = GETDATE();
	PRINT('inserting data into sponsor')
	EXEC insert_sponsor;
	SET @end3 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_insert_sponsor',@start3, @end3);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 2, @start3, @end3);

	SET @start6 = GETDATE();
	PRINT('deleting data from CheckedTicket')
	EXEC delete_ticket;
	SET @end6 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_delete_ticket',@start6, @end6);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 3, @start6, @end6);

	SET @start5 = GETDATE();
	PRINT('inserting data into CheckedTicket')
	EXEC insert_ticket;
	SET @end5 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_insert_ticket',@start5, @end5);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 3, @start5, @end5);


GO 

EXEC TestRunTablesProc;
EXEC TestRunViewsProc;

SELECT * FROM TestRuns
SELECT * FROM TestRunViews
SELECT * FROM TestRunTables

DELETE FROM TestRunViews
DELETE FROM TestRunTables
DELETE FROM TestRuns





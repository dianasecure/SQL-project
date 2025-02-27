-- Indexes
-- clustered index scan;
-- clustered index seek;
-- nonclustered index scan;
-- nonclustered index seek;
-- key lookup.

-- TA
CREATE TABLE Ticket (
    ticketID int NOT NULL,
    stages_on int NOT NULL,
    vip_code int NOT NULL,
    PRIMARY KEY (ticketID),
	UNIQUE (vip_code)
)

-- TB
CREATE TABLE Person (
    personID int NOT NULL,
    age int NOT NULL,
    money_in int NOT NULL,
    PRIMARY KEY (personID),
    
)

-- TC
CREATE TABLE TicketCheckedIn (
    tcID int NOT NULL,
    personID int NOT NULL,
    ticketID int NOT NULL,
    PRIMARY KEY (tcID),
    FOREIGN KEY (ticketID) REFERENCES Ticket(ticketID),
    FOREIGN KEY (personID) REFERENCES Person(personID)
)

GO
CREATE PROCEDURE populateTableTa(@rows INT) AS
	while @rows > 0 BEGIN
		INSERT INTO Ticket VALUES(@rows, @rows + 100, @rows + 200)
		SET @rows = @rows - 1
	END;
GO

GO
CREATE PROCEDURE populateTableTb(@rows INT) AS
	while @rows > 0 BEGIN
		INSERT INTO Person VALUES(@rows, @rows + 100, @rows + 200)
		SET @rows = @rows - 1
	END;
GO

GO
CREATE PROCEDURE populateTableTc(@rows INT) AS
	while @rows > 0 BEGIN
		INSERT INTO TicketCheckedIn VALUES(@rows, @rows, @rows)
		SET @rows = @rows - 1
	END;
GO

exec populateTableTa 1000
exec populateTableTb 1000
exec populateTableTc 1000


-- a

-- Clustered index scan
SELECT * FROM Ticket ORDER BY ticketID; 

-- Clustered index seek
SELECT * FROM Ticket WHERE ticketID = 105;

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index1')
    DROP INDEX index1 ON Ticket;

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'index1')
    CREATE NONCLUSTERED INDEX index1 ON Ticket(vip_code);

-- Nonclustered index scan + Key lookup
SELECT vip_code FROM Ticket;

-- Nonclustered index seek + Key lookup
SELECT * FROM Ticket WHERE vip_code = 28;


-- b

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index2')
    DROP INDEX index2 ON Person;

SELECT * FROM Person WHERE money_in=0; -- 0.0066

CREATE NONCLUSTERED INDEX index2 on Person(money_in);

SELECT * FROM Person WHERE money_in=0; -- 0.0032
GO



-- c

CREATE OR ALTER VIEW view1 AS 
	SELECT c.personID, SUM(a.vip_code) AS sumb2
	FROM TicketCheckedIn c INNER JOIN Person b ON c.personID = b.personID INNER JOIN Ticket a ON c.ticketID = a.ticketID
	WHERE a.vip_code <= 10000 AND b.money_in <= 10000
	GROUP BY c.personID;
GO

SELECT * FROM view1; -- 0.0051227

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index1')
    DROP INDEX index1 ON Ticket;
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'index2')
    DROP INDEX index2 ON Person;

CREATE NONCLUSTERED INDEX index1 ON Ticket(vip_code);
CREATE NONCLUSTERED INDEX index2 ON Person(money_in);

SELECT * FROM view1; -- 0.00051227







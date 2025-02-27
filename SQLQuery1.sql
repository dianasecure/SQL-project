create table Festival(
	festivalID int primary key identity(1, 1),
	title varchar(100) not null,
)

create table VDepartment(
	vdepartmentID int primary key identity(1, 1),
	festivalID int foreign key references Festival(festivalID),
	title varchar(100) not null
)

create table Volunteer(
	volunteerID int primary key identity(1, 1),
	vdepartmentID int foreign key references VDepartment(vdepartmentID),
	title varchar(100),
	date_of_birth date NULL,
)

create table Stage(
	stageID int primary key identity(1, 1),
	festivalID int foreign key references Festival(festivalID),
	title varchar(100),
	capacity int
)

create table FoodCourt(
	foodCourtID int primary key identity(1, 1),
	festivalID int foreign key references Festival(festivalID),
	fastFood varchar(100),
	workers int
)


create table Country(
	countryID int primary key identity(1, 1),
	title varchar(100),
	population_nr int,
	flag image
)

create table FestCountry(
	festivalID int foreign key references Festival(festivalID),
	countryID int foreign key references Country(countryID),
	primary key (festivalID, countryID),
	big_title varchar(100)
) 

create table Account(
	accountID int primary key identity(1, 1),
	title varchar(100),
	passw varchar(100),
	profile_pic image
)

create table MyList(
	festivalID int foreign key references Festival(festivalID),
	accountID int foreign key references Account(accountID),
	primary key (festivalID, accountID)
)



create table Genre(
	genreID int primary key identity(1, 1),
	title varchar(100)
)


create table Artist(
	artistID int primary key identity(1, 1),
	genreID int foreign key references Genre(genreID),
	title varchar(100),
	price int,
	type_of varchar(20)
)


create table FestivalArtist(
	festivalID int foreign key references Festival(festivalID),
	artistID int foreign key references Artist(artistID),
	primary key(festivalID, artistID)
)

create table Ticket(price int);
alter table Ticket
add festivalID int foreign key references Festival(festivalID)

select * from Volunteer

alter table Volunteer
add experience int

insert into Festival values ('Untold'), ('Beach Please'), ('Tomorrowland')
insert into Festival values ('Electric Castle'), ('Sziget Festival'), ('Coachella'), ('Loollapalooza'), ('Ultra Europe')
insert into FoodCourt values (3, 'Pizza', 3), (3, 'Pasta', 3), (2, 'Burger', 2)
insert into Country values ('Romania', 0, NULL), ('Dubai', 0, NULL), ('Belgium', 0, NULL)
insert into Country values ('Germania', 0, NULL), ('Croatia', 0, NULL), ('California', 0, NULL)
insert into FestCountry values (1, 1, 'Untold Romania'), (1, 2, 'Untold Dubai'), (2, 1, 'Beach, Please! Romania'), (3, 3, 'Tomorrowland')
insert into Account values('diana_secure', 'parola123', NULL)
insert into Account values('a2', 'p2', NULL)
insert into MyList values(1, 1, 1)
insert into MyList values(2, 1, 1), (3, 1, 1)
insert into MyList values(4, 2, 1), (5, 2, 1)
insert into Genre values('Pop'), ('House'), ('EDM'), ('Rock'), ('Trap')
insert into VDepartment values (1, 'U_D1'), (1, 'U_D2'), (1, 'U_D3'), (2, 'BP_D1'), (2, 'BP_D2') -- with id 2 deleted
insert into VDepartment values (3, 'T_D1')
insert into Volunteer values (1, 'Diana', '2003-12-17', 1), (2, 'Ioana', '2006-01-27', 0)
insert into Volunteer values (3, 'V3', '2003-12-17', 2), (3, 'V4', '2006-01-27', 3)
insert into Volunteer values (3, 'V5', '2003-11-11', 4), (1, 'V6', '2003-10-12', 5)
insert into Stage values (2, 'Trap', 9000), (2, 'Main', 15000), (3, 'Ascendo Mainstage', 52000)
INSERT INTO Artist (genreID, title, price, type_of) VALUES (3, 'Martin Garrix', 749000, 'Solo');
INSERT INTO Artist (genreID, title, price, type_of) VALUES (5, 'Playboi Carti', 1499000, 'Solo');
INSERT INTO Artist (genreID, title, price, type_of) VALUES (2, 'Armin van Buuren', 100000, 'Solo');
INSERT INTO Artist (genreID, title, price, type_of) VALUES (1, 'Ava Max', 299000, 'Solo');
insert into FestivalArtist values (1, 1), (2, 2), (1, 3), (3, 3)



select* from FestivalArtist
select* from artist
select* from festival
select* from account
select* from mylist
select* from FoodCourt
select* from country
select* from festCountry
select* from genre
select* from stage
select* from Volunteer
select* from VDepartment
select* from MyList
select* from foodcourt

-- violate referential integrity constraints
insert into Stage values (20, 'S4', 1000)
-- error
insert into Festival values('Festival for test')
select*
from Festival
insert into Stage values(11, 'Stage for test', 1000)
delete from Festival
where festivalID = 11
select * from Festival
-- error

update Festival
set title='Beach, Please!'
where title like 'Beach Please' 
Select * from Festival

update Stage
set title='Mainstage Ascendo'
where title like 'Ascendo Mainstage' 
Select * from Stage

update FoodCourt
set workers = 3
where fastFood IS NOT NULL AND festivalID = 3
select * from FoodCourt

update FoodCourt
set workers = 2
where fastFood IS NOT NULL AND festivalID = 2
select * from FoodCourt

update Stage
set capacity=11000
where festivalID = 2 AND title like 'Trap'
select * from Stage

update Stage
set capacity = 30000
where festivalID = 1 and title like 'Main Stage'
select * from Stage

update Stage
set capacity = 9000
where festivalID = 1 and title like 'Galaxy'
select * from Stage

delete from Stage
where capacity < 100
select * from Stage

delete from VDepartment
where festivalID in (2, 3)
select * from VDepartment

-- UNION and OR
-- 1
select *
from Stage
Where title like 'M_%' OR capacity >= 30000
-- equivalent: 
select*
from Stage
where title like 'M_%'
UNION
select*
from Stage
where capacity >= 30000
-- 2
select*
from FoodCourt
where workers > 1 and fastFood like 'P%'
-- equivalent
select*
from FoodCourt
where workers > 1
UNION
select*
from FoodCourt
where fastFood like 'P%'


-- INTERSECTION and IN
select*
from Volunteer v1
where title like 'V_%'
INTERSECT -- AND
select*
from Volunteer v2
where YEAR(date_of_birth) = 2003

select f.festivalID
from Festival f
where festivalID IN (select s.festivalID from Stage s)


-- EXCEPT AND NOT IN
select*
from Volunteer v1
where title like 'V_%'
EXCEPT 
select*
from Volunteer v2
where YEAR(date_of_birth) = 2003

select v.volunteerID
from Volunteer v
where volunteerID NOT IN (select d.vdepartmentID from VDepartment d)

-- JOIN
select*
from Festival, Country
select*
from Stage
insert into Stage values(11, 'Stage for test 2', 1000)
-- INNER JOIN
select *
from Festival f INNER JOIN Stage s ON f.festivalID = s.festivalID
select*
from Festival f INNER JOIN FoodCourt fc ON f.festivalID = fc.festivalID
select*
from Festival f INNER JOIN VDepartment vd ON f.festivalID = vd.festivalID


insert into Festival values ('F4'), ('F5')
-- LEFT OUTER JOIN
select*
from Festival f LEFT OUTER JOIN Stage s ON f.festivalID = s.festivalID

select * from Account
-- RIGHT OUTER JOIN
select*
from Festival f RIGHT OUTER JOIN MyList ml ON f.festivalID = ml.festivalID

-- FULL OUTER JOIN
select*
from Festival f FULL OUTER JOIN FestCountry fc ON f.festivalID = fc.festivalID


-- e.
select s.festivalID, s.capacity
from Stage s
where capacity>10000 and s.festivalID IN (select f.festivalID from Festival f where f.title like 'U%')

select fc.festivalID, fc.workers
from FoodCourt fc
where workers > 2 and fc.festivalID IN (select f.festivalID from Festival f where festivalID in (1,2,3))

-- f.
select s.festivalID, s.capacity
from Stage s
where capacity>10000 and EXISTS (select * from Festival f where f.festivalID = s.festivalID)

-- g.
select TOP 3 A.festivalID, A.capacity
from (select f.festivalID, s.title, s.capacity
		from Festival f INNER JOIN Stage s ON f.festivalID = s.festivalID
		where capacity>10000) A


select*
from Stage
-- h.
select f.festivalID, sum(fc.workers) AS sum_of_workers
from Festival F INNER JOIN FoodCourt fc ON fc.festivalID = f.festivalID
group by f.festivalID

select f.festivalID, avg(s.capacity) AS average_capacity
from Festival F INNER JOIN Stage s ON s.festivalID=f.festivalID
GROUP BY f.festivalID
HAVING avg(s.capacity) >= 20000

select f.festivalID, avg(s.capacity) AS average
from Festival F INNER JOIN Stage s ON s.festivalID=f.festivalID
GROUP BY f.festivalID
HAVING avg(s.capacity) >= (select min(capacity) from Stage)

select f.festivalID, avg(s.capacity) AS average
from Festival F INNER JOIN Stage s ON s.festivalID=f.festivalID
GROUP BY f.festivalID
HAVING f.festivalID <= (select max(festivalID) from Stage)

-- i.
select a.title, a.price
from Artist a
where a.price > ALL(select a1.price from Artist a1 where a.artistID=a1.artistID)

select a.title, a.price
from Artist a
where a.price > (select max(a1.price) from Artist a1 where a.artistID=a1.artistID)

select s.title, s.capacity
from Stage s
where s.capacity <> ALL(select s1.capacity from Stage s1 where s.stageID=s1.stageID)

select s.title, s.capacity
from Stage s
where s.capacity NOT IN(select s1.capacity from Stage s1 where s.stageID=s1.stageID)

--
select distinct s.title, (s.capacity+2000) /3
from Stage s
where s.title like 'M_%' and s.capacity < ANY(select s1.capacity from Stage s1 where s.stageID=s1.stageID)

select distinct s.title, (s.capacity-1)
from Stage s
where s.title not like 'M_%' and s.capacity <(select min(s1.capacity) from Stage s1 where s.stageID=s1.stageID)

select distinct a.title, (a.price*3)
from Artist a
where a.title like 'A%' and a.price = ANY(select a1.price from Artist a1 where a.artistID=a1.artistID)
order by a.title

select TOP 3 a.title, a.price
from Artist a
where a.price IN (select a1.price from Artist a1 where a.artistID=a1.artistID)
order by a.title

-- a. 2 queries with the union operation; use UNION [ALL] and OR;
-- b. 2 queries with the intersection operation; use INTERSECT and IN;
-- c. 2 queries with the difference operation; use EXCEPT and NOT IN;
-- d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one
-- query per operator); one query will join at least 3 tables, while another
-- one will join at least two many-to-many relationships;
-- e. 2 queries using the IN operator to introduce a subquery in the WHERE
-- clause; in at least one query, the subquery should include a subquery in
-- its own WHERE clause;
-- f. 2 queries using the EXISTS operator to introduce a subquery in the
-- WHERE clause;
-- g. 2 queries with a subquery in the FROM clause;
-- h. 4 queries with the GROUP BY clause, 3 of which also contain the
-- HAVING clause; 2 of the latter will also have a subquery in the HAVING
-- clause; use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;
-- i. 4 queries using ANY and ALL to introduce a subquery in the WHERE
-- clause; rewrite 2 of them with aggregation operators, and the other 2
-- with [NOT] IN.
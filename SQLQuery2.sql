-- Function to reverse changes in the database

create table Version(versionID int primary key identity, versionNo int)
insert into Version values(0)
update Version set versionNo = 0 where versionID = (select max(versionID) from Version)
select* from Version

alter table MyList
add fav_fest int

-- DO 1. Function to modify the type of a column
create procedure do_modify_type_column
as
begin
	alter table MyList
	alter column fav_fest int
	select* from MyList
	print 'Done do modify type of column procedure. '

	update Version set versionNo = 1 where versionID = (select max(versionID) from Version)
end

-- UNDO 1.
create procedure undo_modify_type_column
as
begin
	alter table MyList
	alter column fav_fest varchar(50)
	select* from MyList
	print 'Done undo modify type of column procedure. '

	update Version set versionNo = 0 where versionID = (select max(versionID) from Version)
end

-- DO 2. Add a column 
create procedure do_add_column
as
begin
	alter table FestCountry
	add pic image
	select* from FestCountry
	print 'Done do add column. '

	update Version set versionNo = 2 where versionID = (select max(versionID) from Version)
end
-- UNDO 2.
create procedure undo_add_column
as
begin
	alter table FestCountry
	drop column pic
	select* from FestCountry
	print 'Done undo add column. '

	update Version set versionNo = 1 where versionID = (select max(versionID) from Version)
end


-- DO 3. Add a default constraint
create procedure do_add_def_constraint
as
begin
	alter table Volunteer
	add constraint zero_exp default 0 for experience
	select* from Volunteer
	print 'Done do add default constraint.'

	update Version set versionNo = 3 where versionID = (select max(versionID) from Version)
end
-- UNDO 3.
create procedure undo_add_def_constraint
as
begin
	alter table Volunteer
	drop constraint zero_exp
	select* from Volunteer
	print 'Done undo add default constraint.'

	update Version set versionNo = 2 where versionID = (select max(versionID) from Version)
end

-- DO 4. Create primary key
create procedure do_create_pk
as
begin
	alter table Ticket
	add constraint pk_ticketID primary key (ticketID)
	select* from Ticket
	print 'Done do create pk. '

	update Version set versionNo = 4 where versionID = (select max(versionID) from Version)
end
-- UNDO 4.
create procedure undo_create_pk
as
begin
	alter table Ticket
	drop constraint pk_ticketID
	select* from Ticket
	print 'Done undo create pk. '

	update Version set versionNo = 3 where versionID = (select max(versionID) from Version)
end

-- DO 5. Create candidate key (unique)
create procedure do_create_uk
as
begin
	alter table Ticket
	add constraint uk_Ticket unique(CNP)
	select* from Ticket
	print 'Done do create candidate key. '

	update Version set versionNo = 5 where versionID = (select max(versionID) from Version)
end
-- UNDO 5.
create procedure undo_create_uk
as
begin
	alter table Ticket
	drop constraint uk_Ticket
	select* from Ticket
	print 'Done undo create uk. '

	update Version set versionNo = 4 where versionID = (select max(versionID) from Version)
end

-- DO 6. Create foreign key
create procedure do_create_fk
as
begin
	alter table Ticket
	add constraint fk_Ticket_Festival foreign key(festivalID) references Festival(festivalID)
	select* from Ticket
	print 'Done do create fk. '

	update Version set versionNo = 6 where versionID = (select max(versionID) from Version)
end
-- UNDO 6.
create procedure undo_create_fk
as
begin
	alter table Ticket
	drop constraint fk_Ticket_Festival
	select* from Ticket
	print 'Done undo create fk. '

	update Version set versionNo = 5 where versionID = (select max(versionID) from Version)
end

-- DO 7. Create new table
create procedure do_create_table
as
begin
	create table SafetyTeam(workerID int primary key identity(1, 1), workers int);
	print 'Done do create table. '

	update Version set versionNo = 7 where versionID = (select max(versionID) from Version)
end
-- UNDO 7.
create procedure undo_create_table
as
begin
	drop table SafetyTeam
	print 'Done undo create table. '

	update Version set versionNo = 6 where versionID = (select max(versionID) from Version)
end



-- MAIN
create procedure main
@version int
as
begin
	if @version > 7 or @version < 0
	begin
		print 'Version needs do be > 0 and <= 7! '
	end
	else
	begin
		declare @current_version int
		set @current_version = (select max(versionNo) from Version)
		if @current_version < @version
		begin
			while @current_version < @version
			begin
				if @current_version = 0
				begin
					exec do_modify_type_column
					set @current_version = 1
				end
				else if @current_version = 1
				begin
					exec do_add_column
					set @current_version = 2
				end
				else if @current_version = 2
				begin
					exec do_add_def_constraint
					set @current_version = 3
				end
				else if @current_version = 3
				begin
					exec do_create_pk
					set @current_version = 4
				end
				else if @current_version = 4
				begin
					exec do_create_uk
					set @current_version = 5
				end
				else if @current_version = 5
				begin
					exec do_create_fk
					set @current_version = 6
				end
				else if @current_version = 6
				begin
					exec do_create_table
					set @current_version = 7
				end
			end
		end
		else if @current_version > @version
		begin
			while @current_version > @version
			begin
				if @current_version = 7
				begin
					exec undo_create_table
					set @current_version = 6
				end
				else if @current_version = 6
				begin
					exec undo_create_fk
					set @current_version = 5
				end
				else if @current_version = 5
				begin
					exec undo_create_uk
					set @current_version = 4
				end
				else if @current_version = 4
				begin
					exec undo_create_pk
					set @current_version = 3
				end
				else if @current_version = 3
				begin
					exec undo_add_def_constraint
					set @current_version = 2
				end
				else if @current_version = 2
				begin
					exec undo_add_column
					set @current_version = 1
				end
				else if @current_version = 1
				begin
					exec undo_modify_type_column
					set @current_version = 0
				end
			end
		end
		else if @current_version = @version
		begin
			print 'This version is the current one. '
		end
	end
end

exec main 1

select* from Version
select* from MyList
select* from FestCountry



/*
Zadanie 1.

1.1 przygotowaæ SQL script script_1.sql, we którym tworz¹ siê bazê danych edu_courses, 
tabele oraz relacjê miêdzy nimi zgodnie z podanym modelem danych
*/

--create database edu_courses

--create table courses (
--	course_id int identity(1, 1) primary key,
--	course_name nvarchar(100),
--	base_prise money,
--	planned_groups_amount int default 1,
--	date_start date,
--	date_end date,
--	is_active bit default 1
--)

--create table users_user (
--	user_id int identity(1, 1) primary key,
--	email nvarchar(255),
--	first_name nvarchar(200),
--	last_name nvarchar(200),
--	is_actve bit,
--	age int
--)

--create table groups (
--	group_id integer  identity(1, 1) primary key,
--	group_type nvarchar(25) default 'zajêciowa',
--	course_id integer,
--	max_group_capacity integer,

--	constraint "FK_course_id_groups" foreign key (
--		course_id 
--	) references courses (
--		course_id
--	)

--)

--create table course_enrollment (
--	user_id integer,
--	group_id integer,
--	enrollment_date datetime,
--	total_cost money,
--	discount_type varchar(100) default 'bezwarunkowy',
--	discount_value money,
--	is_completed bit default 0,
--	is_dropped bit default 0
--	constraint "FK_user_id_course_enrollment" foreign key (
--		user_id
--	) references users_user (
--		user_id
--	),

--	constraint "FK_group_id_course_enrollment" foreign key (
--		group_id
--	) references groups (
--		group_id
--	)
--)

--create table group_timetable (
--	group_id integer,
--	room nvarchar(10),
--	datetime_start datetime,
--	datetime_end datetime,

--	constraint "FK_group_id_timetable" foreign key (
--		group_id
--	) references groups(
--		group_id
--	)
--)

/*
1.2 przygotowaæ SQL script script_2.sql, we którym zostan¹
a. dodana kolumna: phone_number (varchar(25)) do tabeli users_user
b. usuniêta kolumna age
c. dodane sprawdzenie tego ¿e date_start bêdzie zawsze mniejsz¹ dat¹ ni¿ date_end w tabeli
course*/

-- --a
--alter table users_user 
--add  phone_number varchar(25)

-- -- b
--alter table users_user
--drop column age

-- -- c
--alter table courses
--add constraint "poprawnosc_dat_courses" 
--	check (date_start < date_end)

/*
1.3 
przygotowaæ SQL script script_3.sql, we którym zostan¹ 
wstawiane przynajmniej 3 rekordy do
ka¿dej z tabel w modelu. Dane musz¹ byæ sensowne!
*/

--insert into courses (course_name, base_prise, date_start, date_end) 
--values 
--	('moj kurs gotowania', 100, '2020-01-01', '2021-01-01'),
--	('moj kurs gotowania2', 100, '2022-01-01', '2029-01-01'),
--	('moj kurs gotowania3', 100, '2030-01-01', '2040-01-01')

--insert into groups (course_id, max_group_capacity)
--values 
--	(1, 300),
--	(2, 4500),
--	(3, 2137)

--insert into users_user (email, first_name, last_name, is_actve)
--values 
--	('1@gmail.com', 'user_name1', 'user_name1', 1),
--	('2@gmail.com', 'user_name2', 'user_name2', 1),
--	('3@gmail.com', 'user_name3', 'user_name3', 1)

--insert into course_enrollment 
--	(user_id, group_id, enrollment_date, total_cost, discount_value)
--values
--	(1, 1, '2020-01-01', 420, 0),
--	(2, 2, '2020-02-01', 4220, 0),
--	(3, 3, '2022-01-01', 4330, 0)


--insert into group_timetable
--	(group_id, room, datetime_start, datetime_end)
--values 
--	(1, '1', '2020-01-01', '2021-01-01'),
--	(2, '2', '2022-01-01', '2023-01-01'),
--	(3, '3', '2020-03-01', '2021-04-01')

/*
Zadanie 2

 Task 2 (5 punktów )
Proszê przygotowaæ kod implementuj¹cy indeksy dla nastêpuj¹cych wymagañ (pamiêtajcie o okreœleniu
klucza indeksowania, unikalnoœci)

1. Czêste ³¹czenie tabel users_user i course_enrollment .
2. Unikalnoœæ email.
3. Czêste wyszukiwanie danych wed³ug daty rozpoczêcia i zakoñczenia kursu.
4. Z³o¿ony zgrupowany indeks w tabeli course_enrollment.
5. Filtracja userów wed³ug imienia i nazwiska.

*/

-- 1
--create nonclustered index user_id_users 
--on users_user (user_id)

--create nonclustered index user_id_course_enrollents 
--on course_enrollment (user_id)

-- 2
--create clustered unique index email_users
--on users_user (email)

--3
--create nonclustered index date_start
--on courses (date_start)

--create nonclustered index date_end
--on courses (date_end)

-- 4
--create clustered index course_enrollemnt_ci
--on course_enrollment (user_id, group_id)

-- 5
--create clustered index users_user_name_last_name
--on users_user (last_name, first_name)


/*
Zadanie 3.
*/

create procedure dodaj_uztkownika
	@email nvarchar(255),
	@course_id int
as 
begin

	if not exists(
		select *
		from users_user
		where email = @email
		)
		begin
			insert into users_user
				(email, is_actve)
			values
				(@email, 1)
		end


	declare @is_active bit
	select @is_active = 
		is_actve 
		from users_user
		where email = @email

	if @is_active = 1
		begin
			select @is_active = 
				is_active
				from courses
				where course_id = @course_id
		end

	declare @number_of_people int
	declare @capacity int
	
	select @capacity = 
		sum(g.max_group_capacity)
		from course_enrollment c
		join groups g on c.group_id = g.group_id
		where course_id = @course_id

	select @number_of_people = 
		count(*)
		from course_enrollment c
		join groups g on g.group_id = c.group_id
		where g.course_id = @course_id

	if @is_active = 0
		begin 
			print 'Nieaktywny uzytkownik lub kurs'
		end
	else if @number_of_people >= @capacity
		begin
			print 'Brak miejsc'
		end
	else
		begin
			print 'Zaczynamy dzialac'
			declare @user_id int
			select @user_id = 
				user_id
				from users_user
				where email = @email

			declare @number_of_courses int
			select @number_of_courses = 
				count(*)
				from course_enrollment
				where user_id = @user_id

			declare @course_price money
			select @course_price = 
					base_prise
				from courses
				where @course_id = course_id

			declare @discount money

			set @discount = 
				case
					when @number_of_courses = 0 then 100
					when @number_of_courses = 1 then 0.05 * @course_price
					else (0.05+@number_of_courses/100)*@course_price
				end

			declare @typeOfDiscount nvarchar(10)
			set @typeOfDiscount = 
				case
					when @number_of_courses = 0 then 'bezwarunkowy'
					when @number_of_courses = 1 then 'sta³y'
					else 'lojalnoœciowy'
				end

			declare @first_avaiable_group int
			set @first_avaiable_group = (
				select top 1
					g.group_id
				from groups g
				join course_enrollment c on c.group_id = g.group_id
				group by g.group_id, g.max_group_capacity
				having count(*) < g.max_group_capacity
				)

			insert into course_enrollment 
				(user_id, group_id, enrollment_date, total_cost, discount_type, discount_value)
			values 
				(@user_id, @first_avaiable_group, GETDATE(), @course_price, @typeOfDiscount, @discount)


		end


end 

exec dodaj_uztkownika 'toja@gmail.com', 2
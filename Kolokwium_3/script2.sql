alter table users_user
add phone_number varchar(25)

alter table users_user
drop column age

alter table users_user
add bithdate date

alter table users_user
add constraint "IsAdult" 
check (datediff(year, bithdate, getdate()) >= 18)
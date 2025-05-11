/*
ZADANIE 1

Dodaj produkt Chocolade do wszystkich zam�wie� z�o�onych
przez klienta ALFKI, kt�re jeszcze nie zawieraj� tego produktu
*/

--declare @chocolade_id int
--set @chocolade_id = (select ProductID from Products where ProductName = 'Chocolade')

--declare @chololade_price money
--set @chololade_price = (select UnitPrice from Products where ProductID = @chocolade_id)

--insert into [Order Details] (OrderID, ProductID, UnitPrice,	Quantity, Discount)
--select OrderID, @chocolade_id, @chololade_price, 1, 0
--	from (
--		select *
--		from Orders
--		where CustomerID = 'ALFKI'
--	) o
--	where not exists (
--		select *
--		from [Order Details] od 
--		where od.ProductID = @chocolade_id and od.OrderID = o.OrderID
--	)

/*
ZADANIE 2

W sklepie Northwind obowi�zuje promocja: je�li warto�� zam�wienia przekroczy 500 USD, klient otrzymuje 10%
rabatu na wszystkie produkty w tym zam�wieniu. Jednak je�li produkt zostanie usuni�ty, a warto��
zam�wienia spadnie poni�ej 500 USD, rabat nale�y anulowa�
*/

--declare @product_id int = 25
--declare @order_id int = 10250
--declare @quantity float = 5.5
--declare @product_price money = 217.99
--declare @discount float = 0.1

--begin transaction
--	begin try
--		insert into [Order Details] (OrderID, ProductID, UnitPrice,	Quantity, Discount)
--		values (@order_id, @product_id, @product_price, @quantity, @discount)

--		commit transaction
--	end try

--	begin catch
--		rollback transaction;



--		throw;
--	end catch

--declare @order_value money = (select sum(Quantity * (1 - Discount) * UnitPrice) from [Order Details] where OrderID = @order_id)

--if @order_value >= 500
--	begin
--		update [Order Details]
--		set Discount = 0.1
--		where OrderID = @order_id
--	end

/*
ZADANIE 3

Przypisanie wszystkich zam�wie� nadzorowanych
przez pracownika nr 1 pracownikowi nr 4
*/

--update Orders
--set EmployeeID = 4
--where EmployeeID = 1

/*
ZADANIE 4

1. Dla wszystkich zam�wie� z�o�onych po 15/05/1997 dla
produktu Ikura nale�y zmniejszy� ilo��.
2. Ilo�� nale�y zmniejszy� o 20% i zaokr�gli� do najbli�szej
liczby ca�kowitej.*/--declare @product_id int--select @product_id = productID from Products where ProductName = 'Ikura'--begin transaction--	begin try--		with order_indices as (--			select OrderID--			from Orders--			where OrderDate > '1997-05-15'--		)--		update [Order Details]--		set Quantity = round(Quantity * 0.8, 0)--		where OrderID in (select * from order_indices) and ProductID = @product_id--		commit transaction--	end try--	begin catch--		rollback transaction;--		throw--	end catch/*ZADANIE 51. Znajd� identyfikator ostatniego zam�wienia z�o�onego przez
klienta ALFKI, kt�re nie obejmuje produktu Chocolade
2. Znajd� identyfikator produktu Chocolade
3. Dodaj Chocolade do listy produkt�w zam�wionych w ramach
tego zam�wienia, z ilo�ci� r�wn� 1*/--declare @chocolade_id int--select @chocolade_id = ProductID from Products where ProductName = 'Chocolade';--declare @last_order_without_chocolade int;--with chocolade_orders as (--		select distinct--			OrderID--		from [Order Details]--		where ProductID = @chocolade_id--	)--select top 1 @last_order_without_chocolade = OrderID--	from Orders--	where CustomerID = 'ALFKI' and OrderID not in (select * from chocolade_orders)--	order by OrderDate desc--declare @chocolade_price money--select @chocolade_price = UnitPrice from Products where ProductID = @chocolade_id--begin transaction--	begin try--		insert into [Order Details] (OrderID, ProductID, UnitPrice,	Quantity, Discount)--		values (@last_order_without_chocolade, @chocolade_id, @chocolade_id, 1, 0)--		commit transaction--	end try--	begin catch--		rollback transaction;--		throw;--	end catch/*ZADANIE 6Usu� dane wszystkich kontrahent�w, kt�rzy nie z�o�yli
�adnych zam�wie�*/--delete from Customers--where not exists (--	select *--	from Orders o--	where o.CustomerID = CustomerID--)/*Zadanie 7Prosz� wykona� nast�puj�c� sekwencj� operacji (planuj�c wcze�niej
granice transakcji i dodaj�c w odpowiednich punktach u�ycie polece�
BEGIN TRANSACTION, COMMIT i ROLLBACK):
1. Sprawdzenie ��cznej ilo�ci zam�wionego produktu Chocolade w roku
1997
2. Dodanie nowego produktu o nazwie �Programming in Java� do
tabeli produkt�w
3. Zwi�kszenie ilo�ci zam�wionego produktu Chocolade w
zam�wieniach z roku 1997
4. ��czne zatwierdzenie zmian wprowadzonych w punkcie 2 i 3
5. Sprawdzenie ��cznej ilo�ci zam�wionego produktu Chocolade w roku
1997*/--begin transaction--	begin try--		declare @chocolade_id int--		select @chocolade_id = ProductID from Products where ProductName = 'Chocolade'--		-- etap 1--		declare @ilosc int--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--		-- etap 2--		insert into Products (ProductName,SupplierID,CategoryID,UnitPrice)--		values ('Programming in Java', 1, 1, 100)--		-- etap 3--		update [Order Details] --		set Quantity = Quantity + 1--		where ProductID = @chocolade_id and exists (--			select *--			from Orders o--			where o.OrderID = OrderID and year(OrderDate) = 1997--		)--		commit transaction--		-- etap 4--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--	end try--	begin catch--		rollback transaction;--		throw;--	end catch/*ZADANIE 8Prosz� wykona� nast�puj�c� sekwencj� operacji (planuj�c wcze�niej
granice transakcji i dodaj�c w odpowiednich punktach u�ycie polece�
BEGIN TRANSACTION, COMMIT i ROLLBACK):
1. Sprawdzenie ��cznej zam�wionej ilo�ci produktu Chocolade w roku
1997
2. Dwukrotne zwi�kszenie ilo�ci produktu Chocolade w zam�wieniach
z�o�onych w roku 1997
3. Sprawdzenie ��cznej zam�wionej ilo�ci w/w produktu w roku 1997
4. Rezygnacja ze zmiany wprowadzonej w punkcie 2
5. Sprawdzenie ��cznej zam�wionej ilo�ci w/w produktu w roku 1997
*/
--begin transaction--	begin try--		declare @chocolade_id int--		select @chocolade_id = ProductID from Products where ProductName = 'Chocolade'--		-- etap 1--		declare @ilosc int--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--		-- etap 2--		update [Order Details] --		set Quantity = Quantity * 2--		where ProductID = @chocolade_id and exists (--			select *--			from Orders o--			where o.OrderID = OrderID and year(OrderDate) = 1997--		)		--		-- etap 3--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--		-- etap 4--		rollback transaction--		-- etap 5--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--	end try--	begin catch--		rollback transaction;--		throw;--	end catch/*ZADANIE 9Wszystkie zam�wienia z�o�one przez klienta ALFKI zosta�y
anulowane. By informacj� t� odzwierciedli� w bazie danych,
prosz�:
� doda� now� kolumn� IsCancelled int do tabeli zam�wie�
� ustawi� warto�� tej kolumny:
� jako 0 dla ka�dego klienta z wyj�tkiem ALFKI
� jako 1 dla zam�wie� klienta ALFKI
� dodatkowo ustawi� ilo�� na 0 w ka�dym zam�wieniu
klienta ALFKI
*/


--alter table Orders add IsCancelled int;

--update Orders
--set IsCancelled  = 
--	case
--		when CustomerID = 'ALFKI' then 1
--		else 0
--	end


/*
ZADANIE 10

� System powinien zawiera� ceny zakupu poszczeg�lnych produkt�w. Mog�
one zmienia� si� z czasem.
� Ka�de zam�wienie powinno zawiera� jego ca�kowit� warto�� obliczon� na
podstawie jego zawarto�ci wymienionej w [Order Details]
� W zwi�zku z powy�szym, prosz�:

� utworzy� tabel� PriceList. Tabela powinna zawiera� osobn� cen�
zakupu dla poszczeg�lnych produkt�w dla ka�dego okresu, tj. kolumny
productId, price, date_from i date_to.
� ustawi� klucz obcy wskazuj�cy z PriceList na tabel� Products.
� dla cel�w testowych prosz� wstawi� inn� cen� za ka�dy rok obecny
w danych Orders
� doda� kolumn� TotalValue do tabeli Orders
� prosz� zaktualizowa� warto�� w tej kolumnie zapisuj�c do niej
ca�kowit� warto�� wszystkich zam�wionych produkt�w, korzystaj�c z
danych w tabeli PriceList.

*/

--create table "PriceList" (
--	"ProductID" "int" not null,
--	"date_from" "datetime" not null,
--	"date_to" "datetime" null,
--	constraint "FK_ProductID" foreign key (
--		"ProductID"
--	)
--	references Products (
--		"ProductID"
--	),
--	constraint "CK_dates_order" check (isnull(date_to, 1) > 0 or date_to > date_from)
--)

--update [Order Details]
--set UnitPrice =
--	case
--		when (select top 1 year(orderDate) from Orders o where o.OrderID = OrderID) = 1996 then UnitPrice
--		when (select top 1 year(orderDate) from Orders o where o.OrderID = OrderID) = 1997 then UnitPrice * 10
--		else 100 * UnitPrice
--	end

--alter table Orders add TotalValue money

--update Orders
--set TotalValue = (
--	select  
--		sum(Quantity * (1-Discount)*UnitPrice)
--	from [Order Details] od
--	where od.OrderID = OrderID
--	)


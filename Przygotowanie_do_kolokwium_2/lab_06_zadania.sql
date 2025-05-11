/*
ZADANIE 1

Dodaj produkt Chocolade do wszystkich zamówieñ z³o¿onych
przez klienta ALFKI, które jeszcze nie zawieraj¹ tego produktu
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

W sklepie Northwind obowi¹zuje promocja: jeœli wartoœæ zamówienia przekroczy 500 USD, klient otrzymuje 10%
rabatu na wszystkie produkty w tym zamówieniu. Jednak jeœli produkt zostanie usuniêty, a wartoœæ
zamówienia spadnie poni¿ej 500 USD, rabat nale¿y anulowaæ
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

Przypisanie wszystkich zamówieñ nadzorowanych
przez pracownika nr 1 pracownikowi nr 4
*/

--update Orders
--set EmployeeID = 4
--where EmployeeID = 1

/*
ZADANIE 4

1. Dla wszystkich zamówieñ z³o¿onych po 15/05/1997 dla
produktu Ikura nale¿y zmniejszyæ iloœæ.
2. Iloœæ nale¿y zmniejszyæ o 20% i zaokr¹gliæ do najbli¿szej
liczby ca³kowitej.*/--declare @product_id int--select @product_id = productID from Products where ProductName = 'Ikura'--begin transaction--	begin try--		with order_indices as (--			select OrderID--			from Orders--			where OrderDate > '1997-05-15'--		)--		update [Order Details]--		set Quantity = round(Quantity * 0.8, 0)--		where OrderID in (select * from order_indices) and ProductID = @product_id--		commit transaction--	end try--	begin catch--		rollback transaction;--		throw--	end catch/*ZADANIE 51. ZnajdŸ identyfikator ostatniego zamówienia z³o¿onego przez
klienta ALFKI, które nie obejmuje produktu Chocolade
2. ZnajdŸ identyfikator produktu Chocolade
3. Dodaj Chocolade do listy produktów zamówionych w ramach
tego zamówienia, z iloœci¹ równ¹ 1*/--declare @chocolade_id int--select @chocolade_id = ProductID from Products where ProductName = 'Chocolade';--declare @last_order_without_chocolade int;--with chocolade_orders as (--		select distinct--			OrderID--		from [Order Details]--		where ProductID = @chocolade_id--	)--select top 1 @last_order_without_chocolade = OrderID--	from Orders--	where CustomerID = 'ALFKI' and OrderID not in (select * from chocolade_orders)--	order by OrderDate desc--declare @chocolade_price money--select @chocolade_price = UnitPrice from Products where ProductID = @chocolade_id--begin transaction--	begin try--		insert into [Order Details] (OrderID, ProductID, UnitPrice,	Quantity, Discount)--		values (@last_order_without_chocolade, @chocolade_id, @chocolade_id, 1, 0)--		commit transaction--	end try--	begin catch--		rollback transaction;--		throw;--	end catch/*ZADANIE 6Usuñ dane wszystkich kontrahentów, którzy nie z³o¿yli
¿adnych zamówieñ*/--delete from Customers--where not exists (--	select *--	from Orders o--	where o.CustomerID = CustomerID--)/*Zadanie 7Proszê wykonaæ nastêpuj¹c¹ sekwencjê operacji (planuj¹c wczeœniej
granice transakcji i dodaj¹c w odpowiednich punktach u¿ycie poleceñ
BEGIN TRANSACTION, COMMIT i ROLLBACK):
1. Sprawdzenie ³¹cznej iloœci zamówionego produktu Chocolade w roku
1997
2. Dodanie nowego produktu o nazwie „Programming in Java” do
tabeli produktów
3. Zwiêkszenie iloœci zamówionego produktu Chocolade w
zamówieniach z roku 1997
4. £¹czne zatwierdzenie zmian wprowadzonych w punkcie 2 i 3
5. Sprawdzenie ³¹cznej iloœci zamówionego produktu Chocolade w roku
1997*/--begin transaction--	begin try--		declare @chocolade_id int--		select @chocolade_id = ProductID from Products where ProductName = 'Chocolade'--		-- etap 1--		declare @ilosc int--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--		-- etap 2--		insert into Products (ProductName,SupplierID,CategoryID,UnitPrice)--		values ('Programming in Java', 1, 1, 100)--		-- etap 3--		update [Order Details] --		set Quantity = Quantity + 1--		where ProductID = @chocolade_id and exists (--			select *--			from Orders o--			where o.OrderID = OrderID and year(OrderDate) = 1997--		)--		commit transaction--		-- etap 4--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--	end try--	begin catch--		rollback transaction;--		throw;--	end catch/*ZADANIE 8Proszê wykonaæ nastêpuj¹c¹ sekwencjê operacji (planuj¹c wczeœniej
granice transakcji i dodaj¹c w odpowiednich punktach u¿ycie poleceñ
BEGIN TRANSACTION, COMMIT i ROLLBACK):
1. Sprawdzenie ³¹cznej zamówionej iloœci produktu Chocolade w roku
1997
2. Dwukrotne zwiêkszenie iloœci produktu Chocolade w zamówieniach
z³o¿onych w roku 1997
3. Sprawdzenie ³¹cznej zamówionej iloœci w/w produktu w roku 1997
4. Rezygnacja ze zmiany wprowadzonej w punkcie 2
5. Sprawdzenie ³¹cznej zamówionej iloœci w/w produktu w roku 1997
*/
--begin transaction--	begin try--		declare @chocolade_id int--		select @chocolade_id = ProductID from Products where ProductName = 'Chocolade'--		-- etap 1--		declare @ilosc int--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--		-- etap 2--		update [Order Details] --		set Quantity = Quantity * 2--		where ProductID = @chocolade_id and exists (--			select *--			from Orders o--			where o.OrderID = OrderID and year(OrderDate) = 1997--		)		--		-- etap 3--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--		-- etap 4--		rollback transaction--		-- etap 5--		select @ilosc = sum(od.Quantity) --			from (--				select *--				from Orders--				where year(OrderDate) = 1997--			) o--			join (--				select *--				from [Order Details] od--				where od.ProductID = @chocolade_id--				) od on od.OrderID = o.OrderID--		print @ilosc--	end try--	begin catch--		rollback transaction;--		throw;--	end catch/*ZADANIE 9Wszystkie zamówienia z³o¿one przez klienta ALFKI zosta³y
anulowane. By informacjê t¹ odzwierciedliæ w bazie danych,
proszê:
• dodaæ now¹ kolumnê IsCancelled int do tabeli zamówieñ
• ustawiæ wartoœæ tej kolumny:
• jako 0 dla ka¿dego klienta z wyj¹tkiem ALFKI
• jako 1 dla zamówieñ klienta ALFKI
• dodatkowo ustawiæ iloœæ na 0 w ka¿dym zamówieniu
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

• System powinien zawieraæ ceny zakupu poszczególnych produktów. Mog¹
one zmieniaæ siê z czasem.
• Ka¿de zamówienie powinno zawieraæ jego ca³kowit¹ wartoœæ obliczon¹ na
podstawie jego zawartoœci wymienionej w [Order Details]
• W zwi¹zku z powy¿szym, proszê:

• utworzyæ tabelê PriceList. Tabela powinna zawieraæ osobn¹ cenê
zakupu dla poszczególnych produktów dla ka¿dego okresu, tj. kolumny
productId, price, date_from i date_to.
• ustawiæ klucz obcy wskazuj¹cy z PriceList na tabelê Products.
• dla celów testowych proszê wstawiæ inn¹ cenê za ka¿dy rok obecny
w danych Orders
• dodaæ kolumnê TotalValue do tabeli Orders
• proszê zaktualizowaæ wartoœæ w tej kolumnie zapisuj¹c do niej
ca³kowit¹ wartoœæ wszystkich zamówionych produktów, korzystaj¹c z
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


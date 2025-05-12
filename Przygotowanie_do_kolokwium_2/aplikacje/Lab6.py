from db_connection import cnx_mssql

class Lab6(object):

    def __init__(self):
        self.cursor = cnx_mssql.cursor()

    def task_1(self):
        # tables = "SELECT * FROM INFORMATION_SCHEMA.TABLES"
        columns = "SELECT TABLE_NAME AS [Table name],\
                   COLUMN_NAME AS [Column name],\
                   DATA_TYPE AS [Data type],\
                   IS_NULLABLE AS [NULL]\
                   FROM INFORMATION_SCHEMA.COLUMNS\
                   WHERE table_name='Orders'"
        with open('Lab 6, task 1.txt', 'w') as out:
            line = 'Lab 6, task 1'
            out.write(line + '\n')
            print(line)

            line = 'Before modification'
            out.write(line + '\n')
            print(line)

            qwery_1 = "SELECT count(OrderID) FROM Orders WHERE EmployeeID = 4"
            self.cursor.execute(qwery_1)
            rows = self.cursor.fetchall()
            for rec in rows:
                rec_0 = ''.join(i for i in str(rec) if i.isdigit())
                line = 'Employee 4 had ', rec_0, ' orders'
                out.write(line + '\n')
                print(line)

            qwery_2 = "SELECT count(OrderID) FROM Orders WHERE EmployeeID = 1"
            self.cursor.execute(qwery_2)
            rows = self.cursor.fetchall()
            for rec in rows:
                rec_0 = ''.join(i for i in str(rec) if i.isdigit())
                line = 'Employee 1 had ', rec_0, ' orders'
                out.write(line + '\n')
                print(line)

            qwery_3 = "UPDATE Orders SET EmployeeID=4 WHERE EmployeeID=1"
            out.write(qwery_3 + '\n')
            print(qwery_3)
            self.cursor.execute(qwery_3)

            print('After modification')
            qwery_4 = "SELECT count(OrderID) FROM Orders WHERE EmployeeID = 4"
            self.cursor.execute(qwery_4)
            rows = self.cursor.fetchall()
            for rec in rows:
                rec_0 = ''.join(i for i in str(rec) if i.isdigit())
                line = 'Employee 4 has ', rec_0, ' orders'
                out.write(line + '\n')
                print(line)

            qwery_5 = "SELECT count(OrderID) FROM Orders WHERE EmployeeID = 1"
            self.cursor.execute(qwery_5)
            rows = self.cursor.fetchall()
            for rec in rows:
                rec_0 = ''.join(i for i in str(rec) if i.isdigit())
                line = 'Employee 1 has ', rec_0, ' orders'
                out.write(line + '\n')
                print(line)


    def task_2(self):
        with open('Lab 6, task 2.txt', 'w') as out:
            line = 'Lab 6, task 2'
            out.write(line + '\n')
            print(line)

            line = 'Before modification'
            out.write(line + '\n')
            print(line)

            # qwery_1 = "UPDATE [Order details] SET Quantity = Ceiling(Quantity * 0.8) WHERE exists \
            #           (SELECT * FROM Orders o  \
            #           JOIN [Order details] od ON o.OrderID=od.OrderID\
            #           WHERE ProductID=(SELECT ProductID FROM Products WHERE ProductName = 'Ikura') \
            #           and OrderDate > cast('1997-05-15' AS datetime)) \
            #           and ProductID=(SELECT ProductID FROM Products WHERE ProductName = 'Ikura'))"
            qwery_1 = "SELECT * FROM products"
                                  # and ProductID=(SELECT ProductID FROM Products WHERE ProductName = 'Ikura')"
            self.cursor.execute(qwery_1)
            rows = self.cursor.fetchall()
            for rec in rows:
                line = rec
                out.write(str(line) + '\n')
                print(line)

            # qwery_2 = "SELECT count(OrderID) FROM Orders WHERE EmployeeID = 1"
            # self.cursor.execute(qwery_2)
            # rows = self.cursor.fetchall()
            # for rec in rows:
            #     rec_0 = ''.join(i for i in str(rec) if i.isdigit())
            #     line = 'Employee 1 had ', rec_0, ' orders'
            #     out.write(line + '\n')
            #     print(line)
            #
            # qwery_3 = "UPDATE Orders SET EmployeeID=4 WHERE EmployeeID=1"
            # out.write(qwery_3 + '\n')
            # print(qwery_3)
            # self.cursor.execute(qwery_3)
            #
            # print('After modification')
            # qwery_4 = "SELECT count(OrderID) FROM Orders WHERE EmployeeID = 4"
            # self.cursor.execute(qwery_4)
            # rows = self.cursor.fetchall()
            # for rec in rows:
            #     rec_0 = ''.join(i for i in str(rec) if i.isdigit())
            #     line = 'Employee 4 has ', rec_0, ' orders'
            #     out.write(line + '\n')
            #     print(line)
            #
            # qwery_5 = "SELECT count(OrderID) FROM Orders WHERE EmployeeID = 1"
            # self.cursor.execute(qwery_5)
            # rows = self.cursor.fetchall()
            # for rec in rows:
            #     rec_0 = ''.join(i for i in str(rec) if i.isdigit())
            #     line = 'Employee 1 has ', rec_0, ' orders'
            #     out.write(line + '\n')
            #     print(line)

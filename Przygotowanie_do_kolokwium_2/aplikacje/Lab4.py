from db_connection import cnx_mssql

class Lab4(object):

    def __init__(self):
        self.cursor = cnx_mssql.cursor()

    def task_1(self):
        print('Task 1')
        qwery_1 = "SELECT TOP 10 * FROM orders"
        self.cursor.execute(qwery_1)
        rows = self.cursor.fetchall()
        for rec in rows:
            print(rec)

    def task_2(self):
        print('Task 2')
        qwery_1 = "SELECT TOP 10 * FROM products"
        self.cursor.execute(qwery_1)
        rows = self.cursor.fetchall()
        for rec in rows:
            print(rec)

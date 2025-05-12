import configparser
import pyodbc

# parse config
cnf = configparser.ConfigParser()
cnf.read('cnf.ini')


server = cnf['mssqlDB']['server']
database = cnf['mssqlDB']['db']
driver = cnf['mssqlDB']['driver']

conn_str = (
    f'DRIVER={{{driver}}};'
    f'SERVER={server};'
    f'DATABASE={database};'
    f'Trusted_Connection=yes;'
)

try:
    cnx_mssql = pyodbc.connect(conn_str, timeout=5)
except pyodbc.Error as e:
    print("Błąd podczas łączenia z bazą danych:")
    print(e)
    print("Szczegóły:")
    for arg in e.args:
        print(arg)

from Lab4 import *
from Lab6 import *
from Scenarios import *
from kolokwium_przykladowe import *

class Perform_The_Task(object):
    def Perform_The_lab_4_1(self):
        result = Lab4()
        result.task_1()

    def Perform_The_lab_4_2(self):
        result = Lab4()
        result.task_2()

    def Perform_The_lab_6_1(self):
        result = Lab6()
        result.task_1()

    def Perform_The_lab_6_2(self):
        result = Lab6()
        result.task_2()

    def perform_scenario_01(self):
        result = Scenarios()
        result.perform_scenario_01()

    def perform_scenario_02(self):
        result = Scenarios()
        result.perform_scenario_02()



if __name__ == '__main__':
    kolokwium_przykladowe().task_02()
    cnx_mssql.commit()
    cnx_mssql.close()

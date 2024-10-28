# Part 1
## Use a DataFrame in Python to define the following queries using the Employee data
## ==========================================================================================================

# Import library
import pandas as pd


# Define column names
column_names = ["First Name", "Middle Name", "Last Name", "Employee ID", 
                "Birth Date", "Address", "City", "State", 
                "Gender", "Salary", "Supervisor ID", "Department"]

# Load the dataset
employee = pd.read_csv("C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 8\\Data File\\employee.txt", names = column_names)


# Part 1-a
## Find all male employees
## ==========================================================================================================

male_employees = employee[employee["Gender"] == "M"]
print("Male Employees:")
print(male_employees)
print()


# Part 1-b
## Find the highest salary for female employees
## ==========================================================================================================

highest_female_employees_salary = employee[employee["Gender"] == "F"]["Salary"].max()
print(f"The highest salary for female employees is {highest_female_employees_salary}")
print()


# Part 1-c
## Print out salary groups grouped by middle initial
## ==========================================================================================================

salary_groups = employee.groupby("Middle Name")["Salary"].apply(list)
print("Salary Groups by Middle Name:")
print(salary_groups)
print()

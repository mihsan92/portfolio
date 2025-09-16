import csv

class StudentManagement:
    def __init__(self, file_name):
        self.file_name = file_name
        self.create_students_file(file_name)

    def create_students_file(self, file_name):
        try:
            with open(file_name + '.csv', 'x', newline='') as file:
                csv_writer = csv.writer(file)
                csv_writer.writerow(['ID','First Name', 'Last Name', 'Age'])
        except FileExistsError:
            pass
    
    def add_student(self, first_name, last_name, age):
        id = self.get_row_count() + 1  # get_row_count gets number of student rows. Adding 1 to get ID for new row
        with open(self.file_name + '.csv', 'a', newline='') as file:
            csv_add = csv.writer(file)
            csv_add.writerow([id, first_name, last_name, age])

    def get_row_count(self):
        with open(self.file_name + '.csv', 'r') as file:
            reader = csv.reader(file)
            row_count = len(list(reader)) - 1  # total rows minus header 
            return row_count

s = StudentManagement('students')

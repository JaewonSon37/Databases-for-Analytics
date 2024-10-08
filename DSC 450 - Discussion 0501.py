student_database = {"student_table": [{"StudentID": 1, "Name": "Jack", "Level": "UGrad"},
                                      {"StudentID": 2, "Name": "Janine", "Level": "Grad"},
                                      {"StudentID": 3, "Name": "Jaine", "Level": "UGrad"},
                                      {"StudentID": 4, "Name": "Karen", "Level": "Grad"}],
                    "enrollment_table": [{"StudentID": 1, "CourseID": 100},
                                         {"StudentID": 3, "CourseID": 300},
                                         {"StudentID": 2, "CourseID": 300},
                                         {"StudentID": 4, "CourseID": 100}],
                    "courses_table": [{"CourseID": 100, "CourseName": "Introduction to Databases", "Credits": 4},
                                      {"CourseID": 300, "CourseName": "Research Colloquium", "Credits": 2}]}

# Find the 'StudentID'
karen_student_id = None
for student in student_database["student_table"]:
    if student["Name"] == "Karen":
        karen_student_id = student["StudentID"]

# Find the 'CourseID'
karen_course_id = []
for enrollment in student_database["enrollment_table"]:
    if enrollment["StudentID"] == karen_student_id:
        karen_course_id.append(enrollment["CourseID"])

# Find the 'CourseName'
karen_course_name = []
for course in student_database["courses_table"]:
    if course["CourseID"] in karen_course_id:
        karen_course_name.append(course["CourseName"])

print()
print(f"Course ID taken by Karen: {karen_course_id}")
print(f"Course Name taken by Karen: {karen_course_name}")

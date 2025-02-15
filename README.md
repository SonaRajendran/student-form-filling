# Student Data Entry Form

This code includes three screens: a splash screen, a student data entry screen, and a student details screen. It also handles form validation, data storage using shared_preferences, and basic search functionality.


## The app consists of three main screens:

Splash Screen (main.dart) - Shows a logo and navigates to the entry screen
Student Entry Screen (student_entry.dart) - Form for capturing student details and marks
Student Details Screen (student_details.dart) - Displays and searches student records

## Key Features:

Data persistence using SharedPreferences
Input validation for email, phone, and marks
Location selection with district, taluk, and village dropdowns
Search functionality for student records
Detailed student information display

# The main.dart file shows this is a Flutter app with:
A splash screen that displays for 3 seconds
Navigation to a StudentEntryScreen after the splash
Uses a welcoming logo from assets
Has a blue theme

# The student_entry.dart file reveals this is a student data entry form with:
Input fields for student personal details (name, email, phone)
Location selection with district, taluk, and village dropdowns
Marks input for 5 subjects (Maths, Science, Social, English, Tamil)
Data validation for email, phone, and marks
Data storage using SharedPreferences
Navigation to StudentDetailsScreen after submission

# The student_details.dart file completes the app's functionality by:
Displaying a list of all submitted student records
Providing search functionality by name, roll number, phone, or acknowledgment number
Showing detailed student information in a dialog
Displaying marks and status for each subject
Using SharedPreferences to persist and retrieve student data

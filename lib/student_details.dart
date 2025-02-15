import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDetailsScreen extends StatefulWidget {
  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _filteredStudents = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final students = prefs.getStringList('students') ?? [];
    setState(() {
      _students = students.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
      _filteredStudents = _students;
    });
  }

  void _searchStudents(String query) {
    setState(() {
      _filteredStudents = _students.where((student) {
        return student['name'].toLowerCase().contains(query.toLowerCase()) ||
            student['rollNumber'].toLowerCase().contains(query.toLowerCase()) ||
            student['phone'].toLowerCase().contains(query.toLowerCase()) ||
            student['acknowledgementNumber'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _showStudentDetails(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Student Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name: ${student['name']}'),
                Text('Email: ${student['email']}'),
                Text('Phone: ${student['phone']}'),
                Text('Acknowledgment Number: ${student['acknowledgementNumber']}'),
                Text('Total Marks: ${student['totalMarks']}'),
                Text('Average Marks: ${student['averageMarks']}'),
                ...List.generate(student['subjectNames'].length, (index) {
  return Text('${student['subjectNames'][index]}: '
             '${student['subjectMarks'][index]} '
             '(${student['subjectStatus'][index]})');
}),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchStudents,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name, roll no, phone or ack no',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    title: Text(student['name']),
                    subtitle: Text('Roll No: ${student['rollNumber']}'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      _showStudentDetails(student);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form/student_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentEntryScreen extends StatefulWidget {
  @override
  _StudentEntryScreenState createState() => _StudentEntryScreenState();
}

class _StudentEntryScreenState extends State<StudentEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _talukController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  String name = '';
  String email = '';
  String phone = '';
  String district = '';
  String taluk = '';
  String village = '';
  List<int> subjectMarks = List.filled(5, 0);
  String acknowledgementNumber = '';
   final List<String> subjectNames = ['Maths', 'Science', 'Social', 'English', 'Tamil'];

  List<String> subjectStatus = List.filled(5, '');
  
    
@override
void dispose() {
  _districtController.dispose();
  _talukController.dispose();
  _villageController.dispose();
  super.dispose();
}

  // Districts, Taluks, and Villages Data
  
  final List<String> districts = [
  'Ariyalur',
  'Chengalpattu',
  'Chennai',
  'Coimbatore',
  'Cuddalore',
  'Dharmapuri',
  'Dindigul',
  'Erode',
  'Kallakurichi',
  'Kanchipuram',
  'Kanyakumari',
  'Karur',
  'Krishnagiri',
  'Madurai',
  'Nagapattinam',
  'Namakkal',
  'Nilgiris',
  'Perambalur',
  'Pudukkottai',
  'Ramanathapuram',
  'Ranipet',
  'Salem',
  'Sivaganga',
  'Tenkasi',
  'Thanjavur',
  'Theni',
  'Thoothukudi',
  'Tiruchirappalli', // Added Tiruchirappalli
  'Tirunelveli',
  'Tirupathur',
  'Tiruppur',
  'Tiruvallur',
  'Tiruvannamalai',
  'Tiruvarur',
  'Vellore',
  'Viluppuram',
  'Virudhunagar'
];
  final List<String> taluks =["Mylapore", "Pollachi ", "Madurai North","Kumbakonam","Srirangam","Kanchipuram","Yercaud","Ambasamudram","Bhavani","Dindigul", 'Tiruchirappalli',
    'Manachanallur',
    'Manapparai',
    'Marungapuri',
    'Musiri',
    'Srirangam',
    'Thottiyam',
    'Thuraiyur',
    'Vaiyampatti'];
  final List<String> villages = ["Mylapore", "Triplicane", "Royapettah","Alwarpet",'Mandaveli','Anamalai','Kinathukadavu','Negamam','Negamam','Zamin Uthukuli','Alanganallur','Koodal Nagar','Darasuram','Nachiyar Koil','Uppiliappan Koil','Manachanallur','Manamedu','Mutharasanallur','Thiruvanaikoil','Woraiyur','Musiri','Enathur','Orikkai','Thirupachur','Nagaloor','Vellakadai','Karaiyar','Papanasam',    'Agraharam',
    'Anbil',
    'Bikshandarkoil',
    'Golden Rock',
    'Kattur',
    'Konnakudipatti',
    'Kottapattu',
    'Lalgudi',
    'Manikandam',
    'Ponmalai',
    'Srirangam',
    'Thillainagar',
    'Thiruverumbur',
    'Woraiyur'];

String? selectedDistrict;
  String? selectedTaluk;
  String? selectedVillage;
// Add these in the build method, inside the Form widget





  // Suggestions
  List<String> filteredDistricts = [];
  List<String> filteredTaluks = [];
  List<String> filteredVillages = [];
  //Add subjects name
 
  void updateFilteredDistricts(String query) {
    setState(() {
      filteredDistricts = districts
          .where((district) => district.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void updateFilteredTaluks(String query) {
    setState(() {
      filteredTaluks = taluks
          .where((taluk) => taluk.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void updateFilteredVillages(String query) {
    setState(() {
      filteredVillages = villages
          .where((village) => village.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^\d{10}$').hasMatch(phone);
  }

  void submitData() async {
    if (_formKey.currentState?.validate() ?? false) {
      int totalMarks = subjectMarks.reduce((a, b) => a + b);
      double averageMarks = totalMarks / subjectMarks.length;
      acknowledgementNumber = 'ACK${DateTime.now().millisecondsSinceEpoch}';

      for (int i = 0; i < subjectMarks.length; i++) {
        subjectStatus[i] = subjectMarks[i] < 35 ? 'Fail' : 'Pass';
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
     // Create student data map
    Map<String, dynamic> studentData = {
      'name': name,
      'email': email,
      'phone': phone,
      'district': selectedDistrict,
      'taluk': selectedTaluk,
      'village': selectedVillage,
      'acknowledgementNumber': acknowledgementNumber,
      'totalMarks': totalMarks,
      'averageMarks': averageMarks,
      'subjectStatus': subjectStatus,
      'subjectMarks': subjectMarks,
      'subjectNames': subjectNames,
      'rollNumber': 'ROLL${DateTime.now().millisecondsSinceEpoch}' // Add roll number
    };

    // Get existing students
    List<String> students = prefs.getStringList('students') ?? [];
    
    // Add new student
    students.add(jsonEncode(studentData));
    
    // Save updated list
    await prefs.setStringList('students', students);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StudentDetailsScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Data Entry')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                  onChanged: (value) => name = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => isValidEmail(value!) ? null : 'Enter a valid email',
                  onChanged: (value) => email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) => isValidPhone(value!) ? null : 'Enter a valid phone number',
                  onChanged: (value) => phone = value,
                ),
                // District Input
                TextField(
                  decoration: InputDecoration(labelText: 'District'),
                  onChanged: updateFilteredDistricts,
                  controller: _districtController,
                  onTap: (){
                    _districtController.text=selectedDistrict!;
                  },
                ),
                TextField(
  decoration: InputDecoration(labelText: 'Taluk'),
  onChanged: updateFilteredTaluks,
  controller: _talukController,
  onTap: () {
    _talukController.text = selectedTaluk!;
  },
),

TextField(
  decoration: InputDecoration(labelText: 'Village'),
  onChanged: updateFilteredVillages,
  controller: _villageController,
  onTap: () {
    _villageController.text = selectedVillage!;
  },
),
                // Display District Suggestions
                if (filteredDistricts.isNotEmpty)
                  Container(
                    height: 100,
                    child: ListView.builder(
                      itemCount: filteredDistricts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredDistricts[index]),
                          onTap: () {
                            setState(() {
                              selectedDistrict = filteredDistricts[index];
                              filteredDistricts.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
                
                // Display Taluk Suggestions
                if (filteredTaluks.isNotEmpty)
                  Container(
                    height: 100,
                    child: ListView.builder(
                      itemCount: filteredTaluks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredTaluks[index]),
                          onTap: () {
                            setState(() {
                              selectedTaluk = filteredTaluks[index];
                              filteredTaluks.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
               
                // Display Village Suggestions
                if (filteredVillages.isNotEmpty)
                  Container(
                    height: 100,
                    child: ListView.builder(
                      itemCount: filteredVillages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredVillages[index]),
                          onTap: () {
                            setState(() {
                              selectedVillage = filteredVillages[index];
                              filteredVillages.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
                // Subject Marks Input
                for (int i = 0; i < 5; i++)
                  TextFormField(
                    decoration: InputDecoration(labelText: '${subjectNames[i]} Marks'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      int? mark = int.tryParse(value!);
                      if (mark == null || mark < 0 || mark > 100) {
                        return 'Enter a valid mark (0-100)';
                      }
                      subjectMarks[i] = mark;
                      return null;
                    },
                  ),
                  
                ElevatedButton(onPressed: submitData, child: Text('Submit')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

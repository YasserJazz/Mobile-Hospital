import 'dart:convert';
import 'package:Hos/admin/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientsList extends StatefulWidget {
  @override
  _PatientsListState createState() => _PatientsListState();
}

class Patient {
  final id;
  final name;
  final mobile;
  final email;
  final username;
  final password;

  Patient({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.username,
    this.password,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }
}

class _PatientsListState extends State<PatientsList> {
  Future<List<Patient>> fetchPatients() async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/patient/getAll.php",
        headers: {
          "Content-Type": "application/json",
          "Connection": "keep-alive"
        });

    if (response.statusCode == 200) {
      List<Patient> docList = List<Patient>();
      var data = jsonDecode(response.body);
      var records = data['records'] as List;

      for (var i = 0; i < records.length; i++) {
        docList.add(Patient.fromJson(records[i]));
      }
      return docList;
    } else {
      throw Exception(response.statusCode);
    }
  }

  String color = '#9ec9d0'.replaceAll('#', '0xff');

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/admin': (context) => AdminPage(),
        },
        home: Directionality(
            textDirection:
                arguments['ara'] ? TextDirection.rtl : TextDirection.ltr,
            child: Builder(
                builder: (context) => Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      centerTitle: true,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          tooltip: 'back Icon',
                          onPressed: () => {
                                Navigator.pushNamed(context, '/admin',
                                    arguments: {'ara': arguments['ara']}),
                              }),
                      backgroundColor: Color(int.parse(color)),
                      title: Text(
                          arguments['ara'] ? 'لائحة المرضى' : 'Patients List'),
                    ),
                    body: FutureBuilder(
                        future: fetchPatients(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: List.generate(
                                    snapshot.data.length,
                                    (index) => Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: ListTile(
                                          title: Text(snapshot.data[index].name
                                              .toString()),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data[index].email),
                                              Text(snapshot.data[index].mobile)
                                            ],
                                          ),
                                        ))),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return Center(child: CircularProgressIndicator());
                        })))));
  }
}

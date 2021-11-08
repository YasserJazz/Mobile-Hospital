import 'dart:convert';
import 'package:Hos/admin/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClinicsList extends StatefulWidget {
  @override
  _ClinicsListState createState() => _ClinicsListState();
}

class Clinic {
  final id;
  final name;
  final phone;
  final email;
  final username;
  final password;

  Clinic({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.username,
    this.password,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }
}

class _ClinicsListState extends State<ClinicsList> {
  Future<List<Clinic>> fetchClinics() async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/clinic/getAll.php",
        headers: {
          "Content-Type": "application/json",
          "Connection": "keep-alive"
        });

    if (response.statusCode == 200) {
      List<Clinic> docList = List<Clinic>();
      var data = jsonDecode(response.body);
      var records = data['records'] as List;

      for (var i = 0; i < records.length; i++) {
        docList.add(Clinic.fromJson(records[i]));
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
                          arguments['ara'] ? 'لائحة العيادات' : 'Clinics List'),
                    ),
                    body: FutureBuilder(
                        future: fetchClinics(),
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
                                              Text(snapshot.data[index].phone)
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

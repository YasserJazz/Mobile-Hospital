import 'package:Hos/appointment/patList.dart';
import 'package:Hos/patient/patientProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Data {
  final response;

  Data({
    this.response,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      response: json['response'],
    );
  }
}

class Clinic {
  int id;
  String name;

  Clinic({this.id, this.name});

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      name: json['name'],
    );
  }
}

class HosAppointment extends StatefulWidget {
  @override
  _HosAppointmentState createState() => _HosAppointmentState();
}

class _HosAppointmentState extends State<HosAppointment> {
  Future _getSelectedClinic;

  Future<List<Clinic>> fetchClinicLst() async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/clinic/getAll.php",
        headers: {
          "Content-Type": "application/json",
          "Connection": "keep-alive"
        });

    if (response.statusCode == 200) {
      List<Clinic> clinicList = List<Clinic>();
      var data = jsonDecode(response.body);
      var records = data['records'] as List;

      for (var i = 0; i < records.length; i++) {
        clinicList.add(Clinic(
            id: int.parse(records[i]['id'].toString()),
            name: records[i]['name']));
      }
      return clinicList;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Data> sendAppointment(
      int pat_id, int hos_id, int priority, String notes) async {
    String url =
        "https://sarhosproject.000webhostapp.com/appointment/ask.php?pat_id=" +
            pat_id.toString() +
            "&hos_id=" +
            hos_id.toString() +
            "&priority=" +
            priority.toString() +
            "&notes=" +
            notes;
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Connection": "keep-alive"
    });

    if (response.statusCode == 200) {
      return Data.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  String color = '#9ec9d0'.replaceAll('#', '0xff');
  Clinic selectedClinic;
  var priority = 1;

  Data thisData;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController notes = TextEditingController();
  Future<Data> futureData;

  @override
  void initState() {
    _getSelectedClinic = fetchClinicLst();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/pProfile': (context) => PatientProfile(),
          '/patList': (context) => AppointmentPatList()
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
                      onPressed: () =>
                          Navigator.pushNamed(context, '/pProfile', arguments: {
                        'id': arguments['id'],
                        'name': arguments['name'],
                        'username': arguments['username'],
                        'email': arguments['email'],
                        'password': arguments['password'],
                        'mobile': arguments['mobile'],
                        'address': arguments['address'],
                        'ara': arguments['ara']
                      }),
                    ),
                    backgroundColor: Color(int.parse(color)),
                    title: Text(
                        arguments['ara'] ? 'حجز موعد' : 'Make an Appointment'),
                  ),
                  body: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    arguments['ara']
                                        ? 'اختر عيادة:'
                                        : 'Choose Clinic:',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  FutureBuilder(
                                      future: _getSelectedClinic,
                                      builder: (context, snap) {
                                        if (!snap.hasData) {
                                          return Container(
                                              child: Center(
                                            child: CircularProgressIndicator(),
                                          ));
                                        }
                                        var response = snap.data;
                                        List<Clinic> clinics =
                                            response as List<Clinic>;
                                        return DropdownButton<Clinic>(
                                            hint: Text(arguments['ara']
                                                ? 'اختر عيادة'
                                                : 'Select a clinic'),
                                            value: selectedClinic,
                                            items: clinics.map((Clinic clinic) {
                                              return DropdownMenuItem<Clinic>(
                                                value: clinic,
                                                child: Text(clinic.name),
                                              );
                                            }).toList(),
                                            onChanged: (Clinic value) {
                                              setState(() {
                                                selectedClinic = value;
                                              });
                                            });
                                      })
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    arguments['ara']
                                        ? 'حالة الطلب'
                                        : 'Priority:',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton(
                                          value: priority,
                                          items: [
                                            DropdownMenuItem(
                                                child: Text(arguments['ara']
                                                    ? 'عادي'
                                                    : 'Normal'),
                                                value: 1),
                                            DropdownMenuItem(
                                                child: Text(arguments['ara']
                                                    ? 'طارئ'
                                                    : 'Urgent'),
                                                value: 2),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              priority = value;
                                            });
                                          })),
                                ]),
                            Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextFormField(
                                        controller: notes,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return arguments['ara']
                                                ? 'الرجاء كتابة ملاحظاتك'
                                                : 'Please enter your notes!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                            hintText: arguments['ara']
                                                ? 'الرجاء كتابة ملاحظاتك..'
                                                : 'Please write your notes..'),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          RaisedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                final Data data =
                                                    await sendAppointment(
                                                        int.parse(
                                                            arguments['id']),
                                                        selectedClinic.id,
                                                        priority,
                                                        notes.text);

                                                setState(() {
                                                  thisData = data;
                                                });

                                                if (thisData.response ==
                                                    "inserted") {
                                                  Navigator.pushNamed(
                                                      context, '/patList',
                                                      arguments: {
                                                        'id': arguments['id'],
                                                        'name':
                                                            arguments['name'],
                                                        'username': arguments[
                                                            'username'],
                                                        'email':
                                                            arguments['email'],
                                                        'password': arguments[
                                                            'password'],
                                                        'mobile':
                                                            arguments['mobile'],
                                                        'address': arguments[
                                                            'address'],
                                                        'ara': arguments['ara']
                                                      });
                                                }
                                              }
                                            },
                                            color: Color(int.parse(color)),
                                            child: Text(arguments['ara']
                                                ? 'إرسال إلى العيادة'
                                                : 'Send to Clinic'),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/patList',
                                                  arguments: {
                                                    'id': arguments['id'],
                                                    'name': arguments['name'],
                                                    'username':
                                                        arguments['username'],
                                                    'email': arguments['email'],
                                                    'password':
                                                        arguments['password'],
                                                    'mobile':
                                                        arguments['mobile'],
                                                    'address':
                                                        arguments['address'],
                                                    'ara': arguments['ara']
                                                  });
                                            },
                                            color: Color(int.parse(color)),
                                            child: Text(arguments['ara']
                                                ? 'مواعيد سابقة'
                                                : 'Previous Appointments'),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                          )
                                        ],
                                      )
                                    ]))
                          ])))),
        ));
  }
}

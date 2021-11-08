import 'package:Hos/advice/patList.dart';
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

class Doctor {
  int id;
  String name;

  Doctor({this.id, this.name});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Advice extends StatefulWidget {
  @override
  _AdviceState createState() => _AdviceState();
}

class _AdviceState extends State<Advice> {
  Future _getDocAsync;

  Future<List<Doctor>> fetchDoctorLst() async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/doctor/getAll.php",
        headers: {
          "Content-Type": "application/json",
          "Connection": "keep-alive"
        });

    if (response.statusCode == 200) {
      List<Doctor> doclist = List<Doctor>();
      var data = jsonDecode(response.body);
      var records = data['doctors'] as List;

      for (var i = 0; i < records.length; i++) {
        doclist.add(Doctor(
            id: int.parse(records[i]['id'].toString()),
            name: records[i]['name']));
      }
      return doclist;
    } else {
      throw Exception(response.statusCode);
    }
  }

// ignore: non_constant_identifier_names
  Future<Data> sendQuestion(String pat_id, int doc_id, String question) async {
    String url =
        "https://sarhosproject.000webhostapp.com/advice/ask.php?pat_id=" +
            pat_id +
            "&doc_id=" +
            doc_id.toString() +
            "&question=" +
            question;
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
  Doctor selectedDoctor;

  Data thisData;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController question = TextEditingController();
  Future<Data> futureData;

  @override
  void initState() {
    _getDocAsync = fetchDoctorLst();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/pProfile': (context) => PatientProfile(),
          '/pList': (context) => AdvicePatList()
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
                        arguments['ara'] ? 'استشارة طبية' : 'Ask for Advice'),
                  ),
                  body: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              arguments['ara']
                                  ? 'اختر طبيب لاستشارته'
                                  : 'Choose doctor to ask',
                              style: TextStyle(fontSize: 20),
                            ),
                            FutureBuilder(
                                future: _getDocAsync,
                                builder: (context, snap) {
                                  if (!snap.hasData) {
                                    return Container(
                                        child: Center(
                                      child: CircularProgressIndicator(),
                                    ));
                                  }
                                  var response = snap.data;
                                  List<Doctor> doctors =
                                      response as List<Doctor>;
                                  return DropdownButton<Doctor>(
                                      hint: Text(arguments['ara']
                                          ? 'اختر طبيباً'
                                          : 'Select a Doctor'),
                                      value: selectedDoctor,
                                      items: doctors.map((Doctor doc) {
                                        return DropdownMenuItem<Doctor>(
                                          value: doc,
                                          child: Text(doc.name),
                                        );
                                      }).toList(),
                                      onChanged: (Doctor value) {
                                        setState(() {
                                          selectedDoctor = value;
                                        });
                                      });
                                }),
                            Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextFormField(
                                        controller: question,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return arguments['ara']
                                                ? 'الرجاء كتابة سؤالك'
                                                : 'Please enter your question!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                            hintText: arguments['ara']
                                                ? 'الرجاء كتابة سؤالك..'
                                                : 'Please write your question..'),
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
                                                    await sendQuestion(
                                                        arguments['id'],
                                                        selectedDoctor.id,
                                                        question.text);

                                                setState(() {
                                                  thisData = data;
                                                });

                                                if (thisData.response ==
                                                    "inserted") {
                                                  Navigator.pushNamed(
                                                      context, '/pList',
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
                                                ? 'إرسال إلى الطبيب'
                                                : 'Send to Doctor'),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/pList',
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
                                                ? 'استشارات سابقة'
                                                : 'Previous Questions'),
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

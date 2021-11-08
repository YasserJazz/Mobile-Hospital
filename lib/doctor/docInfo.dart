import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:Hos/advice/docList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String color = '#9ec9d0'.replaceAll('#', '0xff');

class Doctor {
  final id;
  final name;
  final phone;
  final email;
  final username;
  final password;
  final clinicId;

  Doctor(
      {this.id,
      this.name,
      this.phone,
      this.email,
      this.username,
      this.password,
      this.clinicId});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      clinicId: json['clinicId'],
    );
  }
}

class DocInfo extends StatefulWidget {
  final String doctorId;
  final bool ara;

  DocInfo({
    @required this.doctorId,
    @required this.ara,
  });

  @override
  _DocInfoState createState() => _DocInfoState();
}

class _DocInfoState extends State<DocInfo> {
  Future<Doctor> futureDoctor;

  Future<Doctor> fetchDoctor() async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/doctor/get.php?id=" +
            widget.doctorId,
        headers: {
          "Content-Type": "application/json",
          "Connection": "keep-alive"
        });

    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    futureDoctor = fetchDoctor();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: widget.ara ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              actions: [
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60)),
                    child: Text(widget.ara ? 'تسجيل خروج' : 'Log out'),
                    textColor: Colors.white,
                    color: Colors.teal[200],
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    })
              ],
              backgroundColor: Color(int.parse(color)),
              title: Text(widget.ara ? 'الصفحة الشخصية' : 'Personal Page'),
            ),
            body: Center(
              child: FutureBuilder<Doctor>(
                future: futureDoctor,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                  width: 100,
                                  height: 100,
                                  image: AssetImage('assets/doctor.png')),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(widget.ara ? 'الاسم: ' : 'Name: ',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    Text(snapshot.data.name,
                                        style: TextStyle(fontSize: 22))
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        widget.ara
                                            ? ' البريد الالكتروني: '
                                            : 'Email: ',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    Text(snapshot.data.email,
                                        style: TextStyle(fontSize: 22))
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        widget.ara
                                            ? ' اسم المستخدم: '
                                            : 'UserName: ',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    Text(snapshot.data.username,
                                        style: TextStyle(fontSize: 22))
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        widget.ara
                                            ? ' رقم الهاتف: '
                                            : 'Phone: ',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    Text(snapshot.data.phone,
                                        style: TextStyle(fontSize: 22))
                                  ]),
                              RaisedButton(
                                color: Color(int.parse(color)),
                                textColor: Colors.white,
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdviceDocList(
                                              ara: widget.ara,
                                              doctorId: widget.doctorId,
                                            ))),
                                padding: const EdgeInsets.all(20),
                                child: Text(widget.ara
                                    ? 'قائمة الاستشارات'
                                    : 'Advice List'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ]));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ));
  }
}

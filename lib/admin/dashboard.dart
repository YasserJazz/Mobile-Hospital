import 'dart:ui';
import 'package:Hos/admin/doctorsList.dart';
import 'package:Hos/admin/patientsList.dart';
import 'package:Hos/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth/clinicReg.dart';
import '../auth/doctorReg.dart';
import '../auth/patientReg.dart';
import 'clinicsList.dart';

String color = '#9ec9d0'.replaceAll('#', '0xff');
var arabic;

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    setState(() {
      arabic = arguments['ara'];
    });

    return new WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              '/home': (context) => MyApp(),
              '/patientForm': (context) => PatRegPage(),
              '/doctorForm': (context) => DoctorRegPage(),
              '/clinicForm': (context) => ClinicRegPage(),
              '/patientsList': (context) => PatientsList(),
              '/doctorsList': (context) => DoctorsList(),
              '/clinicsList': (context) => ClinicsList(),
            },
            home: Directionality(
                textDirection: ara ? TextDirection.rtl : TextDirection.ltr,
                child: Builder(
                    builder: (context) => Scaffold(
                        backgroundColor: Colors.white,
                        appBar: AppBar(
                          backgroundColor: Color(int.parse(color)),
                          title: Text(arabic ? 'لوحة الأدمن' : 'Admin Panel'),
                          actions: [
                            RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                child:
                                    Text(arabic ? 'تسجيل الخروج' : 'Log out'),
                                textColor: Colors.white,
                                color: Colors.teal[200],
                                onPressed: () {
                                  Navigator.pushNamed(context, '/home');
                                })
                          ],
                        ),
                        body: Center(
                            child: Column(
                          children: [
                            Spacer(),
                            Image(
                                width: 100,
                                height: 100,
                                image: AssetImage('assets/sick.png')),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
                                      child: Text(arabic
                                          ? 'تسجيل مريض'
                                          : 'Register new patient'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/patientForm',
                                          arguments: {'ara': arabic})),
                                  RaisedButton(
                                      child: Text(arabic
                                          ? 'قائمة المرضى'
                                          : 'Patients list'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/patientsList',
                                          arguments: {'ara': arabic})),
                                ]),
                            Spacer(),
                            Image(
                                width: 100,
                                height: 100,
                                image: AssetImage('assets/doctor.png')),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
                                      child: Text(arabic
                                          ? 'تسجيل طبيب'
                                          : 'Register new doctor'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/doctorForm',
                                          arguments: {'ara': arabic})),
                                  RaisedButton(
                                      child: Text(arabic
                                          ? 'قائمة الأطباء'
                                          : 'Doctors list'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/doctorsList',
                                          arguments: {'ara': arabic})),
                                ]),
                            Spacer(),
                            Image(
                                width: 100,
                                height: 100,
                                image: AssetImage('assets/hospital.png')),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
                                      child: Text(arabic
                                          ? 'تسجيل عيادة'
                                          : 'Register new clinic'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/clinicForm',
                                          arguments: {'ara': arabic})),
                                  RaisedButton(
                                      child: Text(arabic
                                          ? 'قائمة العيادات'
                                          : 'Clinics list'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/clinicsList',
                                          arguments: {'ara': arabic})),
                                ]),
                            Spacer(),
                          ],
                        )))))));
  }
}

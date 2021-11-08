import 'package:Hos/advice/askAdvice.dart';
import 'package:Hos/appointment/hosAppointment.dart';
import 'package:Hos/patient/location.dart';
import 'package:Hos/patient/info.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class PatientProfile extends StatefulWidget {
  @override
  _PatientProfileState createState() => _PatientProfileState();
}

String color = '#9ec9d0'.replaceAll('#', '0xff');

class _PatientProfileState extends State<PatientProfile> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => MyApp(),
          '/location': (context) => Location(),
          '/advice': (context) => Advice(),
          '/appointment': (context) => HosAppointment(),
          '/info': (context) => PatientInfo(),
        },
        home: Directionality(
          textDirection:
              arguments['ara'] ? TextDirection.rtl : TextDirection.ltr,
          child: Builder(
              builder: (context) => Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    actions: [
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)),
                          child:
                              Text(arguments['ara'] ? 'تسجيل خروج' : 'Log out'),
                          textColor: Colors.white,
                          color: Colors.teal[200],
                          onPressed: () {
                            Navigator.pushNamed(context, '/home',
                                arguments: {'ara': arguments['ara']});
                          })
                    ],
                    backgroundColor: Color(int.parse(color)),
                    title:
                        Text(arguments['ara'] ? 'الصفحة الشخصية' : 'Profile'),
                  ),
                  body: Center(
                      child: Column(children: [
                    Spacer(),
                    Text(
                        arguments['ara']
                            ? 'مرحباً ${arguments['username']}'
                            : 'Hello ${arguments['username']}',
                        style: TextStyle(fontSize: 40.0)),
                    Spacer(),
                    Row(children: [
                      Spacer(),
                      Column(
                        children: [
                          Image(
                              width: 100,
                              height: 100,
                              image: AssetImage('assets/profile.png')),
                          RaisedButton(
                              child: Text(arguments['ara']
                                  ? 'البيانات الشخصية'
                                  : 'Personal Info'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () => Navigator.pushNamed(
                                      context, '/info',
                                      arguments: {
                                        'id': arguments['id'],
                                        'name': arguments['name'],
                                        'username': arguments['username'],
                                        'email': arguments['email'],
                                        'password': arguments['password'],
                                        'mobile': arguments['mobile'],
                                        'address': arguments['address'],
                                        'ara': arguments['ara']
                                      }))
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Image(
                              width: 100,
                              height: 100,
                              image: AssetImage('assets/location.png')),
                          RaisedButton(
                              child: Text(arguments['ara']
                                  ? 'تحديد موقعي'
                                  : 'Set my location'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () => Navigator.pushNamed(
                                      context, '/location',
                                      arguments: {
                                        'id': arguments['id'],
                                        'name': arguments['name'],
                                        'username': arguments['username'],
                                        'email': arguments['email'],
                                        'password': arguments['password'],
                                        'mobile': arguments['mobile'],
                                        'address': arguments['address'],
                                        'ara': arguments['ara']
                                      }))
                        ],
                      ),
                      Spacer()
                    ]),
                    Spacer(),
                    Row(children: [
                      Spacer(),
                      Column(
                        children: [
                          Image(
                              width: 100,
                              height: 100,
                              image: AssetImage('assets/hospital.png')),
                          RaisedButton(
                              child: Text(arguments['ara']
                                  ? 'حجز موعد'
                                  : 'Make an appointment'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () => Navigator.pushNamed(
                                      context, '/appointment',
                                      arguments: {
                                        'id': arguments['id'],
                                        'name': arguments['name'],
                                        'username': arguments['username'],
                                        'email': arguments['email'],
                                        'password': arguments['password'],
                                        'mobile': arguments['mobile'],
                                        'address': arguments['address'],
                                        'ara': arguments['ara']
                                      }))
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Image(
                              width: 100,
                              height: 100,
                              image: AssetImage('assets/doctor.png')),
                          RaisedButton(
                              child: Text(arguments['ara']
                                  ? 'استشارة طبية'
                                  : 'Ask for advice'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () => Navigator.pushNamed(
                                      context, '/advice',
                                      arguments: {
                                        'id': arguments['id'],
                                        'name': arguments['name'],
                                        'username': arguments['username'],
                                        'email': arguments['email'],
                                        'password': arguments['password'],
                                        'mobile': arguments['mobile'],
                                        'address': arguments['address'],
                                        'ara': arguments['ara']
                                      }))
                        ],
                      ),
                      Spacer()
                    ]),
                    Spacer(),
                  ])))),
        ));
  }
}

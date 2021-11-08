import 'package:Hos/patient/patientProfile.dart';
import 'package:flutter/material.dart';

class PatientInfo extends StatefulWidget {
  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  String color = '#9ec9d0'.replaceAll('#', '0xff');

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {'/pProfile': (context) => PatientProfile()},
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
                    title: Text(arguments['ara']
                        ? 'البيانات الشخصية'
                        : 'Personal Info'),
                  ),
                  body: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                arguments['ara']
                                    ? 'الاسم: ${arguments['name']}'
                                    : 'Name: ${arguments['name']}',
                                style: TextStyle(fontSize: 18)),
                            const Divider(
                              height: 20,
                              thickness: 4,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Text(
                                arguments['ara']
                                    ? 'البريد الالكتروني: ${arguments['email']}'
                                    : 'Email:  ${arguments['email']}',
                                style: TextStyle(fontSize: 18)),
                            const Divider(
                              height: 20,
                              thickness: 4,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Text(
                                arguments['ara']
                                    ? 'الجوال: ${arguments['mobile']}'
                                    : 'mobile:  ${arguments['mobile']}',
                                style: TextStyle(fontSize: 18)),
                            const Divider(
                              height: 20,
                              thickness: 4,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Text(
                                arguments['ara']
                                    ? 'اسم المستخدم: ${arguments['username']}'
                                    : 'username:  ${arguments['username']}',
                                style: TextStyle(fontSize: 18)),
                            const Divider(
                              height: 20,
                              thickness: 4,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Text(
                                arguments['ara']
                                    ? 'كلمة المرور: ${arguments['password']}'
                                    : 'Password:  ${arguments['password']}',
                                style: TextStyle(fontSize: 18)),
                            const Divider(
                              height: 20,
                              thickness: 4,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Text(
                                arguments['ara']
                                    ? 'العنوان: ${arguments['address']}'
                                    : 'Address:  ${arguments['address']}',
                                style: TextStyle(fontSize: 18)),
                          ])))),
        ));
  }
}

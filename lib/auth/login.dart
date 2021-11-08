import 'dart:convert';
import 'dart:ui';
import 'package:Hos/clinic/clinicInfo.dart';
import 'package:Hos/doctor/docInfo.dart';

import '../admin/dashboard.dart';
import '../patient/patientProfile.dart';
import 'package:Hos/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

String color = '#9ec9d0'.replaceAll('#', '0xff');
var arabic;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

Future<Data> fetchData(String username, String password) async {
  String url = "https://sarhosproject.000webhostapp.com/login.php?username=" +
      username +
      "&password=" +
      password;
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

class Data {
  final id;
  final name;
  final username;
  final password;
  final email;
  final mobile;
  final phone;
  final address;
  final kind;

  Data(
      {this.id,
      this.name,
      this.username,
      this.password,
      this.email,
      this.mobile,
      this.phone,
      this.address,
      this.kind});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      mobile: json['mobile'],
      phone: json['phone'],
      address: json['address'],
      kind: json['kind'],
    );
  }
}

class _LoginPageState extends State<LoginPage> {
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
              '/pProfile': (context) => PatientProfile(),
              '/admin': (context) => AdminPage(),
            },
            home: Directionality(
                textDirection: ara ? TextDirection.rtl : TextDirection.ltr,
                child: Builder(
                    builder: (context) => Scaffold(
                        backgroundColor: Colors.white,
                        appBar: AppBar(
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            tooltip: 'Back Icon',
                            onPressed: () {
                              Navigator.pushNamed(context, '/home',
                                  arguments: {'ara': arabic});
                            },
                          ),
                          backgroundColor: Color(int.parse(color)),
                          title: Text(arabic ? 'تسجيل الدخول' : 'Login'),
                          centerTitle: true,
                        ),
                        body: MyCustomForm())))));
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  Data thisData;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  Future<Data> futureData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  labelText: arabic ? 'اسم المستخدم' : 'Username',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return arabic
                        ? 'الرجاء إدخال اسم المستخدم'
                        : 'Please enter your username!';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                  labelText: arabic ? 'كلمة المرور' : 'Password',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return arabic
                        ? 'الرجاء إدخال كلمة المرور'
                        : 'Please enter your password!';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: RaisedButton(
                  padding: const EdgeInsets.all(20),
                  color: Color(int.parse(color)),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(arabic
                              ? 'جار التحقق, الرجاء الانتظار'
                              : 'Checking.. please wait')));

                      final Data data =
                          await fetchData(username.text, password.text);

                      setState(() {
                        thisData = data;
                      });

                      if (thisData.kind == "admin") {
                        Navigator.pushNamed(context, '/admin',
                            arguments: {'ara': arabic});
                      } else if (thisData.kind == "patient") {
                        Navigator.pushNamed(context, '/pProfile', arguments: {
                          'id': thisData.id,
                          'name': thisData.name,
                          'username': thisData.username,
                          'email': thisData.email,
                          'password': thisData.password,
                          'mobile': thisData.mobile,
                          'address': thisData.address,
                          'ara': arabic
                        });
                      } else if (thisData.kind == "doctor") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DocInfo(
                                    ara: arabic, doctorId: thisData.id)));
                      } else if (thisData.kind == 'clinic') {
                        Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ClinicInfo(
                                    ara: arabic, clinicId: thisData.id)));
                      }
                    }
                  },
                  child: Text(arabic ? 'تسجيل الدخول' : 'Log in'),
                ),
              ),
              thisData == null
                  ? Container()
                  : Text(arabic
                      ? 'هذا المستخدم هو ${thisData.kind}'
                      : 'The user is ${thisData.kind}')
            ],
          )),
    ));
  }
}

import 'package:Hos/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:Hos/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class NormalRegPage extends StatefulWidget {
  @override
  _NormalRegState createState() => _NormalRegState();
}

class NormalForm extends StatefulWidget {
  @override
  NormalFormState createState() {
    return NormalFormState();
  }
}

String color = '#9ec9d0'.replaceAll('#', '0xff');

Future<Data> fetchData(String username, String password, String name,
    String address, String mobile, String email) async {
  String url =
      "https://sarhosproject.000webhostapp.com/patient/post.php?username=" +
          username +
          "&password=" +
          password +
          "&name=" +
          name +
          "&address=" +
          address +
          "&mobile=" +
          mobile +
          "&email=" +
          email;
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

var arabic;

class _NormalRegState extends State<NormalRegPage> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    setState(() {
      arabic = arguments['ara'];
    });

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => MyApp(),
          '/login': (context) => LoginPage(),
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
                        title: Text(
                            arabic ? 'تسجيل الاشتراك' : 'Patient Register'),
                        centerTitle: true,
                      ),
                      body: NormalForm(),
                    ))));
  }
}

class NormalFormState extends State<NormalForm> {
  final _formKey = GlobalKey<FormState>();
  Data thisData;
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  Future<Data> futureData;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: arabic ? 'الاسم' : 'Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return arabic
                            ? 'الرجاء إدخال الاسم'
                            : 'Please enter your Name!';
                      }
                      return null;
                    },
                  ),
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
                    controller: email,
                    decoration: InputDecoration(
                      labelText: arabic ? 'البريد الالكتروني' : 'Email',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return arabic
                            ? 'الرجاء إدخال البريد الالكتروني'
                            : 'Please enter your email!';
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
                  TextFormField(
                    controller: address,
                    decoration: InputDecoration(
                      labelText: arabic ? 'العنوان' : 'Address',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return arabic
                            ? 'الرجاء إدخال العنوان'
                            : 'Please enter your Address!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: mobile,
                    decoration: InputDecoration(
                      labelText: arabic ? 'الجوال' : 'Mobile',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return arabic
                            ? 'الرجاء إدخال رقم الجوال'
                            : 'Please enter your mobile number!';
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  arabic ? 'الرجاء الانتظار' : 'Please Wait')));

                          final Data data = await fetchData(
                              username.text,
                              password.text,
                              name.text,
                              address.text,
                              mobile.text,
                              email.text);

                          setState(() {
                            thisData = data;
                          });

                          if (thisData.response == "inserted") {
                            Navigator.pushNamed(context, '/login',
                                arguments: {'ara': arabic});
                          }
                        }
                      },
                      child: Text(arabic ? 'تسجيل الاشتراك' : 'Sign Up'),
                    ),
                  ),
                  // thisData == null
                  //     ? Container()
                  //     : Text("The Response is ${thisData.response}")
                ],
              ),
            )));
  }
}

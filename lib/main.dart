import 'package:Hos/auth/Register.dart';
import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'patient/patientProfile.dart';

bool ara = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String color = '#9ec9d0'.replaceAll('#', '0xff');

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              '/patientForm': (context) => NormalRegPage(),
              '/login': (context) => LoginPage(),
              '/register': (context) => NormalRegPage(),
              '/pProfile': (context) => PatientProfile(),
            },
            home: Directionality(
              textDirection: ara ? TextDirection.rtl : TextDirection.ltr,
              child: Builder(
                  builder: (context) => Scaffold(
                        backgroundColor: Colors.white,
                        appBar: AppBar(
                          centerTitle: true,
                          // leading: IconButton(
                          //   icon: Icon(Icons.menu),
                          //   tooltip: 'Menu Icon',
                          //   onPressed: () {},
                          // ),
                          backgroundColor: Color(int.parse(color)),
                          title: Text(
                              ara ? 'تطبيق المشفى المتنقل' : 'Mobile Hospital'),
                        ),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Spacer(),
                              Image(
                                image: AssetImage('assets/newlogo.jpg'),
                                height: 300,
                                width: 300,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RaisedButton(
                                      color: Color(int.parse(color)),
                                      textColor: Colors.white,
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/login',
                                          arguments: {'ara': ara}),
                                      padding: const EdgeInsets.all(20),
                                      child:
                                          Text(ara ? 'تسجيل الدخول' : 'Log in'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    RaisedButton(
                                      color: Color(int.parse(color)),
                                      textColor: Colors.white,
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/patientForm',
                                          arguments: {'ara': ara}),
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                          ara ? 'تسجيل اشتراك' : 'Register'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                  ]),
                              Spacer(),
                              Spacer(),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Spacer(),
                              //     RaisedButton(
                              //       color: Color(int.parse(color)),
                              //       textColor: Colors.white,
                              //       onPressed: () =>
                              //           Navigator.pushNamed(context, '/register'),
                              //       padding: const EdgeInsets.all(20),
                              //       child: Text('Admin panel'),
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(50)),
                              //     ),
                              //     Spacer(),
                              //     RaisedButton(
                              //       color: Color(int.parse(color)),
                              //       textColor: Colors.white,
                              //       onPressed: () =>
                              //           Navigator.pushNamed(context, '/pProfile'),
                              //       padding: const EdgeInsets.all(20),
                              //       child: Text('Patient Profile'),
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(50)),
                              //     ),
                              //     Spacer(),
                              //   ],
                              // ),
                              // Spacer(),
                            ],
                          ),
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () => {
                            setState(() {
                              ara = !ara;
                            })
                          },
                          child: Text(ara ? 'Eng' : 'عربي'),
                          backgroundColor: Color(int.parse(color)),
                        ),
                      )),
            )));
  }
}

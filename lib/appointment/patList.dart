import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'hosAppointment.dart';

class AppointmentPatList extends StatefulWidget {
  @override
  _AppointmentPatListState createState() => _AppointmentPatListState();
}

class AppointmentList {
  final id;
  final pat_id;
  final hos_id;
  final hos_name;
  final priority;
  final notes;
  final status;

  AppointmentList({
    this.id,
    this.pat_id,
    this.hos_id,
    this.hos_name,
    this.priority,
    this.notes,
    this.status,
  });

  factory AppointmentList.fromJson(Map<String, dynamic> json) {
    return AppointmentList(
      id: json['id'],
      pat_id: json['pat_id'],
      hos_id: json['hos_id'],
      hos_name: json['hos_name'],
      priority: json['priority'],
      notes: json['notes'],
      status: json['status'],
    );
  }
}

class _AppointmentPatListState extends State<AppointmentPatList> {
  Future<List<AppointmentList>> fetchAppointmentList(patId) async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/appointment/patList.php?pat_id=" +
            patId,
        headers: {
          "Content-Type": "application/json",
          "Connection": "keep-alive"
        });

    if (response.statusCode == 200) {
      List<AppointmentList> appList = List<AppointmentList>();
      var data = jsonDecode(response.body);
      var records = data['records'] as List;

      for (var i = 0; i < records.length; i++) {
        appList.add(AppointmentList.fromJson(records[i]));
      }
      return appList;
    } else {
      throw Exception(response.statusCode);
    }
  }

  String color = '#9ec9d0'.replaceAll('#', '0xff');
  var patId;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/appointment': (context) => HosAppointment(),
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
                                Navigator.pushNamed(context, '/appointment',
                                    arguments: {
                                      'id': arguments['id'],
                                      'name': arguments['name'],
                                      'username': arguments['username'],
                                      'email': arguments['email'],
                                      'password': arguments['password'],
                                      'mobile': arguments['mobile'],
                                      'address': arguments['address'],
                                      'ara': arguments['ara']
                                    })
                              }),
                      backgroundColor: Color(int.parse(color)),
                      title: Text(arguments['ara']
                          ? 'قائمة المواعيد'
                          : 'Appointments List'),
                    ),
                    body: FutureBuilder(
                        future: fetchAppointmentList(arguments['id']),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
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
                                          title: Text(snapshot
                                              .data[index].hos_name
                                              .toString()),
                                          subtitle: Column(children: [
                                            Row(
                                              children: [
                                                Text(
                                                  arguments['ara']
                                                      ? 'الأولوية: '
                                                      : 'Priority: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(snapshot.data[index]
                                                            .priority ==
                                                        '1'
                                                    ? arguments['ara']
                                                        ? 'عادي'
                                                        : 'Normal'
                                                    : arguments['ara']
                                                        ? 'طارئ'
                                                        : 'Urgent'),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    snapshot.data[index].notes),
                                                snapshot.data[index].status ==
                                                        null
                                                    ? Text(arguments['ara']
                                                        ? 'لا يوجد جواب بعد'
                                                        : 'No answer yet')
                                                    : Text(snapshot.data[index]
                                                                .status ==
                                                            '1'
                                                        ? arguments['ara']
                                                            ? 'مع الموافقة'
                                                            : 'Approved'
                                                        : arguments['ara']
                                                            ? 'مع الرفض'
                                                            : 'Rejected')
                                              ],
                                            ),
                                          ]))),
                                ),
                              ));
                        })))));
  }
}

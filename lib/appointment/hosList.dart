import 'dart:convert';
import 'package:Hos/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentHosList extends StatefulWidget {
  final clinicId;
  final ara;

  AppointmentHosList({this.clinicId, this.ara});

  @override
  _AppointmentHosListState createState() => _AppointmentHosListState();
}

class Data {
  final response;

  Data({this.response});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      response: json['response'],
    );
  }
}

class AppointmentList {
  final id;
  final pat_name;
  final hos_id;
  final hos_name;
  final priority;
  final notes;
  final status;

  AppointmentList({
    this.id,
    this.pat_name,
    this.hos_id,
    this.hos_name,
    this.priority,
    this.notes,
    this.status,
  });

  factory AppointmentList.fromJson(Map<String, dynamic> json) {
    return AppointmentList(
      id: json['id'],
      pat_name: json['pat_name'],
      hos_id: json['hos_id'],
      hos_name: json['hos_name'],
      priority: json['priority'],
      notes: json['notes'],
      status: json['status'],
    );
  }
}

class _AppointmentHosListState extends State<AppointmentHosList> {
  Future<Data> answerAppointment(String appId, String status) async {
    String url =
        "https://sarhosproject.000webhostapp.com/appointment/answer.php?id=" +
            appId +
            "&status=" +
            status;
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

  Future<List<AppointmentList>> fetchAppointmentList(hosId) async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/appointment/hosList.php?hos_id=" +
            widget.clinicId,
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
  var hosId;
  Data thisData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => MyApp(),
        },
        home: Directionality(
            textDirection: widget.ara ? TextDirection.rtl : TextDirection.ltr,
            child: Builder(
                builder: (context) => Scaffold(
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
                              Navigator.pushNamed(context, '/home', arguments: {
                                'id': widget.clinicId,
                                'ara': widget.ara
                              });
                            })
                      ],
                      backgroundColor: Color(int.parse(color)),
                      title: Text(
                          widget.ara ? 'قائمة المواعيد' : 'Appointments List'),
                    ),
                    body: FutureBuilder(
                        future: fetchAppointmentList(widget.clinicId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Image(
                                      width: 150,
                                      height: 150,
                                      image: AssetImage('assets/warning.png')),
                                  Container(
                                    height: 50,
                                    width: 50,
                                  ),
                                  Text(
                                    widget.ara
                                        ? 'لا يوجد مواعيد بعد!'
                                        : 'No Appointments Yet!',
                                    style: TextStyle(fontSize: 25),
                                  )
                                ]));
                          } else if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else
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
                                              .data[index].pat_name
                                              .toString()),
                                          subtitle: Column(children: [
                                            Row(
                                              children: [
                                                Text(
                                                  widget.ara
                                                      ? 'الأولوية: '
                                                      : 'Priority: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(snapshot.data[index]
                                                            .priority ==
                                                        '1'
                                                    ? widget.ara
                                                        ? 'عادي'
                                                        : 'Normal'
                                                    : widget.ara
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
                                                    ? Text(widget.ara
                                                        ? 'لا يوجد جواب بعد'
                                                        : 'No answer yet')
                                                    : Text(snapshot.data[index]
                                                                .status ==
                                                            '1'
                                                        ? widget.ara
                                                            ? 'مع الموافقة'
                                                            : 'Approved'
                                                        : widget.ara
                                                            ? 'مع الرفض'
                                                            : 'Rejected')
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                RaisedButton(
                                                  onPressed: () async {
                                                    final Data data =
                                                        await answerAppointment(
                                                            snapshot
                                                                .data[index].id,
                                                            '1');

                                                    setState(() {
                                                      thisData = data;
                                                    });
                                                  },
                                                  color: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60)),
                                                  child: Text(widget.ara
                                                      ? 'موافقة'
                                                      : 'Approve'),
                                                ),
                                                RaisedButton(
                                                  onPressed: () async {
                                                    final Data data =
                                                        await answerAppointment(
                                                            snapshot
                                                                .data[index].id,
                                                            '2');

                                                    setState(() {
                                                      thisData = data;
                                                    });
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60)),
                                                  textColor: Colors.white,
                                                  color: Colors.red,
                                                  child: Text(widget.ara
                                                      ? 'رفض'
                                                      : 'Reject'),
                                                ),
                                              ],
                                            )
                                          ]),
                                        ))),
                              ),
                            );
                        })))));
  }
}

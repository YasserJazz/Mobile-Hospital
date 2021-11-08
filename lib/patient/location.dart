import 'package:Hos/patient/patientProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class Loc {
  final location;
  final date;

  Loc({
    this.location,
    this.date,
  });

  factory Loc.fromJson(Map<String, dynamic> json) {
    return Loc(
      location: json['location'],
      date: json['date'],
    );
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

class _LocationState extends State<Location> {
  String color = '#9ec9d0'.replaceAll('#', '0xff');
  var patId;
  Future<List<Loc>> getLocations(patId) async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/location/getAll.php?pat_id=" +
            patId,
        headers: {
          "Content-Type": "application/json",
          "Connection": "keep-alive"
        });

    if (response.statusCode == 200) {
      List<Loc> locationsList = List<Loc>();
      var data = jsonDecode(response.body);
      var records = data['records'] as List;

      for (var i = 0; i < records.length; i++) {
        locationsList.add(Loc(
            location: records[i]['location'],
            date: records[i]['date'].toString()));
      }
      return locationsList;
    } else {
      throw Exception(response.statusCode);
    }
  }

// ignore: non_constant_identifier_names
  Future<Data> sendLocation(String pat_id, String location, String date) async {
    String url =
        "https://sarhosproject.000webhostapp.com/location/set.php?pat_id=" +
            pat_id +
            "&location=" +
            location +
            "&date=" +
            date;
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

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final _formKey = GlobalKey<FormState>();
    final TextEditingController control = TextEditingController();
    Data thisData;

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
                        onPressed: () => Navigator.pushNamed(
                            context, '/pProfile',
                            arguments: {
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
                          ? 'موقع المريض'
                          : 'Patient Location'),
                    ),
                    body: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Form(
                                      key: _formKey,
                                      child: Column(children: [
                                        TextFormField(
                                          controller: control,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return arguments['ara']
                                                  ? 'الرجاء تحديد موقعك أولاً!'
                                                  : 'Please enter your location!';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0)),
                                              ),
                                              hintText: arguments['ara']
                                                  ? 'اكتب موقعك الحالي..'
                                                  : 'Please write your current location..'),
                                        ),
                                        RaisedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              final Data data =
                                                  await sendLocation(
                                                      arguments['id'],
                                                      control.text,
                                                      DateTime.now()
                                                          .toString());

                                              setState(() {
                                                thisData = data;
                                                patId = arguments['id'];
                                              });

                                              if (thisData.response ==
                                                  "inserted") {}
                                            }
                                          },
                                          color: Color(int.parse(color)),
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Text(arguments['ara']
                                              ? 'حفظ'
                                              : 'Save'),
                                        )
                                      ])),
                                  FutureBuilder(
                                      future: getLocations(arguments['id']),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                          // Center(child: CircularProgressIndicator());
                                        }
                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                              ),
                                              Text(
                                                arguments['ara']
                                                    ? 'المواقع السابقة: '
                                                    : 'Previous Locations: ',
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Color(
                                                        int.parse(color))),
                                              ),
                                              Column(
                                                children: List.generate(
                                                    snapshot.data.length,
                                                    (index) => Container(
                                                        decoration: BoxDecoration(
                                                            border:
                                                                Border.all(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: ListTile(
                                                            title: Text(snapshot
                                                                .data[index]
                                                                .location),
                                                            subtitle: Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .date)))),
                                              ),
                                            ]);
                                      })
                                ])))))));
  }
}

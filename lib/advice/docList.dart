import 'dart:convert';
import 'package:Hos/advice/single.dart';
import 'package:Hos/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdviceDocList extends StatefulWidget {
  final doctorId;
  final ara;

  AdviceDocList({this.doctorId, this.ara});

  @override
  _AdviceDocListState createState() => _AdviceDocListState();
}

class AdviceLst {
  final id;
  final pat_name;
  final doc_id;
  final doc_name;
  final question;
  final answer;

  AdviceLst({
    this.id,
    this.pat_name,
    this.doc_id,
    this.doc_name,
    this.question,
    this.answer,
  });

  factory AdviceLst.fromJson(Map<String, dynamic> json) {
    return AdviceLst(
      id: json['id'],
      pat_name: json['pat_name'],
      doc_id: json['doc_id'],
      doc_name: json['doc_name'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class _AdviceDocListState extends State<AdviceDocList> {
  Future<List<AdviceLst>> fetchAdviceLst() async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/advice/docList.php?doc_id=" +
            widget.doctorId,
        headers: {
          "Content-Type": "application/json",
          "Connection": "keep-alive"
        });

    if (response.statusCode == 200) {
      List<AdviceLst> advList = List<AdviceLst>();
      var data = jsonDecode(response.body);
      var records = data['records'] as List;

      for (var i = 0; i < records.length; i++) {
        advList.add(AdviceLst.fromJson(records[i]));
      }
      return advList;
    } else {
      throw Exception(response.statusCode);
    }
  }

  String color = '#9ec9d0'.replaceAll('#', '0xff');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => MyApp(),
          '/single': (context) => SingleAdvice()
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
                                'id': widget.doctorId,
                                'ara': widget.ara
                              });
                            })
                      ],
                      backgroundColor: Color(int.parse(color)),
                      title:
                          Text(widget.ara ? 'قائمة الاستشارات' : 'Advice List'),
                    ),
                    body: FutureBuilder(
                        future: fetchAdviceLst(),
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
                                        ? 'لا يوجد استشارات بعد!'
                                        : 'No Questions Yet!',
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
                                          title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(snapshot
                                                    .data[index].pat_name
                                                    .toString()),
                                                RaisedButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                        context, '/single',
                                                        arguments: {
                                                          'id': widget.doctorId,
                                                          'ara': widget.ara,
                                                          'question': snapshot
                                                              .data[index]
                                                              .question,
                                                          'advId': snapshot
                                                              .data[index].id
                                                        });
                                                  },
                                                  child: Text(widget.ara
                                                      ? 'الإجابة'
                                                      : 'Answer'),
                                                  color: Colors.cyan,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60)),
                                                )
                                              ]),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              snapshot.data[index].question ==
                                                      null
                                                  ? Container()
                                                  : Text(snapshot
                                                      .data[index].question),
                                              snapshot.data[index].answer ==
                                                      null
                                                  ? Text(widget.ara
                                                      ? 'لا يوجد جواب بعد'
                                                      : 'No answer yet')
                                                  : Text(snapshot
                                                      .data[index].answer)
                                            ],
                                          ),
                                        ))),
                              ),
                            );
                        })))));
  }
}

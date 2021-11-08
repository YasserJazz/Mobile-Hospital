import 'dart:convert';
import 'package:Hos/advice/askAdvice.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdvicePatList extends StatefulWidget {
  @override
  _AdvicePatListState createState() => _AdvicePatListState();
}

class AdviceLst {
  final id;
  final pat_id;
  final doc_id;
  final doc_name;
  final question;
  final answer;

  AdviceLst({
    this.id,
    this.pat_id,
    this.doc_id,
    this.doc_name,
    this.question,
    this.answer,
  });

  factory AdviceLst.fromJson(Map<String, dynamic> json) {
    return AdviceLst(
      id: json['id'],
      pat_id: json['pat_id'],
      doc_id: json['doc_id'],
      doc_name: json['doc_name'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class _AdvicePatListState extends State<AdvicePatList> {
  Future<List<AdviceLst>> fetchAdviceLst(patId) async {
    final response = await http.get(
        "https://sarhosproject.000webhostapp.com/advice/patList.php?pat_id=" +
            patId,
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
  var patId;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {'/advice': (context) => Advice()},
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
                                Navigator.pushNamed(context, '/advice',
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
                              }),
                      backgroundColor: Color(int.parse(color)),
                      title: Text(arguments['ara']
                          ? 'قائمة الاستشارات'
                          : 'Advice List'),
                    ),
                    body: FutureBuilder(
                        future: fetchAdviceLst(arguments['id']),
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
                                            .data[index].doc_name
                                            .toString()),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            snapshot.data[index].question == null
                                                ? Container()
                                                : Text(
                                                    snapshot.data[index].question),
                                            snapshot.data[index].answer == null
                                                ? Text(arguments['ara']
                                                    ? 'لا يوجد جواب بعد'
                                                    : 'No answer yet')
                                                : Text(
                                                    snapshot.data[index].answer)
                                          ],
                                        ),
                                      ))),
                            ),
                          );
                        })))));
  }
}

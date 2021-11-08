import 'dart:convert';

import 'package:Hos/advice/docList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SingleAdvice extends StatefulWidget {
  @override
  _SingleAdviceState createState() => _SingleAdviceState();
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

class _SingleAdviceState extends State<SingleAdvice> {
  Future<Data> answerAdvice(String advId, String answer) async {
    String url =
        "https://sarhosproject.000webhostapp.com/advice/answer.php?id=" +
            advId +
            "&answer=" +
            answer;
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
    String color = '#9ec9d0'.replaceAll('#', '0xff');
    final _formKey = GlobalKey<FormState>();
    final TextEditingController answer = TextEditingController();
    Data thisData;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {'/docList': (context) => AdviceDocList()},
        home: Directionality(
            textDirection:
                arguments['ara'] ? TextDirection.rtl : TextDirection.ltr,
            child: Builder(
                builder: (context) => Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        tooltip: 'Back Icon',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdviceDocList(
                                      ara: arguments['ara'],
                                      doctorId: arguments['id'])));
                        },
                      ),
                      backgroundColor: Color(int.parse(color)),
                      title: Text(arguments['ara'] ? 'الإجابة' : 'Answer'),
                    ),
                    body: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image(
                                          width: 100,
                                          height: 100,
                                          image: AssetImage('assets/sick.png')),
                                      Text(
                                        arguments['ara']
                                            ? 'السؤال: ${arguments['question']}'
                                            : 'Question: ${arguments['question']}',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 40,
                                      ),
                                      Image(
                                          width: 100,
                                          height: 100,
                                          image:
                                              AssetImage('assets/doctor.png')),
                                      Text(
                                        arguments['ara']
                                            ? 'الإجابة: '
                                            : 'Answer: ',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      TextFormField(
                                        controller: answer,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return arguments['ara']
                                                ? 'الرجاء كتابة إجابتك'
                                                : 'Please write your answer!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                            hintText: arguments['ara']
                                                ? 'الرجاء كتابة إجابتك..'
                                                : 'Please write your answer..'),
                                      ),
                                      RaisedButton(
                                          child: Text(arguments['ara']
                                              ? 'حفظ'
                                              : 'Save'),
                                          color: Color(int.parse(color)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60)),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              final Data data =
                                                  await answerAdvice(
                                                      arguments['advId'],
                                                      answer.text);

                                              setState(() {
                                                thisData = data;
                                              });

                                              if (thisData.response ==
                                                  "updated") {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdviceDocList(
                                                                ara: arguments[
                                                                    'ara'],
                                                                doctorId:
                                                                    arguments[
                                                                        'id'])));
                                              }
                                            }
                                          })
                                    ]))))))));
  }
}

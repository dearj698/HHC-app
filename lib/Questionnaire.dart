import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//class Data {
//  List questions;
//  List options;
//
//  Data({this.questions,this.options});
//
//  factory Data.fromJson(Map<String, dynamic> json){
//    return Data(
//      questions: json["questions"],
//      options: json["options"],
//    );
//  }
//}
//const url = 'http://ADDRESS/questionnaire';

class Questionnaire extends StatefulWidget {
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  int index = 0;
  List boolList = createBooleanList();
  static TextStyle _bold = TextStyle(fontWeight: FontWeight.bold);
  static TextStyle _size30Bold =  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List options = [["Yes","No"],["I did","I didn't"],
    ["Fever","Cough","Runny nose","None of above"],["Yes","No"]]  ;
  List questions = ["Have you contacted confirmed cases?",
    "Have you went to public places?",
    "Do you have any of following symptoms?",
    "Are you sure?"];

  static List createBooleanList(){
    int length = 16;
    List boolList = new List(length);
    boolList.fillRange(0, length, false);
    return boolList;
  }

  void nextQuestion(){
    setState(() {
      index++;
    });
  }

  //Method for creating two-choices only buttons
  Container createYesNoQuestionsButton(List options){
    Container buttons = new Container(
      margin: EdgeInsets.only(
        left: 20, bottom: 30
      ),
      child: Row(
        children: <Widget>[
          //Button one
          ButtonTheme(
            minWidth: 150.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green)),
              onPressed: nextQuestion,
              color: Colors.green,
              child: Text(options[0]),
            ),
          ),
          Padding(padding: EdgeInsets.all(15),),
          //Button two
          ButtonTheme(
            minWidth: 150.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green)),
              onPressed: nextQuestion,
              color: Colors.green,
              child: Text(options[1]),
            ),
          ),
        ],
      ),
    );
    return buttons;
  }

  //Method for creating a checklist and a submit button
  Container createCheckBoxList(List options){
    Container checkBoxList = new Container(
      child: Column(
        children: <Widget>[
          //Checklist
          Column(
            children: createRowChildrenWithPadding(options),
          ),
          //Submit button
          Center(
            child: ButtonTheme(
              child: FlatButton(
                child: Text('Submit'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green),
                ),
                color: Colors.green,
                onPressed: null,
              ),
            ),
          ),
        ],
      ),
    );
    return checkBoxList;
  }

  List<Widget> createRowChildrenWithPadding(List options) {
    var joined = List<Widget>();
    int last = options.length-1;

    for (var i = 0;  i < last; i++) {
        //Checkboxes
        Row checkbox = new Row(
          children: <Widget>[
            Checkbox(
              activeColor: Colors.grey,
              value: boolList[i],
              onChanged: (bool newValue) {
                setState(() {
                  if(newValue==true){boolList[last]=false;}
                  boolList[i] = newValue;
                });
              },
            ),
            Padding(padding: EdgeInsets.all(5),),
            Text(options[i], style: _bold,)
          ],
        );
        joined.add(checkbox);
        joined.add(Padding(padding: EdgeInsets.all(10)));
    }
    //Last checkbox should be 'None of above'
    Row lastCheckbox = new Row(
      children: <Widget>[
        Checkbox(
          activeColor: Colors.grey,
          value: boolList[last],
          onChanged: (bool newValue) {
            setState(() {
              if(newValue==true){boolList.fillRange(0, last, false);}
              boolList[last] = newValue;
            });
          },
        ),
        Padding(padding: EdgeInsets.all(5),),
        Text(options[last], style: _bold,)
      ],
    );
    joined.add(lastCheckbox);
    return joined;
  }

  Widget typeCheck(List optionsList){
    if(optionsList.length == 2){//It is a yes/no question
      return createYesNoQuestionsButton(optionsList);
    } else {//It is a checkbox list
      return createCheckBoxList(optionsList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Questionnaire',),backgroundColor: Colors.green,centerTitle: true,
      ),
      body: new Column(
        children: <Widget>[
          //Questions
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(questions[index],
                    style: _size30Bold,)
                ],
              ),
            )
          ),

          //Buttons
          Center(
            child: typeCheck(options[index]),
          )
        ],
      ),
    );
  }
}
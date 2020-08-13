


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:homeorganiser/screens/login_screen.dart';


void main() {
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "demo",
      home: MyhomeApp()
    );
  }
}

class MyhomeApp extends StatefulWidget {
  @override
  _MyhomeAppState createState() => _MyhomeAppState();
}

class _MyhomeAppState extends State<MyhomeApp> {
  final databaseReference = Firestore.instance;
  final myController_name = TextEditingController();
  final myController_location = TextEditingController();
  final myController_query = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Organiser"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Home Organiser", textScaleFactor: 2,),

            FlatButton(
              child: Text("Add"),
              onPressed: () {
                createRecord(myController_name.text, myController_location.text);
                Toast.show("Added", context, gravity: Toast.CENTER);
                myController_name.clear();
                myController_location.clear();
              },
              color: Colors.blueAccent,
              textColor: Colors.white,

            ),
            TextField(
              controller: myController_name,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Object Name"
              ),
            ),
            TextField(
              controller: myController_location,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.blue,
                  hintText: "Enter location"
              ),
            ),
            Text("Enter the location to view its contents"),
            TextField(
              controller: myController_query,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter the location to view its all of the contents"
              ),
            ),
            FlatButton(
              child: Text("View"),
              onPressed: () {
                viewRecord(myController_query.text);
                myController_query.clear();
                Toast.show("List Generated", context, gravity: Toast.CENTER);
              },
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        ),

      ),
    );
  }

  Future<bool> _onbackPressed() {
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text("Exit?"),
        actions: <Widget>[
          FlatButton(
            child:Text("NO"),
            onPressed: ()=>Navigator.pop(context, false),
          )
        ],
      )
    );
  }
}

void viewRecord(String query) async{
  var ref = await Firestore.instance.collection("Objects").where("location", isEqualTo: query).orderBy('name').getDocuments();
  ref.documents.forEach((i) {
    print(i.data);
  });
}


void createRecord(String name, String location) async {

  DocumentReference ref = await Firestore.instance.collection("Objects")
      .add({
    "name":name,
    "location":location
  });
  print(ref.documentID);
}

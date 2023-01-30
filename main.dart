import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Booking',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(title: 'Movie Booking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  var desc = "";
  var poster = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Movie App',
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Enter Movie Name below :",
                        style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "Movie Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    MaterialButton(
                        onPressed: () {
                          _pressMe(textEditingController.text);
                        },
                        color: Theme.of(context).colorScheme.primary,
                        child: const Text("Press Me",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ))),
                    Card(
                        //margin: const EdgeInsets.all(12),
                        child: Container(
                            margin: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Image.network(
                                  poster,
                                  height: 240,
                                  width: 150,
                                )
                              ],
                            ))),
                    Text(desc)
                  ]),
            ),
          ),
        ));
  }

  Future<void> _pressMe(String value) async {
    //myapiid = "9f2cd5d4";
    var url = Uri.parse('http://www.omdbapi.com/?t=$value&apikey=9f2cd5d4');
    var response = await http.get(url);
    var rescode = response.statusCode;
    var jsonData = response.body;
    var parsedJson = json.decode(jsonData);
    poster = parsedJson['Poster'];
    ProgressDialog dialog = ProgressDialog(context,
        message: const Text("Progressing..."),
        title: const Text("Searching..."));
    dialog.show();
    if (rescode == 200) {
      Fluttertoast.showToast(
          msg: "Movie is Found!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      setState(() {
        var title = parsedJson['Title'];
        var year = parsedJson['Year'];
        var genre = parsedJson['Genre'];
        var actor = parsedJson['Actors'];
        var language = parsedJson['Language'];
        desc = "The Movie Title: " +
            "$title\n" +
            "Year Released:" +
            "$year\n" +
            "Genre: " +
            "$genre\n" +
            "Actor: " +
            "$actor\n" +
            "Language: " +
            "$language\n";
      });
      dialog.dismiss();
    } else {
      setState(() {
        desc = "No record";
      });
    }
  }
}

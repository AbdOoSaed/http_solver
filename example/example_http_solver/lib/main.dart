import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_solver/http_solver.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  Either<Failure, Post> _modelOrError;
  final url = "http://www.mocky.io/v2/5e3c29393000009c2e214bf8";
  final urlWithNotFound = "http://www.mocky.io/v2/5e4b041f2f0000490097d6ca";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            FloatingActionButton(onPressed: _getEither, child: Text('Get')),
        body: Center(
          child: (widget._modelOrError == null)
              ? Text('No Data Yet')
              : widget._modelOrError.fold((failure) => Text(failure.toString()),
                  (post) => Text(post.title)),
        ));
  }

  void _getEither() async {
    widget._modelOrError = await HttpSolver.getFromApi(
            Post(), widget.urlWithNotFound,
            checkInternet: true)
        .toEither();
    setState(() {});
  }
}

class Post implements BaseModelForHttpSolver {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    this.id,
    this.userId,
    this.title,
    this.body,
  });

  Post fromJson(String source) {
    Map<String, dynamic> jsonData = (json.decode(source));
    if (jsonData == null) return null;
    return Post(
      id: jsonData['id'],
      userId: jsonData['userId'],
      title: jsonData['title'],
      body: jsonData['body'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = HashMap<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

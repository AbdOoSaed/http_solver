import 'package:flutter/material.dart';
import 'package:http_solver/http_solver.dart' as httpSolver;
import 'model_post.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  final httpSolver.HttpSolver _solver = httpSolver.HttpSolver();
  httpSolver.Either<httpSolver.Failure, Post> _data;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _getApi,
      ),
      body: Center(
        child: (widget._data == null)
            ? Container(
                color: Colors.amber,
              )
            : widget._data.fold(
                (failure) => Text("${failure.message}"),
                (post) => Text(post.title),
              ),
      ),
    );
  }

  void _getApi() async {
    await widget._solver
        .getFromApi(Post(), "http://www.mocky.io/v2/5e3c29393000009c2e214bf8",
            checkInternet: true)
        .toEither<Post>()
        .then((n) => widget._data = n);
    setState(() {});
  }
}
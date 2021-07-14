import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Post>> posts;

  Future<List<Post>> getPosts() async {
    final baseURL = "http://jsonplaceholder.typicode.com";
    var url = Uri.parse(
      '$baseURL/posts',
    );
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      return json.map((e) => Post.fromJson(e)).toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    posts = getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Post>>(
          future: posts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: snapshot.data!
                    .map(
                      (Post post) => ListTile(
                        title: Text("${post.id} - ${post.title}"),
                      ),
                    )
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

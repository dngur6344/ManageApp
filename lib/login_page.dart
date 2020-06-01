import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  void validateAndSave() {
    final form = formKey.currentState;
    Future<Post> post = fetchPost();

    if (form.validate()) {
      form.save();
      print('Form is valid Email: $_email, password: $_password');
    } else {
      print('Form is invalid Email: $_email, password: $_password');
    }
  }

  Future<Post> fetchPost() async {
    final response = await get('http://localhost:8080/teachers/$_email');
    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.

      print(Post.fromJson(json.decode(response.body)).tel);
      return Post.fromJson(json.decode(response.body));
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('login'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = value,
              ),
              new TextFormField(
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Password'),
                validator: (value) =>
                value.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value,
              ),
              new RaisedButton(
                child: new Text(
                  'Login',
                  style: new TextStyle(fontSize: 20.0),
                ),
                onPressed: validateAndSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Post {
  final String teacherid;
  final String name;
  final String tel;
  final String birthday;

  Post({this.teacherid, this.name, this.tel, this.birthday});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      teacherid: json['teacher_id'],
      name: json['name'],
      tel: json['tel'],
      birthday: json['birthday'],
    );
  }
}

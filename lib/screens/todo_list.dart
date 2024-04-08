import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  void iniState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Center(
              child: Text(
            "Todo List",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ))),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['title']),
                subtitle: Text(item['description']),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text("Add Todo")),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => const AddPage(todo: null),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    final url = "https://api.nstack.in/v1/todos?page=1&limit=5";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } else {
      //show error
    }
    setState(() {
      isLoading = true;
    });
  }
}

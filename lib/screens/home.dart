import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/todo.dart';
import 'package:flutter_application_1/screens/add_page.dart';
import 'package:flutter_application_1/services/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoService = TodoServices();
  List<Todo>? todos;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: fetchTodo,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateAddScreen,
        child: const Icon(Icons.add),
      ),
      body: Visibility(
        visible: todos != null,
        // ignore: sort_child_properties_last
        child: Visibility(
          visible: todos?.isNotEmpty ?? false,
          // ignore: sort_child_properties_last
          child: ListView.builder(
            itemBuilder: (_, i) {
              final todo = todos![i];
              return _buildTodoItem(todo);
            },
            itemCount: todos?.length,
          ),
          replacement: Center(
            child: Text(
              'No Todo task to show',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildTodoItem(Todo todo) {
    return ListTile(
      leading: IconButton(
        onPressed: () => toggleTaskCompleteion(todo),
        icon: Icon(
          todo.completed ? Icons.check_box : Icons.check_box_outline_blank,
          color: todo.completed ? Colors.blue : Colors.grey,
        ),
      ),
      title: Text(todo.title),
      subtitle: Text(todo.content),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ];
        },
        onSelected: (String value) {
          popUpAction(value, todo);
        },
      ),
    );
  }
 //mn
  Future<void> toggleTaskCompleteion(Todo todo) async {
    final status = await todoService.updateTodo(
      id: todo.id,
      completed: !todo.completed,
      content: todo.content,
      title: todo.title,
    );
    if (status) {
      fetchTodo();
    } else {
      final snackBar = SnackBar(content: Text('Mark Task ${todo.title}'));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> popUpAction(String option, Todo todo) async {
    if (option == 'delete') {
      final status = await todoService.deleteTodo(id: todo.id);
      if (status) {
        fetchTodo();
      } else {
        final snackBar = SnackBar(content: Text('Delete failed ${todo.title}'));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (option == 'edit') {
      navigateAddScreen(todo: todo);
    } else {
      final snackBar = SnackBar(content: Text('$option Not Implemented'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchTodo() async {
    setState(() {
      todos = null;
    });
    final result = await todoService.fetchTodo();
    if (result != null) {
      setState(() {
        todos = result;
      });
    } else {
      const snackBar = SnackBar(content: Text('Something went wrong'));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> navigateAddScreen({Todo? todo}) async {
    final route = MaterialPageRoute(builder: (_) => AddPage(todo: todo));
    await Navigator.push(context, route);
    fetchTodo();
  }
}

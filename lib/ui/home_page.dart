import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/moor_database.dart';
import '../widgets/task_item.dart';
import '../widgets/new_task_input.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Buddy'),
      ),
      body: Column(
        children: <Widget>[
          //TASK LIST
          Expanded(
            child: _buildTaskList(context),
          ),
          //NEW TASK
          NewTaskInput(),
        ],
      ),
    );
  }
}

//Build the List of Task items via StreamBuilder
StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
  final database = Provider.of<AppDatabase>(context);
  return StreamBuilder(
    stream: database.watchAllTasks(),
    builder: (context, AsyncSnapshot<List<Task>> snapshot) {
      final tasks = snapshot.data ?? List();
      //List of Tasks
      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, index) {
          final itemTask = tasks[index];
          return TaskItem(task: itemTask);
        },
      );
    },
  );
}

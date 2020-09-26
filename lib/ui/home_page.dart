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
  bool showCompletedTask = false;
  
  //Switch Widget to Filter Completed Tasks
  Row _buildCompletedOnlySwitch() {
    return Row(
      children: <Widget>[
        Text('Completed only'),
        Switch(
          value: showCompletedTask,
          activeColor: Colors.white,
          onChanged: (newValue) {
            setState(() {
              showCompletedTask = newValue;
            });
          },
        ),
      ],
    );
  }

  //Build the List of Task items via StreamBuilder
  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    //final database = Provider.of<AppDatabase>(context);
    final dao = Provider.of<TaskDao>(context);
    return StreamBuilder(
      stream: showCompletedTask ? dao.watchCompletedTasks() : dao.watchAllTasks(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Buddy'),
        actions: <Widget>[
          //SWITCH - to filter completed tasks
          _buildCompletedOnlySwitch(),
        ],
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

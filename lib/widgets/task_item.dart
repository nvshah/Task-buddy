import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../data/moor_database.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  
  TaskItem({@required this.task});

  @override
  Widget build(BuildContext context) {
    //we require database instance only to delete task but not to update any things in any specific individual task
    final database = Provider.of<AppDatabase>(context, listen: false);
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: CheckboxListTile(
        value: task.completed,
        onChanged: (newValue){
          database.updateTask(task.copyWith(completed: newValue));
        },
        title: Text(task.name),
        subtitle: Text(task.dueDate?.toString() ?? "No Date"),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: "Delete",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleteTask(task),
        )
      ],
    );
  }
}
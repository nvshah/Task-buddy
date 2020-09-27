import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../data/moor_database.dart';

class TaskItem extends StatelessWidget {
  final TaskWithTag item;

  TaskItem({@required this.item});

  @override
  Widget build(BuildContext context) {
    //we require database instance only to delete task but not to update any things in any specific individual task
    //final database = Provider.of<AppDatabase>(context, listen: false);
    final dao = Provider.of<TaskDao>(context, listen: false);
    
    //Each Task-item is slidable
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: "Delete",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => dao.deleteTask(item.task),
        )
      ],
      child: CheckboxListTile(
        value: item.task.completed,
        title: Text(item.task.name),
        subtitle: Text(item.task.dueDate?.toString() ?? "No Date"),
        secondary: _buildTag(item.tag),
        onChanged: (newValue) {
          dao.updateTask(item.task.copyWith(completed: newValue));
        },
      ),
    );
  }
  
  ///Tag Widget to display UI for Task-Tag
  Column _buildTag(Tag tag) {
    //TAG
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (tag != null) ...[
          //TAG-ICON
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(tag.color),
            ),
          ),
          //TAG-NAME
          Text(
            tag.name,
            style: TextStyle(color: Colors.black.withOpacity(0.5)),
          ),
        ],
      ],
    );
  }
}

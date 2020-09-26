import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';

import '../data/moor_database.dart';

class NewTaskInput extends StatefulWidget {
  const NewTaskInput({
    Key key,
  }) : super(key: key);
  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  DateTime newTaskDate;
  TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }
  
  //Provide Widget for Inputting Text Field
  Expanded buildTextField(BuildContext context){
    return Expanded(
      child: TextField(
        controller: textController,
        decoration: InputDecoration(hintText: 'Task name'),
        onSubmitted: (name){
          //final database = Provider.of<AppDatabase>(context, listen: false);
          final dao = Provider.of<TaskDao>(context);

          //Since id is auto-incrementing We are omitting it
          //Since completed has default value set to false, it's to been omitted
          final task = TasksCompanion(
            name: Value(name),
            dueDate: Value(newTaskDate),
          );
          //insert task in database
          dao.insertTask(task);
          resetValueAfterSubmit();
        },
      ),
    );
  }

  //Reset - Text input Field for new inputs
  void resetValueAfterSubmit(){
    setState(() {
     newTaskDate = null;
     textController.clear(); 
    });
  }
  
  //build date picker that allows you to pick date from
  IconButton buildDateButton(BuildContext context){
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        newTaskDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2050),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //Task Name
          buildTextField(context),
          //Date Picker
          buildDateButton(context),
      ],),
    );
  }
}

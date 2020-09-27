import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

import '../data/moor_database.dart';

class NewTagInput extends StatefulWidget {
   const NewTagInput({
    Key key,
  }) : super(key: key);

  @override
  _NewTagInputState createState() => _NewTagInputState();
}

class _NewTagInputState extends State<NewTagInput> {
  static const Color DEFAULT_COLOR = Colors.lime;

  Color pickedTagColor = DEFAULT_COLOR;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: <Widget>[
        //Tag Name Input
        _buildTextField(context),
        //Color button Input
        _buildColorPickerButton(context),
      ],),
    );
  }
  
  ///Build Text Filed to take name for Color's tag
  Flexible _buildTextField(BuildContext context){
    return Flexible(
      flex: 1,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Tag name'),
        onSubmitted: (inputName){
          final dao = Provider.of<TagDao>(context);
          final tag = TagsCompanion(
            name: Value(inputName),
            color: Value(pickedTagColor.value),
          );
          dao.insertTag(tag);
          resetValuesAfterSubmit();
        },
      ),
    );
  }
  
  ///Color Picker button to ignite ColorPicker Pallete
  Widget _buildColorPickerButton(BuildContext context){
    return Flexible(
      flex: 1,
      child: GestureDetector(
        //Color of Tag
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pickedTagColor,
          ),
        ),
        //Ignite Color Picker Pallete to select color from
        onTap: (){
          _showColorPickerDialog(context);
        },
      ),
    );
  }
  
  ///Allow to select Color from Pallate
  Future _showColorPickerDialog(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: MaterialColorPicker(
            allowShades: false,
            selectedColor: DEFAULT_COLOR,
            onMainColorChange: (colorSwatch){
              setState(() {
               pickedTagColor = colorSwatch; 
              });
              Navigator.of(context).pop();
            },
          ),
        );
      }
    );
  }

  ///Reset values after submitting it
  void resetValuesAfterSubmit() {
    setState(() {
      pickedTagColor = DEFAULT_COLOR;
      controller.clear();
    });
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/moor_database.dart';

class TagsDropdown extends StatelessWidget {
  Tag selectedTag;
  Function selectTagCallBack;

  TagsDropdown({
    @required this.selectTagCallBack,
    @required this.selectedTag,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Tag>>(
        stream: Provider.of<TagDao>(context).watchTags(),
        builder: (context, snapshot) {
          final tags = snapshot.data ?? List();

          return Expanded(
            //Here DropdownButton<T>, T will be decided based on either items or value parameter
            child: DropdownButton(
              onChanged: selectTagCallBack,
              isExpanded: true,
              items: _getDropdownMenuItems(tags),
              value: selectedTag,
            ),
          );
        });
  }

  //get list of items for dropdown menu
  List<DropdownMenuItem<Tag>> _getDropdownMenuItems(List<Tag> tags) {
    return tags.map((tag) => _dropdownItemFromTag(tag)).toList()
      //Add "no tag" item as the first element of the list
      ..insert(
          0,
          DropdownMenuItem(
            value: null,
            child: Text('no tag'),
          ));
  }

  ///Return individual DropDown item for tag
  DropdownMenuItem<Tag> _dropdownItemFromTag(Tag tag) {
    return DropdownMenuItem(
      value: tag,
      //item UI
      child: Row(
        children: <Widget>[
          Text(tag.name),
          SizedBox(
            width: 5.0,
          ),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(tag.color),
            ),
          ),
        ],
      ),
    );
  }
}

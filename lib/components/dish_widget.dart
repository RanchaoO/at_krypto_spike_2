import 'package:chefcookbook/screens/dish_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadWidget extends StatelessWidget {
  final String? content;
  // final String? ingredients;
  // final String? description;
  // final String? imageURL;
  final String? prevScreen;

  UploadWidget({
    @required this.content,
    // @required this.ingredients,
    // @required this.description,
    // @required this.imageURL,
    @required this.prevScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          // leading: SizedBox(
          //   child: this.imageURL == null
          //       ? Image.asset('assets/question_mark.png')
          //       : Image.network(this.imageURL!),
          //   height: 80,
          //   width: 80,
          // ),
          title: Text(
            this.content!,
            style: TextStyle(),
          ),
          // subtitle: Text(
          //   this.description!.length >= 20
          //       ? this.description!.substring(0, 20) + '...'
          //       : this.description!.substring(0, this.description!.length),
          //   style: TextStyle(color: Colors.grey),
          // ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return DishPage(dishWidget: this);
              }));
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class showMessageImgScreen extends StatelessWidget{

  final String imgUrl;
  showMessageImgScreen({required this.imgUrl});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox.expand(
        child: InteractiveViewer(
          child: Image(image: NetworkImage(imgUrl)),
        ),
      ),
    );
  }
}

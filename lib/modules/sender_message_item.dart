
import 'package:barter_it/constants/constants.dart';
import 'package:barter_it/localization/localization_methods.dart';
import 'package:barter_it/models/message_model.dart';
import 'package:barter_it/resources/colors.dart';
import 'package:barter_it/screens/show_image_screen.dart';
import 'package:flutter/material.dart';
class SenderMessageItem extends StatelessWidget {
  const SenderMessageItem({Key? key,required this.message}) : super(key: key);

  final messageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child:message.messageImage==''||message.messageImage==null?
      Container(
          decoration: BoxDecoration(
            color: Colors.orange[300],
            borderRadius: BorderRadiusDirectional.only(
              topStart:Radius.circular(10.0) ,
              bottomStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 15.0,
          ),
          margin: EdgeInsets.only(
              right: LANG=="ar"? MediaQuery.of(context).size.width/5:0,
              left:LANG=="en"? MediaQuery.of(context).size.width/5:0
          ),
          child: Text('${message.text}',style: TextStyle(fontSize: 17,height: 1.5),))
      :Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.orange[300],
          borderRadius: BorderRadiusDirectional.only(
            topStart:Radius.circular(10.0) ,
            bottomStart: Radius.circular(10.0),
            bottomEnd: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 1.0,
          horizontal: 1.0,
        ),
        child:ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            child: Hero(
              tag: message.messageImage!,
              child: Image(
                image: NetworkImage('${message.messageImage}'),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return  Container(
                        height: 200,
                        width: double.infinity,
                        child: Center(
                            child: Text(translate(context,'Loading...')!,style: TextStyle(color: AppColors.black,fontSize: 16,),)
                        )
                    );
                  },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: Text(translate(context,"Some errors occurred! \n Can't load the image ")!,
                      style: TextStyle(color: AppColors.black,fontSize: 16,),
                    ),
                  ),
                ),
              ),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowImageScreen(imageUrl: message.messageImage!),));
            },
          ),
        ),
      ),
    );
  }
}

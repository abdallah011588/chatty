import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/modules/edit_image_screen/edit_image_screen.dart';
import 'package:chat/modules/show_message_img_screen/show_message_img_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var messagecontroller=TextEditingController();

class messagesScreen extends StatelessWidget {


  userModel usermodel;
  messagesScreen({
    required this.usermodel,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context)
        {
          appCubit.get(context).getMessages(receiverId: usermodel.uId);
          return BlocConsumer<appCubit,appStates>(
              listener: (context, state) {},
              builder:(context, state)
              {
                return Scaffold(
                  appBar: AppBar(
                    titleSpacing: 0.0,
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius:25.0,
                          backgroundImage:NetworkImage('${usermodel.image}'),
                        ),
                        SizedBox(width:15.0),
                        Expanded(child: Text('${usermodel.name}',maxLines: 1,overflow: TextOverflow.ellipsis,)),
                      ],
                    ),
                  ) ,
                  body:appCubit.get(context).messages.length> 0 ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                     // key: UniqueKey(),
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index)
                            {
                              var message=appCubit.get(context).messages[index];

                              if(appCubit.get(context).user_model.uId==message.senderId)
                                return senderMessageItem(context,message);
                              else
                                return receiverMessageItem(context,message);
                            },
                            separatorBuilder: (context, index)=>SizedBox(height: 5.0,),
                            itemCount:appCubit.get(context).messages.length,
                          ),
                        ),
                        Row(
                          children: [
                           Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadiusDirectional.circular(15.0),
                                ),
                                child:Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 8.0),
                                  child: TextFormField(
                                    autofocus: true,
                                    keyboardType: TextInputType.text,
                                    controller: messagecontroller,
                                    decoration: InputDecoration(
                                      suffixIcon: InkWell(
                                        onTap: (){
                                         // appCubit.get(context).getMessageImage();

                                          appCubit.get(context).getMessageImage().then((value){
                                          //  if(appCubit.get(context).MessageImage !=null)
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context) =>editImageScreen(image:appCubit.get(context).MessageImage!,model: usermodel),)
                                              ).then((value) {
                                                //Navigator.pop(context);
                                              });
                                          });


                                        },
                                        child: Icon(Icons.add_a_photo_outlined,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                    //  hintText: 'Type your message...',
                                    ),
                                   // onChanged: (v){},
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              height: 50.0,
                              child: MaterialButton(
                                child: Icon(Icons.send_outlined,color: Colors.white,),
                                onPressed: ()
                                {
                                  /*
                                  if(appCubit.get(context).MessageImage==null)
                                  {
                                    if(messagecontroller.text !='')
                                      appCubit.get(context).sendMessage(
                                        receiverId: usermodel.uId,
                                        dateTime: DateTime.now().toString(),
                                        text: messagecontroller.text,
                                        messageImage: '',
                                      );
                                  }
                                  else
                                  {
                                    appCubit.get(context).uploadMessageImage(
                                      receiverId: usermodel.uId,
                                      text: '',
                                      dateTime: DateTime.now().toString(),
                                    );
                                    appCubit.get(context).removeMessageImage();

                                  }*/

                                  if(messagecontroller.text !='') {
                                    appCubit.get(context).sendMessage(
                                      receiverId: usermodel.uId,
                                      dateTime: DateTime.now().toString(),
                                      text: messagecontroller.text,
                                      messageImage: '',
                                    );
                                  /*  for(int i=0;i<appCubit.get(context).usersFriends.length;i++)
                                      {
                                        if(appCubit.get(context).usersFriends[i].uId==usermodel.uId)
                                          {
                                            appCubit.get(context).friendsChat[i]=true;
                                          }
                                      }*/
                                  }
                                  messagecontroller.text='';
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                        :Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column (
                      mainAxisAlignment: MainAxisAlignment.center,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        //Image(image: NetworkImage('https://img.freepik.com/free-vector/cartoon-tiny-people-having-international-communication-online-flat-illustration_74855-16818.jpg?t=st=1648543394~exp=1648543994~hmac=a9ce6e4e938fed3d40bb7602c2c522f7cce678f3030759c4804dfd269cf1cd9d&w=740')),
                       // SizedBox(height: 10.0,),
                        Text('Chat with friends'),
                        Spacer(),
                        Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadiusDirectional.circular(15.0),
                              ),
                              child:Padding(
                                padding: const EdgeInsetsDirectional.only(start: 8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: messagecontroller,
                                  decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: (){
                                        appCubit.get(context).getMessageImage();
                                      },
                                      child: Icon(Icons.add_a_photo_outlined,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Type your message...',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            height: 50.0,
                            child: MaterialButton(
                              child: Icon(Icons.send_outlined,color: Colors.white,),
                              onPressed: (){
                               /* if(messagecontroller.text !='') {
                                  if (appCubit.get(context).MessageImage == null)
                                  {
                                    appCubit.get(context).sendMessage(
                                      receiverId: usermodel.uId,
                                      dateTime: DateTime.now().toString(),
                                      text: messagecontroller.text,
                                      messageImage: '',
                                    );
                                  }
                                  else
                                  {
                                    appCubit.get(context).uploadMessageImage(
                                      receiverId: usermodel.uId,
                                      text: '',
                                      dateTime: DateTime.now().toString(),
                                    );
                                  }
                                }*/

                                if(messagecontroller.text !='')
                                  appCubit.get(context).sendMessage(
                                  receiverId: usermodel.uId,
                                  dateTime: DateTime.now().toString(),
                                  text: messagecontroller.text,
                                  messageImage: '',
                                );
                                messagecontroller.text='';

                              },
                            ),
                          )
                        ],
                        ),

                      ],
                    ),
                  ),

                );
              });
        }
    );
  }
}








/// **************************************************************************
Widget senderMessageItem(context ,messageModel message)
{
  return  Align(
    alignment: AlignmentDirectional.centerEnd,
    child:message.messageImage==''||message.messageImage==null? Container(
        decoration: BoxDecoration(
          color: Colors.teal[200],
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
        child: Text('${message.text}')):
    InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>showMessageImgScreen(imgUrl: message.messageImage),));
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.teal[200],
          borderRadius: BorderRadiusDirectional.only(
            topStart:Radius.circular(10.0) ,
            bottomStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 5.0,
        ),
        child:Image(image: NetworkImage('${message.messageImage}'),
          fit: BoxFit.cover,
        ),
      ),
    ),


  );
}


Widget receiverMessageItem(context,messageModel message)
{
  return  Align(
    alignment: AlignmentDirectional.centerStart,
    child:message.messageImage==''||message.messageImage==null? Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            topStart:Radius.circular(10.0) ,
            bottomEnd: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        child: Text('${message.text}')):
    InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>showMessageImgScreen(imgUrl: message.messageImage),));
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadiusDirectional.only(
            topStart:Radius.circular(10.0) ,
            bottomEnd: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 5.0,
        ),
        child: Image(image: NetworkImage('${message.messageImage}'), fit: BoxFit.cover,),),
    ),
  );
}
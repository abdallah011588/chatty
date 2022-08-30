import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/localization/localization_methods.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/modules/edit_image_screen/edit_image_screen.dart';
import 'package:chat/modules/show_message_img_screen/show_message_img_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var messagecontroller=TextEditingController();

class messagesScreen extends StatelessWidget /* with WidgetsBindingObserver */
{

  userModel usermodel;
  messagesScreen({
    required this.usermodel,
  });

  /*
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state==AppLifecycleState.resumed)
      {
        print('online');
      }
    else
    {
      print('offline');
    }
  }
  */

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
                    leading: IconButton(
                      onPressed:(){
                        print('pop');
                        appCubit.get(context).audioPlayer.stop();
                        appCubit.get(context).recorder.closeRecorder();
                       //messagecontroller.dispose();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    title: Row(
                      children: [
                        InkWell(
                          child: CircleAvatar(
                            radius:25.0,
                            backgroundImage:NetworkImage('${usermodel.image}'),
                          ),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>showMessageImgScreen(imgUrl: usermodel.image),),
                            );
                          },
                        ),
                        SizedBox(width:15.0),
                        Expanded(child: Text('${usermodel.name}',maxLines: 1,overflow: TextOverflow.ellipsis,)),
                      ],
                    ),
                  ) ,
                  body: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        appCubit.get(context).messages.length>0?
                         Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index)
                            {
                              var message=appCubit.get(context).messages[index];

                              if(appCubit.get(context).user_model!.uId==message.senderId)
                                return senderMessageItem(context,message);
                              else
                                return receiverMessageItem(context,message);
                            },
                            separatorBuilder: (context, index)=>SizedBox(height: 5.0,),
                            itemCount:appCubit.get(context).messages.length,
                          ),
                        )
                        :Expanded(child: Container()),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadiusDirectional.circular(15.0),
                                ),
                                child:Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 5.0,end: 5),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: messagecontroller,
                                    decoration: InputDecoration(
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only( left: 5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: ()
                                              {
                                                appCubit.get(context).now_recording(receiverId: usermodel.uId);
                                              },
                                              icon: Icon( appCubit.get(context).recorder.isRecording? Icons.stop:Icons.mic,),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                appCubit.get(context).getMessageImage().then((value){
                                                    if(appCubit.get(context).MessageImage !=null)
                                                    Navigator.push(context, MaterialPageRoute(
                                                      builder: (context) =>editImageScreen(
                                                          image:appCubit.get(context).MessageImage!,
                                                          model: usermodel,
                                                      ),
                                                    ),).then((value) {
                                                      // if(appCubit.get(context).MessageImage !=null)
                                                      //   appCubit.get(context).removeMessageImage();
                                                    });
                                                });
                                              },
                                              child: Icon(Icons.add_a_photo_outlined,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      hintText:getTranslated(context,'Type Message')! ,
                                    ),
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              width: 50,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
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
                                      messageVoice: '',
                                    );

                                    appCubit.get(context).sendNotification(
                                      receiver: usermodel.messagingToken,
                                      title: usermodel.name,
                                      body: messagecontroller.text ,
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
    child:message.messageImage==''||message.messageImage==null?
    (message.messageVoice==''||message.messageVoice==null?
     Container(
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
        margin:getLangCode(context)==ARABIC? EdgeInsets.only(right:100):EdgeInsets.only(left:100),
        child: Text('${message.text}'))
     :Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.teal[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
          appCubit.get(context).url== message.messageVoice?
              Container(
                width:150 ,
                child: Slider(
                  value: appCubit.get(context).voiceProgress(),
                  min: 0,
                  max:appCubit.get(context).audioPlayer.duration ==null? 0
                      :appCubit.get(context).audioPlayer.duration!.inSeconds.toDouble(),
                  onChanged: (v){
                    appCubit.get(context).audioPlayer.seek(Duration(seconds: v.toInt()));
                    },
                ),
              )
              :Container(
            width:150 ,
            child: Slider(
              value: 0,
              min: 0,
              max: 0,
              onChanged: (v){
               // appCubit.get(context).audioPlayer.seek(Duration(seconds: v.toInt()));
              },
            ),
          ),
              IconButton(
                onPressed: (){

                  if(appCubit.get(context).url=='') {
                    appCubit.get(context).url = message.messageVoice;
                    appCubit.get(context).playVoice(/*message.messageVoice*/);
                  }
                  else if(appCubit.get(context).url==message.messageVoice)
                  {
                    appCubit.get(context).playVoice(/*message.messageVoice*/);
                  }

                  else if(appCubit.get(context).url !=message.messageVoice)
                  {
                    appCubit.get(context).audioPlayer.stop();
                    appCubit.get(context).audioPlayer.seek(Duration.zero);
                    appCubit.get(context).url = message.messageVoice;
                    appCubit.get(context).audioPlayer.setUrl(message.messageVoice);
                    appCubit.get(context).playVoice(/*message.messageVoice*/);
                  }

                  /// ///////////
                //   if(appCubit.get(context).url=='') {
                //     appCubit.get(context).url = message.messageVoice;
                //  }
                //   else
                //     {
                //       appCubit.get(context).audioPlayer.stop();
                //       appCubit.get(context).url = message.messageVoice;
                //     }
                // appCubit.get(context).playVoice(/*message.messageVoice*/);
                //
                  },
                icon:appCubit.get(context).url== message.messageVoice?
                Icon(appCubit.get(context).audioPlayerIsPlaying? Icons.pause:Icons.play_arrow ,color: Colors.black)
                :Icon(Icons.play_arrow,color: Colors.black),
              ),
            ],
          ),
          /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text('0:0',style: TextStyle(fontSize: 12),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text('0:29',style: TextStyle(fontSize: 12),),
                        ),
                      ],
                    ),*/
        ],
      ),
    ) )
     :InkWell(
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
    child:message.messageImage==''||message.messageImage==null?
    (message.messageVoice==''||message.messageVoice==null?
    Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            topStart:Radius.circular(10.0) ,
            bottomEnd: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          ),
        ),
        margin:getLangCode(context)==ARABIC? EdgeInsets.only(left:100) : EdgeInsets.only(right:100),
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        child: Text('${message.text}')):
    Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              appCubit.get(context).url== message.messageVoice?
              Container(
                width:150 ,
                child: Slider(
                  value: appCubit.get(context).voiceProgress(),
                  min: 0,
                  max:appCubit.get(context).audioPlayer.duration ==null? 0
                      :appCubit.get(context).audioPlayer.duration!.inSeconds.toDouble(),
                  onChanged: (v){
                    appCubit.get(context).audioPlayer.seek(Duration(seconds: v.toInt()));
                  },
                ),
              )
              :Container(
                width:150 ,
                child: Slider(
                  value: 0,
                  min: 0,
                  max: 0,
                  onChanged: (v){
                   // appCubit.get(context).audioPlayer.seek(Duration(seconds: v.toInt()));
                  },
                ),
              ),
              IconButton(
                onPressed: (){
                  if(appCubit.get(context).url=='') {
                    appCubit.get(context).url = message.messageVoice;
                    appCubit.get(context).playVoice(/*message.messageVoice*/);
                  }
                  else if(appCubit.get(context).url==message.messageVoice)
                  {
                    appCubit.get(context).playVoice(/*message.messageVoice*/);
                  }

                  else if(appCubit.get(context).url !=message.messageVoice)
                  {
                    appCubit.get(context).audioPlayer.stop();
                    appCubit.get(context).audioPlayer.seek(Duration.zero);
                    appCubit.get(context).url = message.messageVoice;
                    appCubit.get(context).audioPlayer.setUrl(message.messageVoice);
                    appCubit.get(context).playVoice(/*message.messageVoice*/);
                  }
                  //appCubit.get(context).url=message.messageVoice;
                },
                icon:appCubit.get(context).url== message.messageVoice?
                Icon(appCubit.get(context).audioPlayerIsPlaying? Icons.pause:Icons.play_arrow,color: Colors.black,)
                :Icon(Icons.play_arrow,color: Colors.black),
              ),
            ],
          ),
          /*  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                              appCubit.get(context).audioPlayer.position.inSeconds.toString(),
                            style: TextStyle(fontSize: 12),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            appCubit.get(context).audioPlayer.duration ==null? '0:0':appCubit.get(context).audioPlayer.duration!.inSeconds.toString(),

                            style: TextStyle(fontSize: 12),),
                        ),
                      ],
                    ),*/
        ],
      ),
    ) )
     :InkWell(
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

//https://console.firebase.google.com/project/chat-8e284/storage/chat-8e284.appspot.com/files/~2Fvoices?hl=ar


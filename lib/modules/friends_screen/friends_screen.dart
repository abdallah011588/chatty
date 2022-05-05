import 'package:chat/layout/chat.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/modules/messages_screen/messages_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class friendsScreen extends StatelessWidget {
  const friendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {

        appCubit.get(context).getFriends();
       // appCubit.get(context).getAllFriends();

        return Scaffold(
          appBar: AppBar(
            title:Text('Friends') ,
          ),
         body:
         appCubit.get(context).usersFriends.length>0?
         Column(
         children: [
                Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => chatsItemBuilder(context, appCubit.get(context).usersFriends[index]),
                  separatorBuilder:(context ,index)=>Padding(
                    padding: const EdgeInsetsDirectional.only(start: 85.0),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color:appCubit.get(context).isdark? Colors.black: Colors.grey[300],
                    ),
                  ),
                  itemCount:appCubit.get(context).usersFriends.length,
                  physics: BouncingScrollPhysics(),
                ),),
         ],
         ):Center(child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text('There is no Friends',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
             ],
           ),),
        );
      },
    );
  }
}

/*
Widget friendRequestsBuilder(context,userModel model)=> Padding(
  padding: const EdgeInsets.all(10.0),
  child:   Row(
    children: [
      CircleAvatar(
        radius: 45.0,
        backgroundImage: NetworkImage('${model.image}'),
      ),
      SizedBox(width: 30.0,),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${model.name}',
              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            //Text('${model.bio}',style: TextStyle(fontSize: 16.0,color: Colors.grey[600]),),
            SizedBox(height: 10.0,),

            Row(
              children: [
                Container (
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: MaterialButton(
                    onPressed: (){

                      appCubit.get(context).acceptFriendRequest(friendId: model.uId);
                    },
                    child: Text('Accept',style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(width: 10.0,),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: MaterialButton(
                    onPressed: (){
                      appCubit.get(context).delRequests(senderId: model.uId);


                      /*
                      appCubit.get(context).usersRequests.forEach((element) {
                        print(element.uId);
                      });


                      appCubit.get(context).senderRequest.forEach((element) {
                        print(element.sendrUid);
                      });*/
                    },
                    child: Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
);
*/

Widget chatsItemBuilder(context,userModel model)=>InkWell(
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => messagesScreen(usermodel: model),));
  },
  child:   Padding(
    padding: const EdgeInsets.all(10.0),
    child:   Row(
      children: [
        CircleAvatar(
          radius: 35.0,
          backgroundImage:  NetworkImage('${model.image}'),//NetworkImage('https://img.freepik.com/free-photo/hacker-with-mask_103577-1.jpg?size=626&ext=jpg&ga=GA1.2.1571019282.1647278978'),
        ),
        SizedBox(width: 10.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${model.name}'
                      ,style: Theme.of(context).textTheme.headline3,//TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Text('${model.bio}',style: Theme.of(context).textTheme.headline2,//TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
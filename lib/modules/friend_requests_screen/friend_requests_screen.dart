import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/request_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/modules/newchat_screen/newchat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class friendRequestsScreen extends StatelessWidget {
  const friendRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        appCubit.get(context).getRequests();
       // appCubit.get(context).getallRequests();

        return Scaffold(
          appBar: AppBar(
            title:Text('Friend requests') ,
          ),
         body:
         appCubit.get(context).usersRequests.length>0?
         Column(
         children: [
                Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => friendRequestsBuilder(context, appCubit.get(context).usersRequests[index]),
                  separatorBuilder:(context ,index)=>Padding(
                    padding: const EdgeInsetsDirectional.only(start: 85.0),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ),
                  itemCount:appCubit.get(context).usersRequests.length,
                  physics: BouncingScrollPhysics(),
                ),),
         ],
         ):Center(child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text('No Friend Request',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
             ],
           ),),
        );
      },
    );
  }
}

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
              style: Theme.of(context).textTheme.headline3,//TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
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

      // Expanded(
      //   child: Container (
      //     height: 40.0,
      //     decoration: BoxDecoration(
      //       color: Colors.blue,
      //       borderRadius: BorderRadius.circular(10.0),
      //     ),
      //       child: MaterialButton(
      //         onPressed: (){},
      //         child: Text('Accept',style: TextStyle(color: Colors.white),),
      //       ),
      //   ),
      // ),
      // SizedBox(width: 10.0,),
      // Expanded(
      //   child: Container(
      //     height: 40.0,
      //     decoration: BoxDecoration(
      //       color: Colors.grey[400],
      //       borderRadius: BorderRadius.circular(10.0),
      //     ),
      //     child: MaterialButton(
      //       onPressed: (){},
      //       child: Text('Delete'),
      //     ),
      //   ),
      // ),
    ],
  ),
);
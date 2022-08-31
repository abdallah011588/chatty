import 'package:chat/layout/chat.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/localization/localization_methods.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/modules/messages_screen/messages_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class friendsScreen extends StatelessWidget {
  const friendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder:(context) {
        appCubit.get(context).getFriends();
        return BlocConsumer<appCubit,appStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
           appBar: AppBar(
              title: Text(getTranslated(context, 'Friends')!,) ,
            ),
           body: appCubit.get(context).friends.length>0?
           Column(
           children: [
               Expanded(
                   child: ListView.separated(
                    itemBuilder: (context, index) => chatsItemBuilder(context, appCubit.get(context).friends[index]),
                    separatorBuilder:(context ,index)=>Padding(
                      padding: const EdgeInsetsDirectional.only(start: 85.0),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color:appCubit.get(context).isdark? Colors.black: Colors.grey[300],
                      ),
                    ),
                    itemCount:appCubit.get(context).friends.length,
                    physics: BouncingScrollPhysics(),
                  ),
                ),
           ],
           )
           :Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                  Text(
                    getTranslated(context, 'No_Friends')!,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
               ],
             ),
           ),
          );
        },
      );
      },
    );
  }
}


Widget chatsItemBuilder(context,userModel model)=>InkWell(
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => messagesScreen(usermodel: model),));
  },
  child:Padding(
    padding: const EdgeInsets.all(10.0),
    child:Row(
      children: [
        CircleAvatar(
          radius: 35.0,
          backgroundImage:  NetworkImage('${model.image}'),
        ),
        const SizedBox(
          width: 10.0,
        ),
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
                      ,style: Theme.of(context).textTheme.headline3,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '${model.bio}',
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
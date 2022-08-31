
import 'package:badges/badges.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/modules/friend_requests_screen/friend_requests_screen.dart';
import 'package:chat/modules/friends_screen/friends_screen.dart';
import 'package:chat/modules/message_voice.dart';
import 'package:chat/modules/messages_screen/messages_screen.dart';
import 'package:chat/modules/search_screen/search_screen.dart';
import 'package:chat/modules/setting_screen/setting_screen.dart';
import 'package:chat/modules/show_message_img_screen/show_message_img_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../localization/localization_methods.dart';

class chatLayout extends StatelessWidget {
  chatLayout({Key? key}) : super(key: key);
  var  scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model=appCubit.get(context).user_model;
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            // leading: IconButton(
            //   onPressed: ()
            //   {
            //     scaffoldKey.currentState!.openDrawer();
            //    // appCubit.get(context).getRequests();
            //   },
            //   icon:const Icon(Icons.menu),
            // ),
            title: Text(
              getTranslated(context, 'Chatty')!,
              style:TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 23.0,
                color: Colors.white,
                fontFamily: 'Galada'
            ),
            ),
            actions: [
              IconButton(
                onPressed: ()
                {
                  showSearch(
                    context: context,
                    delegate: searchDelegate(list: appCubit.get(context).friends),
                  );
                },
                icon:const Icon(Icons.search),
              ),
            ],
          ),
          drawer: Drawer(
            child:appCubit.get(context).user_model !=null?
            ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color:appCubit.get(context).isdark? HexColor('23303F') : Colors.teal,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundImage: NetworkImage(model!.image),
                              ),
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>showMessageImgScreen(imgUrl: model.image),),
                                );
                              },
                            ),
                          //  Spacer(),
                            IconButton(
                                onPressed: (){
                                 appCubit.get(context).changeAppMode();
                                },
                                icon: Icon(
                                  Icons.brightness_4_outlined,
                                  color: appCubit.get(context).isdark? Colors.white:Colors.black,
                                ),
                            ),
                          ],
                        ),
                      ),
                      //Spacer(),
                      Text(
                        model.name,
                        style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5.0,),
                      Text(
                        model.phone,
                        style:const TextStyle(color: Colors.white,fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading:const Icon(Icons.group),
                  title: Text(
                    getTranslated(context, 'Friends')!,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>const friendsScreen(),),
                    );
                  },
                  iconColor: Colors.teal,
                ),
                ListTile(
                  leading:marker >0? Badge(
                    badgeContent: Text(marker.toString(),style: TextStyle(color: Colors.white),),
                    child: Icon(Icons.group_add),
                  )
                      :const Icon(Icons.group_add),
                  title:  Text(
                    getTranslated(context, 'Friends requests')!,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  onTap: () {
                    marker=0;
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>const friendRequestsScreen(),),
                    );
                  },
                  iconColor: Colors.teal,
                ),
                ListTile(
                  leading:const Icon(Icons.save_alt_sharp),
                  title:  Text(
                    getTranslated(context, 'Saved Messages')!,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => voiceMessage(),));
                  },
                  iconColor: Colors.teal,
                ),
                ListTile(
                  leading:const Icon(Icons.settings),
                  title:  Text(
                    getTranslated(context, 'Settings')!,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => settingScreen(),),
                    );
                  },
                  iconColor: Colors.teal,
                ),
                ListTile(
                  leading:const Icon(Icons.info_outline),
                  title:  Text(
                    getTranslated(context, 'About')!,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  onTap: () {},
                  iconColor: Colors.teal,
                ),

              ],
            )
            :Container(),
          ),
          body:appCubit.get(context).user_model !=null?
          (appCubit.get(context).friends.length >0?
          ListView.separated(
            itemBuilder: (context, index) => chatsItemBuilder(context,appCubit.get(context).friends[index]),
            separatorBuilder:(context ,index)=> Padding(
              padding: const EdgeInsetsDirectional.only(start: 80.0),
              child: Container(
                height: 1,
                width: double.infinity,
                color: appCubit.get(context).isdark? Colors.black:Colors.grey[300],
              ),
            ),
            itemCount: appCubit.get(context).friends.length,
            physics:const BouncingScrollPhysics(),
          )
          :Center(child: Text(
              getTranslated(context, 'Add_friends')!,
            style: Theme.of(context).textTheme.bodyText1,
          ),)
          ) :const Center(child: CircularProgressIndicator()),

          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              showSearch(context: context, delegate: newFriendSearchFDelegate(list: appCubit.get(context).users));
            },
            child:const Icon(Icons.person_add_alt_1),
            backgroundColor: Colors.teal,
          ),
        );
      },
    );
  }
}



Widget chatsItemBuilder(context,userModel model)=>InkWell(
  onTap: (){
    appCubit.get(context).getVoiceRecorded();
    Navigator.push(context, MaterialPageRoute(builder: (context) => messagesScreen(usermodel: model),));
      },
  child:   Padding(
    padding: const EdgeInsets.all(10.0),
    child:   Row(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundImage:  NetworkImage(model.image),
        ),
        const SizedBox(width: 10.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text( model.name,
                      style: Theme.of(context).textTheme.headline1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
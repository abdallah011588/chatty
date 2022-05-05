
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/modules/friend_requests_screen/friend_requests_screen.dart';
import 'package:chat/modules/friends_screen/friends_screen.dart';
import 'package:chat/modules/messages_screen/messages_screen.dart';
import 'package:chat/modules/newchat_screen/newchat_screen.dart';
import 'package:chat/modules/search_screen/search_screen.dart';
import 'package:chat/modules/setting_screen/setting_screen.dart';
import 'package:chat/modules/show_message_img_screen/show_message_img_screen.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class chatLayout extends StatelessWidget {
  //const chatLayout({Key? key}) : super(key: key);
  var  scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {

        appCubit.get(context).getFriends();

        var model=null;
         model=appCubit.get(context).user_model;

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            //backgroundColor: Colors.teal,
            leading: IconButton(
              onPressed: ()
              {
                scaffoldKey.currentState!.openDrawer();
               // appCubit.get(context).getRequests();
              },
              icon:Icon(Icons.menu),
            ),
            title: Text('Chat',style:TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white
            )),
            actions: [
              IconButton(
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => searchScreen(),));
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color:appCubit.get(context).isdark? HexColor('23303F') :Colors.teal,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            child: CircleAvatar(
                              radius: 40.0,
                            backgroundImage: NetworkImage('${model.image}'),
                            //  backgroundImage: NetworkImage('https://img.freepik.com/free-photo/hacker-with-mask_103577-1.jpg?size=626&ext=jpg&ga=GA1.2.1571019282.1647278978'),
                            ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>showMessageImgScreen(imgUrl: '${model.image}'),));
                            },
                          ),
                          Spacer(),
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
                      Spacer(),
                      Expanded(
                        child: Text(
                          '${model.name}',
                          style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0),
                          maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Text('${model.phone}',style: TextStyle(color: Colors.white,fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.group),
                  title:  Text('Friends',style: Theme.of(context).textTheme.headline3,),
                  onTap: () {
                   // appCubit.get(context).getFriends();
                    //appCubit.get(context).getAllFriends();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => friendsScreen(),));
                  },
                  iconColor: Colors.teal,
                ),
                ListTile(
                  leading: Icon(Icons.group_add),
                  title:  Text('Friend requests' ,style: Theme.of(context).textTheme.headline3,),
                  onTap: () {

                    // appCubit.get(context).getRequests();
                    // appCubit.get(context).getallRequests();
                    // appCubit.get(context).usersRequests.forEach((element) {
                    //   print(element.uId);
                    // });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => friendRequestsScreen(),));
                  },
                  iconColor: Colors.teal,
                ),
                ListTile(
                  leading: Icon(Icons.save_alt_sharp),
                  title:  Text('Saved Messages',style: Theme.of(context).textTheme.headline3,),
                  onTap: () {
                  },
                  iconColor: Colors.teal,
                ),
                ListTile(
                  leading: Icon(Icons.call),
                  title:  Text('Calls',style: Theme.of(context).textTheme.headline3,),
                  onTap: () {
                  },
                  iconColor: Colors.teal,
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title:  Text('Settings',style: Theme.of(context).textTheme.headline3,),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => settingScreen(),));
                  },
                  iconColor: Colors.teal,
                ),
              ],
            ),
          ),
          body: ListView.separated(
            itemBuilder: (context, index) => chatsItemBuilder(context,appCubit.get(context).usersFriends[index]),
            separatorBuilder:(context ,index)=>Padding(
              padding: const EdgeInsetsDirectional.only(start: 80.0),
              child: Container(
                height: 1,
                width: double.infinity,
                color: appCubit.get(context).isdark? Colors.black:Colors.grey[300],
              ),
            ),
            itemCount: appCubit.get(context).usersFriends.length,
            physics: BouncingScrollPhysics(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => newChatScreen(),));
            },
            child: Icon(Icons.person_add_alt_1),
            backgroundColor: Colors.teal,
          ),
        );
      },
    );
  }
}




Widget chatsItemBuilder(context,userModel model)=>InkWell(
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => messagesScreen(usermodel: model),));
      },
  child:   Padding(
    padding: const EdgeInsets.all(10.0),
    child:   Row(
      children: [
        CircleAvatar(
          radius: 30.0,
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
                      '${model.name}',
                      style: Theme.of(context).textTheme.headline1,//TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                    ),
                  ),
                 // Spacer(),
                  Text(

                     // appCubit.get(context).getMessages(receiverId: );
                     appCubit.get(context).messages.length-1 >0?
                    //  '${DateFormat.yMMMd().format(appCubit.get(context).messages[ appCubit.get(context).messages.length-1].dateTime as DateTime)}'
                     '${appCubit.get(context).messages[ appCubit.get(context).messages.length-1].dateTime}'
                         : '',
                    //'12:15 AM',
                    style: Theme.of(context).textTheme.headline2,//TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Text(
                appCubit.get(context).messages.length-1 >0?
                '${appCubit.get(context).messages[ appCubit.get(context).messages.length-1].text}'
                :'',
                //'Hello bro ,How are you ?',
                style: Theme.of(context).textTheme.headline2,//TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
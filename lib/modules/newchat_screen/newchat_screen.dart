import 'package:chat/layout/chat.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class newChatScreen extends StatelessWidget {
  var searchController=TextEditingController();
  //userModel? searchedUser;

  //const newChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return  Scaffold(
          appBar: AppBar(
            title:Text('Add new chat') ,
          ),
          body:Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return 'can not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Search by email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                        child: IconButton(
                          onPressed: ()
                          {
                            appCubit.get(context).getSearchedUser(email: searchController.text);
                         /*   appCubit.get(context).users.forEach((element) {
                              if(element.email==searchController.text)
                                {
                                  searchedUser=element;
                                  print(searchedUser!.email);
                                }
                            });
                            */
                          },
                            icon: Icon(Icons.search),
                        ),
                    ),
                  ],
                ),
              ),
              if( appCubit.get(context).searchedUser !=null)
              addNewChatsBuilder(context, appCubit.get(context).searchedUser!),
            ],),
        );
      },
    );
  }
}



Widget addNewChatsBuilder(context,userModel model)=> InkWell(
  onTap: (){
   // Navigator.push(context, MaterialPageRoute(builder: (context) => messagesScreen(),));
  },
  child:   Padding(
    padding: const EdgeInsets.all(10.0),
    child:   Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundImage:  NetworkImage('${model.image}'),
        ),
        SizedBox(width: 5.0,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.name}',
                style:  Theme.of(context).textTheme.headline1,//TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: 10.0,),
              Text(
                '${model.bio}',
                style:Theme.of(context).textTheme.headline2,// TextStyle(fontSize: 16.0,color: Colors.grey[600],overflow: TextOverflow.ellipsis),
              ),
            ],

          ),
        ),
        IconButton(
          onPressed: (){
            appCubit.get(context).sendFriendRequest(receiverId: model.uId);
          },
          icon: Icon(
              Icons.person_add,
            color: appCubit.get(context).isdark?Colors.white:Colors.black,
          ),
        ),

        /*appCubit.get(context).requested? IconButton(
          onPressed: (){
           // appCubit.get(context).sendFriendRequest(receiverId: model.uId);
          },
          icon: Icon(Icons.check,color: Colors.blue,),
        ): */
      ],
    ),
  ),
);
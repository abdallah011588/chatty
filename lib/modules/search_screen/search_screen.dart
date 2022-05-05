import 'package:chat/layout/chat.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/modules/newchat_screen/newchat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class searchScreen extends StatelessWidget {

  var controller=TextEditingController();

  //const searchScreen({Key? key}) : super(key: key);

  userModel ?model;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('search')),
          body: Column(
            children: [

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.text,
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return 'can not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                 // SizedBox(width: 5.0,),

                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 8.0,bottom:  8.0,end:  8.0),
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: IconButton(
                        onPressed: ()
                        {
                          appCubit.get(context).getSearchedFriend(name: controller.text);
                        //  model=appCubit.get(context).getSearchedFriendList[0];
                           /* appCubit.get(context).users.forEach((element) {
                                if(element.email==searchController.text)
                                  {
                                    searchedUser=element;
                                    print(searchedUser!.email);
                                  }
                              });*/

                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),

            //  if(model !=null)
              if(appCubit.get(context).searchedFriend !=null)
                chatsItemBuilder(context, appCubit.get(context).searchedFriend!),
              /* Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => chatsItemBuilder(context,appCubit.get(context).searchedFriend!),
                  separatorBuilder:(context ,index)=>Padding(
                    padding: const EdgeInsetsDirectional.only(start: 85.0),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ),
                  itemCount: appCubit.get(context).usersFriends.length,
                  physics: BouncingScrollPhysics(),
                ),
              ),*/
            ],
          ),
        ) ;
      },
    );
  }
}

import 'package:chat/layout/chat.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/modules/messages_screen/messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class searchScreen extends StatelessWidget {

  var controller=TextEditingController();

  userModel? model;
  @override
  Widget build(BuildContext context) {
    controller.dispose();
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('search')),
          body: SingleChildScrollView(
            child: Column(
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
                            /// NEW ///////
                            appCubit.get(context).getSpecificUser(name: controller.text);
                          },
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
             if(appCubit.get(context).specificUser.length>0)
             ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder:(context, index) => chatsItemBuilder(context, appCubit.get(context).specificUser[index]) ,
              separatorBuilder:(context, index) {
                return Container(
                height: 1,
                width: double.infinity,
               color: Colors.grey[400],
                );
              } ,
             itemCount: appCubit.get(context).specificUser.length,
            ),

              ],
            ),
          ),
        ) ;
      },
    );
  }
}




class searchDelegate extends  SearchDelegate<String>
{

  final List<userModel> list;
  searchDelegate({required this.list,});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query='';
        },
        icon:const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
     return IconButton(
        onPressed: (){
          close(context, 'Close');
        },
        icon:const Icon(Icons.arrow_back),
      );
  }

  @override
  Widget buildResults(BuildContext context) {
   var resultList = query.isEmpty? []
       :list.where((element) => element.name.contains(query)).toList();
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 10.0),
       child: ListView.separated(
         itemBuilder: (context, index) {
           return InkWell(
             onTap: (){
               Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => messagesScreen(usermodel: resultList[index]),),
               );
             },
             child: Padding(
               padding: const EdgeInsets.symmetric(vertical: 10.0),
               child: ListTile(
                 leading: CircleAvatar(
                   radius: 30.0,
                   backgroundImage: NetworkImage(resultList[index].image),
                 ),
                 title:Text(
                   resultList[index].name,
                 ),
               ),
             ),
           );
         },
         separatorBuilder:(context, index)=> Padding(
           padding: const EdgeInsetsDirectional.only(start: 40.0,),
           child: Container(
             height: 1,
             width: double.infinity,
             color: appCubit.get(context).isdark? Colors.black:Colors.grey[300],
           ),
         ),
         itemCount: resultList.length,
       ),
     );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    var searchList= query.isEmpty? []
        :list.where((element) => element.name.contains(query)).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.separated(
        itemBuilder: (context, index)=> InkWell(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => messagesScreen(usermodel: searchList[index]),),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(searchList[index].image),
              ),
              title:Text(
                searchList[index].name,
              ),
            ),
          ),
        ),
        separatorBuilder:(context, index)=> Padding(
          padding: const EdgeInsetsDirectional.only(start: 40.0,),
          child: Container(
            height: 1,
            width: double.infinity,
            color: appCubit.get(context).isdark? Colors.black:Colors.grey[300],
          ),
        ),
        itemCount: searchList.length,

      ),
    );
  }


  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color:appCubit.get(context).isdark? Colors.white:Colors.black,
        ),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        subtitle1: TextStyle(
          color:appCubit.get(context).isdark? Colors.white:Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 17,
        )
      ),
    );
  }

}




class newFriendSearchFDelegate extends  SearchDelegate<String>
{

  final List<userModel> list;
  newFriendSearchFDelegate({required this.list,});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query='';
        },
        icon:const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, 'Close');
      },
      icon:const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    List<userModel> resultList = query.isEmpty? [] : list.where((element) => element.name.contains(query)).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.separated(

        itemBuilder: (context, index)
        {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(resultList[index].image),
              ),
              title:Text(
                resultList[index].name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle:Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  resultList[index].bio,
                  maxLines: 2,
                  style:Theme.of(context).textTheme.subtitle2!.copyWith(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.grey
                  ),
                ),
              ),
              trailing:appCubit.get(context).searchCheck(resultList[index]),
            ),
          );
        },
        separatorBuilder:(context, index)=> Padding(
          padding: const EdgeInsetsDirectional.only(start: 40.0,),
          child: Container(
            height: 1,
            width: double.infinity,
            color: appCubit.get(context).isdark? Colors.black:Colors.grey[300],
          ),
        ),
        itemCount: resultList.length,
      ),
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {

    var searchList= query.isEmpty? []
        :list.where((element) => element.name.contains(query)).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.separated(
        itemBuilder: (context, index)=> Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(searchList[index].image),
            ),
            title:Text(
              searchList[index].name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle:Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                searchList[index].bio,
                maxLines: 2,
                style:Theme.of(context).textTheme.subtitle2!.copyWith(
                overflow: TextOverflow.ellipsis,
                  color: Colors.grey,
                ),
              ),
            ),
            trailing:appCubit.get(context).searchCheck(searchList[index]),
          ),
        ),
        separatorBuilder:(context, index)=> Padding(
          padding: const EdgeInsetsDirectional.only(start: 40.0,),
          child: Container(
            height: 1,
            width: double.infinity,
            color: appCubit.get(context).isdark? Colors.black:Colors.grey[300],
          ),
        ),
        itemCount: searchList.length,
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color:appCubit.get(context).isdark? Colors.white:Colors.black,
        ),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
          subtitle1: TextStyle(
            color:appCubit.get(context).isdark? Colors.white:Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          )
      ),
    );
  }

}





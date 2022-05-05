import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/modules/login_screen/login_screen.dart';
import 'package:chat/modules/messages_screen/messages_screen.dart';
import 'package:chat/modules/show_image_screen/show_image_screen.dart';
import 'package:chat/modules/show_message_img_screen/show_message_img_screen.dart';
import 'package:chat/modules/update_fields_screen/update_fields_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class settingScreen extends StatelessWidget
{
  //const settingScreen({Key? key}) : super(key: key);

  var namecontroller=TextEditingController();
  var phonecontroller=TextEditingController();
  var biocontroller=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {

      },
      builder: (context, state) {

        var usermodel=appCubit.get(context).user_model;

        namecontroller.text=usermodel.name;
        phonecontroller.text=usermodel.phone;
        biocontroller.text=usermodel.bio;

        return Scaffold(

          appBar: AppBar(
            actions: [
              IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
            ],
            elevation: 0.0,
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120.0,
                  width: double.infinity,
                  color:appCubit.get(context).isdark? HexColor('23303F'): Colors.teal,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 15.0,bottom: 5),
                    child: Row(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            InkWell(
                              child: Align(
                                child: CircleAvatar(
                                  radius: 50.0,
                                 backgroundImage: NetworkImage('${usermodel.image}') ,//:FileImage(appCubit.get(context).Image!) as ImageProvider,
                                ),
                                alignment: AlignmentDirectional.topStart,
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>showMessageImgScreen(imgUrl: '${usermodel.image}'),));
                              },
                            ),
                            IconButton(
                              onPressed: (){

                                showDialog<String>(
                                    context: context,
                                    builder:(BuildContext context)=>AlertDialog(
                                      title: Text('Select Image',style: Theme.of(context).textTheme.headline3,),
                                      content: Text('Select Image or catch it from camera',style: Theme.of(context).textTheme.headline2,),
                                      actions: <Widget>[
                                        TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
                                        IconButton(
                                            onPressed: (){
                                              appCubit.get(context).getImageFromCamera();
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => showImageScreen(image:appCubit.get(context).Image!),)).then((value) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            icon: Icon(
                                                Icons.camera_alt_outlined,
                                              color: appCubit.get(context).isdark? Colors.white:Colors.black,
                                            ),
                                        ),
                                        IconButton(
                                            onPressed: (){
                                              appCubit.get(context).getImage().then((value) {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => showImageScreen(image:appCubit.get(context).Image!),)).then((value) {
                                                  Navigator.pop(context);
                                                });
                                              });
                                            },
                                            icon: Icon(
                                                Icons.image_outlined,
                                              color: appCubit.get(context).isdark? Colors.white:Colors.black,

                                            ),
                                        ),
                                      ],
                                    ), );
                              /*  if(state is appGetImageSuccessState)
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => showImageScreen(image:appCubit.get(context).Image!),));
                                  }*/
                              },
                              icon: CircleAvatar(
                                backgroundColor:Colors.white ,
                                  child: Icon(Icons.add_a_photo_rounded,color: Colors.blue,),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10.0,),
                        Expanded(
                          child: Text('${usermodel.name}',
                              style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white,overflow: TextOverflow.ellipsis,),
                             // overflow: TextOverflow.ellipsis,
                              maxLines: 2
                          ),
                        ),
                     //   Spacer(),
                      ],),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Account',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.blue)),
                      ),

                      InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => updateFields(title:'User Name',field: usermodel.name),));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                                    child: Text('${usermodel.name}',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey)),
                                  ),
                                ),
                              ),
                              Icon(Icons.edit,size: 18,color: Colors.blue,),
                            ],
                          )),

                      Container(
                        height: 1,
                        width: double.infinity,
                        color:appCubit.get(context).isdark? Colors.black: Colors.grey[300],
                      ),

                      InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => updateFields(title:'Phone',field:usermodel.phone),));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                                      child: Text('${usermodel.phone}',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey)),
                                    )),
                              ),
                              Icon(Icons.edit,size: 18,color: Colors.blue,),

                            ],
                          ),
                      ),

                      Container(
                        height: 1,
                        width: double.infinity,
                        color:appCubit.get(context).isdark? Colors.black: Colors.grey[300],
                      ),

                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => updateFields(title:'Bio',field: usermodel.bio),));
                        },
                          child:Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                                      child: Text('${usermodel.bio}',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey)),
                                    )),
                              ),
                              Icon(Icons.edit,size: 18,color: Colors.blue,),
                            ],
                          ),
                      ),

                    ],
                  ),
                ),

                Container(
                  height: 20,
                  width: double.infinity,
                  color:appCubit.get(context).isdark?HexColor('151E27'): Colors.grey[300],
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Settings',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.blue)),
                      SizedBox(height: 10.0,),
                      Container(
                          height: 40.0,width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(10.0),

                          ),
                          child: MaterialButton(
                            onPressed: (){
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Log out'),
                                  content: const Text('Are you sure to log out ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        //cache.removeData(key: 'uId').then((value) {
                                          print(uId +'in setting 1');
                                          print(appCubit.get(context).user_model.uId +'in setting user_model.uId1');
                                          appCubit.get(context).signOut();
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => loginScreen()), (route) => false);//context, MaterialPageRoute(builder: MaterialPageRoute(builder: (context) => loginScreen(),),);
                                       // }).catchError((onError){});
                                        //cache.prefs.
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text('Log out',style: TextStyle(color: Colors.white),),)
                      ),
                      SizedBox(height: 10.0,),
                      Text('About us',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),





        );
      },
    );
  }
}

/*
Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
*/


/*
                      SizedBox(height: 10.0,),
                      Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                       // mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: namecontroller,
                              keyboardType: TextInputType.name,
                              validator: (value){
                                if(value!.isEmpty)
                                {
                                  return 'can not be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0,),
                          TextButton(onPressed: (){}, child: Text('update'))
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Expanded(
                             child: TextFormField(
                               controller: phonecontroller,
                               keyboardType: TextInputType.phone,
                               validator: (value){
                                 if(value!.isEmpty)
                                 {
                                   return 'can not be empty';
                                 }
                                 return null;
                               },
                               decoration: InputDecoration(
                                 labelText: 'Phone',
                                 border: OutlineInputBorder(),
                                 prefixIcon: Icon(Icons.phone),
                               ),
                             ),
                           ),
                          SizedBox(width: 5.0,),
                          TextButton(onPressed: (){}, child: Text('update'))
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: biocontroller,
                              keyboardType: TextInputType.text,
                              validator: (value){
                                if(value!.isEmpty)
                                {
                                  return 'can not be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Bio',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.text_fields),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0,),
                         TextButton(onPressed: (){

                           Navigator.push(context, MaterialPageRoute(builder: (context) => updateFields(),));
                         }, child: Text('update')),
                        ],
                      ),
                      */

/*ListView( children: [
                      ListTile(
                          onTap: (){},
                        title: Text('Account',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.blue)),
                      ),
                    ],
                  ) ,*/
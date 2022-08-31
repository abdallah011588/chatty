import 'package:chat/lang_models/language.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/localization/localization_methods.dart';
import 'package:chat/main.dart';
import 'package:chat/modules/login_screen/login_screen.dart';
import 'package:chat/modules/show_image_screen/show_image_screen.dart';
import 'package:chat/modules/show_message_img_screen/show_message_img_screen.dart';
import 'package:chat/modules/update_fields_screen/update_fields_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class settingScreen extends StatelessWidget
{
  settingScreen({Key? key}) : super(key: key);

  var nameController=TextEditingController();
  var phoneController=TextEditingController();
  var bioController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var usermodel=appCubit.get(context).user_model;
        nameController.text=usermodel!.name;
        phoneController.text=usermodel.phone;
        bioController.text=usermodel.bio;
        return Scaffold(

          appBar: AppBar(
            actions: [
              Padding(
                padding: EdgeInsets.all(15),
                child: DropdownButton(
                    underline: SizedBox(),
                    icon: Icon(
                      Icons.language_outlined,
                      color:appCubit.get(context).isdark? Colors.white:Colors.white,
                    ),
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                          value: lang,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                lang.flag,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(lang.name,
                              style: TextStyle(color: Colors.black,),
                              ),
                            ],
                          ),
                        )).toList(),
                    onChanged: (value){
                      Language lang=value as Language;
                      _changeLanguage(lang,context);
                      // print(lang.name);
                      //print(lang.languageCode);
                    }
                ),
              )
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
                                 backgroundImage: NetworkImage(usermodel.image) ,//:FileImage(appCubit.get(context).Image!) as ImageProvider,
                                ),
                                alignment: AlignmentDirectional.topStart,
                              ),
                              onTap: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>showMessageImgScreen(imgUrl:usermodel.image),),
                                );
                              },
                            ),
                            IconButton(
                              onPressed: (){
                                showDialog<String>(
                                    context: context,
                                    builder:(BuildContext context)=>AlertDialog(
                                      title: Text(getTranslated(context,'Image_select')! ,style: Theme.of(context).textTheme.headline3,),
                                      content: Text(getTranslated(context, 'Image_ensure')!,style: Theme.of(context).textTheme.headline2,),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: (){Navigator.pop(context);},
                                          child: Text(getTranslated(context, 'Cancel')!),
                                        ),
                                        IconButton(
                                            onPressed: (){
                                              appCubit.get(context).getImageFromCamera().then((value) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => showImageScreen(image:appCubit.get(context).Image!),),
                                                ).then((value) {
                                                  Navigator.pop(context);
                                                });
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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => showImageScreen(image:appCubit.get(context).Image!),),
                                                ).then((value) {
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
                              icon:const CircleAvatar(
                                backgroundColor:Colors.white ,
                                  child: Icon(Icons.add_a_photo_rounded,color: Colors.blue,),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10.0,),
                        Expanded(
                          child: Text( usermodel.name,
                              style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white,overflow: TextOverflow.ellipsis,),
                             // overflow: TextOverflow.ellipsis,
                              maxLines: 2
                          ),
                        ),
                      ],),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Padding(
                        padding:  EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                            getTranslated(context, 'Account')!,
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.blue),
                        ),
                      ),
                      InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => updateFields(title:'User Name',field: usermodel.name),),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Text(
                                      usermodel.name,
                                      style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey),
                                  ),
                                ),
                              ),
                              const Icon(Icons.edit,size: 20,color: Colors.blue,),
                            ],
                          )),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color:appCubit.get(context).isdark? Colors.black: Colors.grey[300],
                      ),
                      InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => updateFields(title:'Phone',field:usermodel.phone),),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Text(usermodel.phone,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey)),
                                ),
                              ),
                              const Icon(Icons.edit,size: 20,color: Colors.blue,),

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
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => updateFields(
                                  title:'Bio',//getTranslated(context,'Bio')!,
                                  field: usermodel.bio),
                              ),
                          );
                        },
                          child:Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Text(usermodel.bio,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey)),
                                ),
                              ),
                              const Icon(Icons.edit,size: 20,color: Colors.blue,),
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  width: double.infinity,
                  color:appCubit.get(context).isdark? HexColor('151E27'): Colors.grey[300],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                      getTranslated(context, 'Settings')!,
                         style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.blue),
                      ),
                      const SizedBox(height: 10.0,
                      ),
                      Container(
                          height: 40.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: MaterialButton(
                            onPressed: (){
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title:  Text(getTranslated(context, 'Log out')!,),
                                  content: Text(getTranslated(context, 'ensure')!,),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context,'Cancel'),
                                      child: Text(getTranslated(context, 'Cancel')!,),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        cache.setData(key: 'isLogin', value: false).then((value) {
                                         cache.removeData(key: 'uId',).then((value) {
                                           uId='';
                                           appCubit.get(context).signOut();
                                           Navigator.pushAndRemoveUntil(
                                             context,
                                             MaterialPageRoute(builder: (context) => loginScreen()), (route) => false,
                                           );
                                         });

                                        });

                                      },
                                      child: Text(getTranslated(context,'Ok')!,),
                                    ),
                                  ],
                                ),
                              );
                            },
                           child: Text(
                             getTranslated(context, 'Log out')!,
                              style: TextStyle(color: Colors.white),),
                         ),
                      ),
                      const SizedBox(height: 10.0,),
                       Text(
                         getTranslated(context, 'About us')!,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey),
                      ),
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

void _changeLanguage(Language lang ,context) async
{
  Locale _temp = await setLocale(lang.languageCode);
  MyApp.setLocale( context, _temp);
}

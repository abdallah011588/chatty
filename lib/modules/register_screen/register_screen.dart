import 'package:chat/layout/chat.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/localization/localization_methods.dart';
import 'package:chat/modules/login_screen/login_screen.dart';
import 'package:chat/modules/register_screen/register_cubit/register_cubit.dart';
import 'package:chat/modules/register_screen/register_cubit/register_states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class register_screen extends StatelessWidget{
  register_screen({Key? key}) : super(key: key);

  var formKey=GlobalKey<FormState>();

  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var phoneController=TextEditingController();
  var passwordController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => registerCubit(),
      child: BlocConsumer<registerCubit,registerStates>(
        listener: (context, state) {
        // if(state is createUserSuccessState)
        // {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => loginScreen(),));
        // }

        if(state is createUserSuccessState){
          uId=state.uId;
          cache.setData( key: 'uId', value: state.uId ).then((value) {
            appCubit.get(context).getUserData();
            appCubit.get(context).getAllUsers();
            cache.setData(key: 'isLogin', value: true).then((value) {
              appCubit.get(context).getFriends();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => chatLayout(),),
                      (route) => false
              );
            });
            print(state.uId +'in login state.uid tap');
            Fluttertoast.showToast(
              msg: getTranslated(context,'Sign_success')!,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              timeInSecForIosWeb: 5,
              toastLength: Toast.LENGTH_LONG,
            );

          }).catchError((error){
            print(error.toString());
          });

        }
        if(state is createUserErrorState){
          Fluttertoast.showToast(
            msg: '${
                state.error.toString().contains('[firebase_auth/email-already-in-use]')?
                state.error.toString().replaceAll('[firebase_auth/email-already-in-use]', '')
                : state.error.toString().replaceAll('[firebase_auth/weak-password]', '')
            }',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 5,
            toastLength: Toast.LENGTH_LONG,
          );
        }

        } ,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(getTranslated(context,'Register')!,),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Padding(
                           padding: const EdgeInsets.all(5.0),
                           child: Text(
                             getTranslated(context,'Register')!,
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: appCubit.get(context).isdark?Colors.white70:Colors.black,
                            ),
                        ),
                         ),
                        const SizedBox(height: 15.0,),
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value){
                            if(value!.isEmpty)
                              {
                                return getTranslated(context,'Name_empty')!;
                              }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: getTranslated(context,'Name')!,
                            labelStyle: TextStyle(
                              color:appCubit.get(context).isdark?Colors.white70:Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: appCubit.get(context).isdark?Colors.white70:Colors.black,
                                width: 1.0,
                              ),
                            ),
                            prefixIcon: Icon(
                                Icons.person_outline,
                              color:Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return getTranslated(context,'Email_empty')!;
                            }
                            else if(!value.contains('@'))
                            {
                              return getTranslated(context,'Email_format')!;
                            }
                            return null;
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: getTranslated(context,'Email_add')!,
                            labelStyle: TextStyle(
                              color:appCubit.get(context).isdark?Colors.white70:Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: appCubit.get(context).isdark?Colors.white70:Colors.black,
                                width: 1.0,
                              ),
                            ),
                            prefixIcon: Icon(
                                Icons.email_outlined,
                              color:Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return  getTranslated(context,'Phone_empty')!;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context,'Phone')!,
                            labelStyle: TextStyle(
                              color:appCubit.get(context).isdark?Colors.white70:Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: appCubit.get(context).isdark?Colors.white70:Colors.black,
                                width: 1.0,
                              ),
                            ),
                            prefixIcon: Icon(
                                Icons.phone_outlined,
                              color:Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return  getTranslated(context,'Password_empty')!;
                            }
                            else if(value.length<6)
                            {
                              return getTranslated(context,'Password_less')!;
                            }
                            return null;
                          },
                          obscureText: registerCubit.get(context).IsPass,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText:  getTranslated(context,'Password')!,
                            labelStyle: TextStyle(
                              color:appCubit.get(context).isdark?Colors.white70:Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: appCubit.get(context).isdark?Colors.white70:Colors.black,
                                width: 1.0,
                              ),
                            ),
                            prefixIcon: Icon(
                                Icons.lock_outlined,
                              color:Theme.of(context).iconTheme.color,
                            ),
                            suffixIcon: IconButton(
                              onPressed: ()
                              {
                                registerCubit.get(context).showPassword();
                              },

                              icon: registerCubit.get(context).IsPass?
                               Icon(
                                   Icons.visibility_outlined,
                                 color:Theme.of(context).iconTheme.color,
                               )
                              : Icon(
                                  Icons.visibility_off_outlined,
                                color:Theme.of(context).iconTheme.color,
                              ),
                            ),

                          ),
                        ),
                        const SizedBox(height: 15.0,),
                        Container(
                            height: 50.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: state is! registerLoadingState? MaterialButton(
                                onPressed: (){
                                  if(formKey.currentState!.validate())
                                    {
                                      registerCubit.get(context).userRegister(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          phone: phoneController.text,
                                      );
                                       print('register');
                                    }
                                },
                                child:Text(
                                  getTranslated(context,'Register_new')!,
                                  style: TextStyle(color: Colors.white),))
                               :const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

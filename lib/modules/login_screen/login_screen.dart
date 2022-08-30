import 'package:chat/layout/chat.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/localization/localization_methods.dart';
import 'package:chat/modules/login_screen/login_cubit/login_cubit.dart';
import 'package:chat/modules/login_screen/login_cubit/login_states.dart';
import 'package:chat/modules/register_screen/register_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class loginScreen extends StatelessWidget{
  loginScreen({Key? key}) : super(key: key);

  var formKey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginCubit(),
      child: BlocConsumer<loginCubit,loginStates>(
        listener: (context, state){

          if(state is loginSuccessState){
               uId= state.uId ;
              cache.setData(key: 'uId', value: state.uId).then((value) {
                appCubit.get(context).getUserData();
                appCubit.get(context).getAllUsers();
                appCubit.get(context).getFriends();
                cache.setData(key: 'isLogin', value: true).then((value) {
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
          if(state is loginErrorState){
                Fluttertoast.showToast(
                  msg: '${
                      state.error.toString().contains('[firebase_auth/user-not-found]')?
                      state.error.toString().replaceAll('[firebase_auth/user-not-found]', '')
                          : state.error.toString().replaceAll('[firebase_auth/wrong-password]', '')
                  }',
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  timeInSecForIosWeb: 5,
                  toastLength: Toast.LENGTH_LONG,
                );
              }
          },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(getTranslated(context,'Sign_in')!,),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child:Center(
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
                             getTranslated(context,'Sign_in')! ,
                            style:Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 25,
                              color:appCubit.get(context).isdark?Colors.white70:Colors.black,
                            ) ,
                        ),
                         ),
                        const SizedBox(height: 15.0,),
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
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText:  getTranslated(context,'Email_add')!,
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
                            labelStyle: TextStyle(
                              color:appCubit.get(context).isdark?Colors.white70:Colors.black,
                            )
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return getTranslated(context,'Password_empty')!;
                            }
                            else if(value.length<6)
                            {
                              return getTranslated(context,'Password_less')!;
                            }
                            return null;
                          },
                          obscureText: loginCubit.get(context).IsPass,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText:  getTranslated(context,'Password')!,
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
                              Icons.lock_outline,
                              color:Theme.of(context).iconTheme.color,
                            ),
                              labelStyle: TextStyle(
                                color:appCubit.get(context).isdark?Colors.white70:Colors.black,
                              ),
                              suffixIcon: IconButton(
                               onPressed: ()
                                {
                                loginCubit.get(context).showPassword();
                                },
                               icon: loginCubit.get(context).IsPass?
                                Icon(
                                  Icons.visibility_outlined,
                                  color:Theme.of(context).iconTheme.color,
                                )
                               :Icon(
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
                          child:state is! loginLoadingState?
                            MaterialButton(
                              onPressed: (){
                                if(formKey.currentState!.validate())
                                {
                                  loginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                  );
                                }
                              },
                              child: Text(
                                getTranslated(context,'Sign_in')!,
                                style: TextStyle(color: Colors.white),),
                          )
                           :const Center(child: CircularProgressIndicator(color: Colors.white,)),
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getTranslated(context,'have_no_account')!,
                              style: TextStyle(
                                color: appCubit.get(context).isdark?Colors.white70:Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5.0,),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => register_screen(),),
                                  );
                                },
                                child: Text( getTranslated(context,'Register')!,),
                            ),
                          ],
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

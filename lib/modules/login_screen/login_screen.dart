import 'package:chat/layout/chat.dart';
import 'package:chat/modules/login_screen/login_cubit/login_cubit.dart';
import 'package:chat/modules/login_screen/login_cubit/login_states.dart';
import 'package:chat/modules/register_screen/register_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class loginScreen extends StatelessWidget{
 // const loginScreen({Key? key}) : super(key: key);

  var formKey=GlobalKey<FormState>();

  var emailcontroller=TextEditingController();
  var passwordcontroller=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginCubit(),
      child: BlocConsumer<loginCubit,loginStates>(
        listener: (context, state){
          if(state is loginSuccessState){
              cache.setData(key: 'uId', value: state.uId).then((value) {
                print(state.uId +'in login state.uid tap');
                //uId=state.uId;
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => chatLayout(),), (route) => false);
                cache.setData(key: 'isLogin', value: true);
              }).catchError((error){
                print(error.toString());
              });


          }
          if(state is loginErrorState){
                Fluttertoast.showToast(
                  msg: state.error,
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
            appBar: AppBar(),
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
                        Text('Sign in',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0,),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return 'can not be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return 'can not be empty';
                            }
                            return null;
                          },
                          obscureText: loginCubit.get(context).IsPass,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordcontroller,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: ()
                                {
                                loginCubit.get(context).showPassword();
                                },

                              icon: loginCubit.get(context).IsPass?Icon(Icons.visibility_outlined):Icon(Icons.visibility_off_outlined),
                            ),

                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.teal[400],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: MaterialButton(
                              onPressed: (){
                                if(formKey.currentState!.validate())
                                {
                                  print('login');
                                  print(uId +'in login tap');
                                  loginCubit.get(context).userLogin(email: emailcontroller.text, password: passwordcontroller.text);
                                }
                              },
                              child: Text('Login',style: TextStyle(color: Colors.white),)),
                        ),

                        SizedBox(height: 10.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Do not have an account'),
                            SizedBox(width: 5.0,),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => register_screen(),));
                                },
                                child: Text('Register'),
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

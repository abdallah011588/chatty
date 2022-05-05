import 'package:chat/layout/chat.dart';
import 'package:chat/modules/login_screen/login_cubit/login_cubit.dart';
import 'package:chat/modules/login_screen/login_cubit/login_states.dart';
import 'package:chat/modules/login_screen/login_screen.dart';
import 'package:chat/modules/register_screen/register_cubit/register_cubit.dart';
import 'package:chat/modules/register_screen/register_cubit/register_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class register_screen extends StatelessWidget{
  var formkey=GlobalKey<FormState>();

  var namecontroller=TextEditingController();
  var emailcontroller=TextEditingController();
  var phonecontroller=TextEditingController();
  var passwordcontroller=TextEditingController();
  //const register_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => registerCubit(),
      child: BlocConsumer<registerCubit,registerStates>(
        listener: (context, state) =>{

        if(state is createUserSuccessState)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => loginScreen(),))
        }


        } ,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Register',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0,),
                        TextFormField(
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
                        SizedBox(height: 10.0,),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return 'can not be empty';
                            }
                            return null;
                          },
                          controller: emailcontroller,
                          keyboardType: TextInputType.emailAddress,
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
                          keyboardType: TextInputType.phone,
                          controller: phonecontroller,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
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
                          obscureText: registerCubit.get(context).IsPass,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordcontroller,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: ()
                              {
                                registerCubit.get(context).showPassword();
                              },

                              icon: registerCubit.get(context).IsPass?Icon(Icons.visibility_outlined):Icon(Icons.visibility_off_outlined),
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
                            child:
                            state is! registerLoadingState? MaterialButton(
                                onPressed: (){
                                  if(formkey.currentState!.validate())
                                    {
                                      print('register');
                                      registerCubit.get(context).userRegister(
                                          name: namecontroller.text,
                                          email: emailcontroller.text,
                                          password: passwordcontroller.text,
                                          phone: phonecontroller.text,
                                      );
                                    }
                                },
                                child: Text('Register',style: TextStyle(color: Colors.white),)):Center(child: CircularProgressIndicator()),
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

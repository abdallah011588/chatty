import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class updateFields extends StatelessWidget {

  var formKey=GlobalKey<FormState>();
  var controller=TextEditingController();

  final String title;
  final String field;

  updateFields({ required this.title,required this.field}) ;


  @override
  Widget build(BuildContext context) {

    controller.text=field;

    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder:  (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                onPressed: (){
                if(formKey.currentState!.validate())
                  {
                    if(title=='User Name')
                    {
                      appCubit.get(context).updateUser(name:controller.text );
                      Navigator.pop(context);
                    }
                    if(title=='Phone')
                    {
                      appCubit.get(context).updateUser(phone:controller.text );
                      Navigator.pop(context);
                    }
                    if(title=='Bio')
                    {
                      appCubit.get(context).updateUser(bio:controller.text );
                      Navigator.pop(context);
                    }
                  }
                },
                icon: Icon(Icons.check,color: Colors.white,),),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                keyboardType: title=='Phone'?TextInputType.phone:TextInputType.text,
                validator: (value){
                  if(value!.isEmpty)
                  {
                    return 'can not be empty';
                  }
                  return null;
                },
                /*decoration: InputDecoration(
                labelText: 'Bio',
                //border: OutlineInputBorder(),
               // prefixIcon: Icon(Icons.text_fields),
              ),*/
              ),
            ),
          ),
        );
      },

    );
  }
}

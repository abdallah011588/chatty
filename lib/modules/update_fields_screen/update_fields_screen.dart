import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/localization/localization_methods.dart';
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
            title: Text(getTranslated(context,title)!),
            actions: [
              IconButton(
                onPressed: (){
                if(formKey.currentState!.validate())
                  {
                    if(getTranslated(context,title)! ==getTranslated(context,'User Name')!)
                    {
                      appCubit.get(context).updateUser(name:controller.text);
                      Navigator.pop(context);
                    }
                    if(getTranslated(context,title)! ==getTranslated(context,'Phone')!)
                    {
                      appCubit.get(context).updateUser(phone:controller.text );
                      Navigator.pop(context);
                    }
                    if(getTranslated(context,title)! ==getTranslated(context,'Bio')!)
                    {
                      appCubit.get(context).updateUser(bio:controller.text );
                      Navigator.pop(context);
                    }
                  }
                },
                icon: state is! appUpdateUserLoadingState?
                Icon(Icons.check,color: Colors.white,)
                :Center(child: CircularProgressIndicator(color: Colors.grey[200],)),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                keyboardType: title==getTranslated(context,'Phone')! ? TextInputType.phone:TextInputType.text,
                validator: (value){
                  if(value!.isEmpty)
                  {
                    return 'Can\'t be empty';
                  }
                  return null;
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

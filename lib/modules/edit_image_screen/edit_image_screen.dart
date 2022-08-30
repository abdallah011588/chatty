import 'dart:io';

import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class editImageScreen extends StatelessWidget {


  final File image;
  final userModel model;

  editImageScreen({
    required this.image,
    required this.model
  }) ;



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {
        if(state is appSendSuccessState)
          Navigator.pop(context);
      },
      builder:  (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              //if(state is! appUploadImLoadingState)
              IconButton(
                onPressed: (){
                  //appCubit.get(context).removeMessageImage();
                  Navigator.pop(context);
                 // appCubit.get(context).updateImage();
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          body: SizedBox.expand(
            child: Column(
              children: [
                // if(state is appUploadMessageImLoadingState)
                //   LinearProgressIndicator(),

                Expanded(
                  child: InteractiveViewer(
                    child: Image(image: FileImage(image),),//Image.file(imageUri),
                  ),
                ),
              ],
            ),
          ),

          floatingActionButton:  FloatingActionButton(
            onPressed: () {
              appCubit.get(context).uploadMessageImage(
                receiverId: model.uId,
                text: '',
                dateTime: DateTime.now().toString(),
              );
              if (state is appSendSuccessState)
                Navigator.pop(context);
              // appCubit.get(context).removeMessageImage();
            },
            child: Icon(Icons.send_outlined),
          ),

        );
      },
    );
  }
}



//Skipped 1757 frames!  The application may be doing too much work on its main thread.
//Background concurrent copying GC freed 726798(32MB) AllocSpace objects, 0(0B) LOS objects, 49% free, 20MB/41MB, paused 302us total 210.379ms
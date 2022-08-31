import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/models/notification_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:chat/shared/remote/dio_tool.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';


class appCubit extends Cubit<appStates>
{
  appCubit():super(initialAppState());

  static appCubit get(context)=>BlocProvider.of(context);

  bool changed=false;
  userModel? user_model;

 void getUserData()
 {
   emit(appGetUserLoadingState());
   FirebaseFirestore.instance.collection('users')
       .doc(uId)
       .get().then((value) {
         user_model=userModel.fromJson(value.data()!);
         getFriends();
         emit(appGetUserSuccessState());
       }).catchError((error){
        emit(appGetUserErrorState());
      });
 }

void signOut()async
{
  await FirebaseAuth.instance.signOut().then((value) {
    emit(appLogOutSuccessState());
  }).catchError((onError){
    emit(appLogOutErrorState());
  });
}

 File? Image;
 final ImagePicker picker =ImagePicker();
 Future<void> getImage()async
 {
   var pickedImage= await picker.pickImage(source: ImageSource.gallery);
   if(pickedImage !=null)
     {
       Image=File(pickedImage.path);
       emit(appGetImageSuccessState());
     }
   else
     {
       emit(appGetImageErrorState());
     }
 }

  Future<void> getImageFromCamera()async
  {
    var pickedImage= await picker.pickImage(source: ImageSource.camera);
    if(pickedImage !=null)
    {
      Image=File(pickedImage.path);
      emit(appGetImageSuccessState());
    }
    else
    {
      emit(appGetImageErrorState());
    }
  }

 void updateUser({
   String? name,
   String? uId,
   String? phone,
   String? bio,
   String? image,
   })
 {
   emit(appUpdateUserLoadingState());
   userModel model=userModel(
       email: user_model!.email,
       name: name??user_model!.name,
       phone: phone??user_model!.phone,
       uId: user_model!.uId,
       bio: bio??user_model!.bio,
       image: image??user_model!.image,
       messagingToken: user_model!.messagingToken,
   );

   FirebaseFirestore.instance
       .collection('users')
       .doc(user_model!.uId)
       .update(model.toMap()).then((value)
   {
     getUserData();
   }).catchError((onError){
     emit(appUpdateUserErrorState());
   });

   friends.forEach((element) {
     FirebaseFirestore.instance
         .collection('myFriends')
         .doc('myFriends')
         .collection(element.uId)
         .doc(user_model!.uId)
         .update(model.toMap());
   });
 }

 void updateImage()
 {
   emit(appUploadImLoadingState());
   firebase_storage.FirebaseStorage
       .instance
       .ref()
       .child('users/${Uri.file(Image!.path).pathSegments.last}')
       .putFile(Image!).then((value) {

         value.ref.getDownloadURL().then((value)
         {
           updateUser(image: value);
           emit(appUploadImSuccessState());
         }).catchError((error){
           emit(appUploadImErrorState());
         });
       }).catchError((onError){
         emit(appUploadImErrorState());
      });
 }

 List<userModel> users=[];
 void getAllUsers()
 {
   users=[];
   emit(appGetAllUserLoadingState());
   FirebaseFirestore.instance
       .collection('users')
       .get().then((value) {
         value.docs.forEach((element) {
           if(element.data()['uId'] != uId) {
           users.add(userModel.fromJson(element.data()));
        }
      });
         emit(appGetUserSuccessState());
     }).catchError((onError){
       print(onError.toString()+'error in getting all users');
     emit(appGetUserErrorState());
   });
 }


  List<userModel> specificUser=[];
  void getSpecificUser({required String name})
  {
    specificUser=[];
    FirebaseFirestore.instance
        .collection('users')
        .where('name',isEqualTo: name)
        .get().then((value) {
        value.docs.forEach((element) {
        if(element.data()['uId'] != user_model!.uId)
        specificUser.add(userModel.fromJson(element.data()));
      });
      emit(appGetSpecificUserSuccessState());
    }).catchError((onError){
      emit(appGetSpecificUserErrorState());
    });
  }


  userModel? searchedUser;
  void getSearchedUser ({required String email})
  {
    users.forEach((element) {
      if(element.email==email)
      {
        searchedUser=element;
        print(searchedUser!.email);
      }
    });
    emit(appGetSearchedUserSuccessState());
  }


  bool isdark=false;
  void changeAppMode({ bool? dataFromShared })
  {
    if(dataFromShared !=null) {
      isdark = dataFromShared;
      emit(appIsDarkModeState());
    }
    else
    {
      isdark = !isdark;
      cache.setData(key: 'isdark', value: isdark).then((value)
      {
        emit(appIsDarkModeState());
      });
    }
  }

  Widget searchCheck(userModel item)
  {
   return Builder(
      builder: (context) {
        Widget? icon;
        appCubit.get(context).friends.forEach((element) {
          if(element.email==item.email)
          {
            icon=Icon(
              Icons.person,
              color: Colors.blue,
            );
            emit(appUnRequestSuccessState());
          }
        });
        if(icon==null)
        {
          icon=IconButton(
            onPressed: (){
              sendFriendRequest(receiverId: item.uId);
              sendNotification(
                  receiver: item.messagingToken,
                  title: 'Friend request',
                  body: '${item.name} sent you request',
              );
            },
            icon: Icon(
              Icons.person_add,
              color:isdark?Colors.white:Colors.black,
            ),
          );
          emit(appUnRequestSuccessState());
        }
        return icon!;
      },
    );
  }


  void sendFriendRequest({required String receiverId})
  {
    FirebaseFirestore.instance
        .collection('myRequests')
        .doc('myRequests').
         collection(receiverId)
        .doc(user_model!.uId)
        .set(user_model!.toMap())
        .then((value){
      emit(appSendRequestSuccessState());
    }).catchError((onError){
      emit(appSendRequestErrorState());
    });
  }

  List<userModel> senderRequest=[];
  void getRequests()
  {
      FirebaseFirestore.instance
          .collection('myRequests')
          .doc('myRequests')
          .collection(user_model!.uId)
          .snapshots()
          .listen((event) {
            senderRequest=[];
           event.docs.forEach((element) {
          senderRequest.add(userModel.fromJson(element.data()));
        });
        emit(appGetRequestSuccessState());
      });
  }

  void acceptFriendRequest({required userModel model})
  {
    /// //////////  Set Me as his Friend ////////////
    FirebaseFirestore.instance
        .collection('myFriends')
        .doc('myFriends')
        .collection(model.uId)
        .doc(user_model!.uId)
        .set(user_model!.toMap())
        .then((value){
      emit(appAcceptRequestSuccessState());
    }).catchError((onError)
    {
      emit(appAcceptRequestErrorState());
    });

    /// /////////  Set him as MyFriend  /////////////
    FirebaseFirestore.instance
        .collection('myFriends')
        .doc('myFriends')
        .collection(user_model!.uId)
        .doc(model.uId)
        .set(model.toMap())
        .then((value){
      delRequests(model: model);
      emit(appAcceptRequestSuccessState());
    }).catchError((onError)
    {
      emit(appAcceptRequestErrorState());
    });
  }

  void delRequests({required userModel model})
  {
    FirebaseFirestore.instance
        .collection('myRequests')
        .doc('myRequests')
        .collection(user_model!.uId)
        .doc(model.uId)
        .delete().then( (value)
     {
      senderRequest.remove(model);
      emit(appDeleteRequestSuccessState());
    }).catchError((Error){
      emit(appDeleteRequestErrorState());
    });
  }


  List<userModel> friends=[];
  void getFriends()
  {
      FirebaseFirestore.instance
          .collection('myFriends')
          .doc('myFriends')
          .collection(user_model!.uId)
          .snapshots()
          .listen((event) {
          friends=[];
          event.docs.forEach((element) {

        friends.add(userModel.fromJson(element.data()));

        });
          emit(appGetFriendsSuccessState());
      });
  }




  File? MessageImage;
  Future<void> getMessageImage()async
  {
    var pickedFile=await picker.pickImage(source:ImageSource.gallery);
    if(pickedFile !=null) {
      MessageImage=File(pickedFile.path);
      emit(appMessageImPickedSuccessState());
    }
    else {
      emit(appMessageImPickedErrorState());
    }
  }

  void removeMessageImage()
  {
    MessageImage=null;
    emit(appRemoveMessageImSuccessState());
  }

  void uploadMessageImage({
    required String receiverId,
    required String text,
    required String dateTime,
  }) {
    emit(appUploadMessageImLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('messages/${Uri.file(MessageImage!.path).pathSegments.last}')
        .putFile(MessageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value)
      {
        sendMessage(
          receiverId: receiverId,
          dateTime: dateTime,
          text: text,
          messageImage: value,
          messageVoice: '',
        );
        emit(appSendSuccessState());
      }).catchError((onError){
        emit(appUploadMessageImErrorState());
      });
    }).catchError((error){
      emit(appUploadMessageImErrorState());
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
    required String messageImage,
    required String messageVoice,
  })
  {
    messageModel msModel=messageModel(
      senderId: user_model!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
      messageImage: messageImage,
      messageVoice: messageVoice,
    );

    /// Set My Chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(msModel.toMap() ).then((value)
    {
      emit(appSendMessageSuccessState());
    }).catchError((error){
      emit(appSendMessageErrorState());
    });

    /// Set Receiver Chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(user_model!.uId)
        .collection('messages')
        .add(msModel.toMap()).then((value)
    {
      emit(appSendMessageSuccessState());
    }).catchError((error){
      emit(appSendMessageErrorState());
    });

  }

  List<messageModel> messages=[];
  void getMessages({required String receiverId,})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages=[];
      event.docs.forEach((element)
      {
        messages.add(messageModel.fromJson(element.data()));
      });
      emit(appGetMessageSuccessState());
    });
  }



  List<userModel> getSearchedFriendList=[];
  void getSearchedFriend2 ({required String name})
  {
    users.forEach((element) {
      if(element.name==name)
      {
        getSearchedFriendList.add(element);
      }
    });
    emit(appGetSearchedUserSuccessState());
  }


  final recorder =FlutterSoundRecorder();
  bool is_recorderReady=false;
  final  audioPlayer=AudioPlayer();
  bool audioPlayerIsPlaying=false;


  Future getVoiceRecorded()async
  {
     final status =await Permission.microphone.request();
     if(status != PermissionStatus.granted)
      {
        throw 'microphone permission is not granted !';
      }
     else
       {
         print('took permission');
       }
    await recorder.openRecorder();
    is_recorderReady=true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future record(String fileName)async{
    if(! is_recorderReady) return;
    await recorder.startRecorder(toFile: fileName);
  }

  Future stop({ required String receiverId,})async
  {
    if(! is_recorderReady) return;
    await recorder.stopRecorder().then((value) {
      final audioFile= File(value!);
      uploadMessageVoice(
          voice: audioFile,
          path: value,
         receiverId: receiverId,
      );
    });
  }

  void now_recording({ required String receiverId,})async
  {
    if(recorder.isRecording)
    {
      await stop(receiverId: receiverId);
    }
    else
    {
      String _name=user_model!.name+'-'+DateTime.now().toString().replaceAll('.', '');
      await record(_name);
    }
    emit(appTextChangedState());
  }

   void uploadMessageVoice({
     required File voice,
     required String path,
     required String receiverId,
   })
   {
    emit(appUploadMessageVoiceLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('voices/${Uri.file(path).pathSegments.last}')
        .putFile(voice,)
        .then((value) {
      value.ref.getDownloadURL().then((value)async
      {
        sendMessage(
          receiverId: receiverId,
          dateTime: DateTime.now().toString(),
          text: '',
          messageImage: '',
          messageVoice: value,
        );
        emit(appUploadMessageVoiceSuccessState());
      }).catchError((onError){
        emit(appUploadMessageVoiceErrorState());
      });
    }).catchError((error){
      emit(appUploadMessageVoiceErrorState());
    });
  }

  String url='';
  void playVoice(/*String url*/)async
  {
    if(audioPlayer.processingState==ProcessingState.ready)
      {
        if(audioPlayer.playerState.playing)
        {
          emit(appAudioPlayerPause());
          audioPlayerIsPlaying=false;
          await audioPlayer.pause();
        }
        else
        {
          emit(appAudioPlayerPlaying());
          audioPlayerIsPlaying=true;
          await audioPlayer.play();
        }
      }
     else if(audioPlayer.processingState==ProcessingState.idle)
      {
        emit(appAudioPlayerReady());
        audioPlayerIsPlaying=true;
        await audioPlayer.setUrl(url);
        await audioPlayer.play();
      }
    else if(audioPlayer.processingState==ProcessingState.completed)
    {
      emit(appAudioPlayerRestart());
      audioPlayerIsPlaying=false;
      await audioPlayer.stop().then((value) {
        print('on after complete');
        emit(appAudioPlayerStop());
        audioPlayerIsPlaying=false;
        audioPlayer.seek(Duration(seconds: 0));
      });;
    }
  }

   double voiceProgress()
   {
   emit(appAudioPlayerProgress());
   return audioPlayer.position.inSeconds.toDouble();
  }

  void sendNotification({
    required String receiver,
    required String title,
    required String body,
  })
  {
    notificationData notifyData= notificationData(
      title: title,
      body: body,
      mutableContent: true,
      sound: 'default',
    );

    notificationModel notifyModel= notificationModel(
      to: receiver,
      notification: notifyData,
    );

    dioTool.postData(data: notifyModel.toJson()).then( (value) {
      print('successful process of sending notification');
      emit(sendNotificationSuccessState());
    }).catchError((error){
      print('Error in sending notification');
      emit(sendNotificationErrorState());
    });

  }



}








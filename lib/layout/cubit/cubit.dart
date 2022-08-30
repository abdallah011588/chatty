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
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';


class appCubit extends Cubit<appStates>
{
  appCubit():super(initialAppState());

  static appCubit get(context)=>BlocProvider.of(context);

  //print("User ${( FirebaseAuth.instance.currentUser!.uid)})");


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

/// ////////////////////

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

      // print(specificUser[1].phone);
      // specificUser.forEach((element) {
      //   print(element.phone);
      // });

      //getRequests();
      emit(appGetSpecificUserSuccessState());
    }).catchError((onError){
      print(onError.toString()+'error in getting all users');
      emit(appGetSpecificUserErrorState());
    });
  }

 /// ////////////////////////

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


  // userModel? searchedFriend;
  // void getSearchedFriend ({required String name})
  // {
  //   usersFriends.forEach((element) {
  //     if(element.name==name)
  //     {
  //       searchedFriend=element;
  //       print(searchedFriend!.email);
  //     }
  //   });
  //   emit(appGetSearchedFriendSuccessState());
  // }


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


/*
  Future<bool> onLikeButtonTapped(bool isLiked) async{


    if(!isLiked)
      {
        print('liked');
        added=!isLiked;
      }
    else
      {
        print('not liked');
        added=!isLiked;
      }

    return !isLiked;
  }

  bool added=true;
  Widget addButton( {required String receiverId})
  {
    return LikeButton(
      size: 20,
      circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xff33b5e5),
        dotSecondaryColor: Color(0xff0099cc),
      ),

      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.person_add,
          color: isLiked ? Colors.blue : Colors.grey,
          size: 20,
        );
      },

      isLiked: added,
      onTap: (bool val) async{

        if(!val)
        {
          sendFriendRequest(receiverId: receiverId);
          print('liked');
          added=!val;
        }
        else
        {
          //delRequests(model: model)

          FirebaseFirestore.instance
              .collection('myRequests')
              .doc('myRequests')
              .collection(receiverId)
              .doc(user_model!.uId)
              .delete().then( (value)
          {
            emit(appUnRequestSuccessState());
          }).catchError((Error){
            emit(appUnRequestErrorState());
          });

          /// //////////
          print('not liked');
          added=!val;
        }

        return !val;
      },
    );
  }

  */

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

  /// //////////////////////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////////////////////


  /// YOU CAN USE THIS TO SEND NOTIFICATION TO THE REQUESTED FRIEND
  /*
  List<String> sentRequested=[];
  Future<bool> requested({required String receiverId})async
  {
    bool? isRequested;
    FirebaseFirestore.instance
        .collection('myRequests')
        .doc('myRequests')
        .collection(receiverId).snapshots().listen((event) {
          event.docs.forEach((element) {

             if(element.id==user_model!.uId)
               isRequested= true;
             emit(foundRequestedSuccessState());
          });
     });
    if (isRequested==null) isRequested= false;
    emit(foundRequestedSuccessState());
    return isRequested!;

  }
  */


  /// CHANGE 1 ///////////////
  /*
  void sendFriendRequest({required String receiverId})
  {
    requestModel modell= requestModel(sendrUid:user_model!.uId );

    FirebaseFirestore.instance
        .collection('Requests')
        .doc('Requests').
        collection(receiverId)
        .doc(user_model!.uId)
        .set(modell.ToMap())
        .then((value){
      //requested=true;
      emit(appSendRequestSuccessState());
    }).catchError((onError){
      emit(appSendRequestErrorState());
    });
/*
    FirebaseFirestore.instance
        .collection('requests')
        .doc(receiverId)
        .collection(receiverId)
        .add(modell.ToMap())
        .then((value){
          print(value.id);
      emit(appSendRequestSuccessState());
    }).catchError((onError){
      emit(appSendRequestErrorState());
    });*/
  }

  List<requestModel> senderRequest=[];
  void getRequests()
  {
    if(senderRequest.length ==0)
      //senderRequest=[];
      {
      FirebaseFirestore.instance
          .collection('Requests')
          .doc('Requests')
          .collection(user_model!.uId)
          .snapshots()
          .listen((event) {
        event.docs.forEach((element) {
          print(element.id);
          senderRequest.add(requestModel.fromJson(element.data()));
        });
        getallRequests();
        emit(appGetRequestSuccessState());
      });
    }
  }

  List<userModel> usersRequests=[];
  void getallRequests()
  {
    if(usersRequests.length==0)
    //usersRequests=[];
        {
        users.forEach((element) {
        senderRequest.forEach((element2) {
          if (element.uId == element2.sendrUid)
            usersRequests.add(element);
        });
      });
    }
    emit(appGetAllRequestErrorState());
  }


   */

  void sendFriendRequest({required String receiverId})
  {
    FirebaseFirestore.instance
        .collection('myRequests')
        .doc('myRequests').
         collection(receiverId)
        .doc(user_model!.uId)
        .set(user_model!.toMap())
        .then((value){
      //requested=true;
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

  /// CHANGE 2 ////////////////////////////////////////////////////
  /*
  void acceptFriendRequest({required String friendId})
  {

    /// //////////  Set Me as his Friend ////////////

    requestModel model1= requestModel(sendrUid:user_model!.uId );
    FirebaseFirestore.instance
        .collection('Friends')
        .doc('Friends')
        .collection(friendId)
        .doc(user_model!.uId)
        .set(model1.ToMap())
        .then((value){
      //requested=true;
      delRequests(senderId: friendId);
      emit(appAcceptRequestSuccessState());
    }).catchError((onError)
    {
      emit(appAcceptRequestErrorState());
    });


    /// /////////  Set him as MyFriend  /////////////

    requestModel model2= requestModel(sendrUid:friendId );
    FirebaseFirestore.instance
        .collection('Friends')
        .doc('Friends')
        .collection(user_model!.uId)
        .doc(friendId)
        .set(model2.ToMap())
        .then((value){
        //requested=true;
      delRequests(senderId: friendId);
      emit(appAcceptRequestSuccessState());
    }).catchError((onError)
    {
      emit(appAcceptRequestErrorState());
    });

  }


  void delRequests({required String senderId})
  {
    FirebaseFirestore.instance
        .collection('Requests')
        .doc('Requests')
        .collection(user_model!.uId)
        .doc(senderId).delete().then( (value)
    {
     // deleteRequestFromList(senderId: senderId);
      usersRequests.forEach((element) {
        if(element.uId==senderId) {
          usersRequests.remove(element);
          senderRequest.remove(element.uId);
        }
        // else if(usersRequests.length==0)
        //   {
        //     //usersRequests=[];
        //     //senderRequest=[];
        //   }
        emit(appDeleteRequestSuccessState());
      });
     /* senderRequest.forEach((element)
      {
        print(element.sendrUid);
      });

      usersRequests.forEach((element) {
        print(element.uId);
      });*/
    }).catchError((Error){
      emit(appDeleteRequestErrorState());
    });
  }

  void deleteRequestFromList({required String senderId})
  {
    usersRequests.forEach((element) {
      if(element.uId==senderId) {
        usersRequests.remove(element);
        senderRequest.remove(element.uId);
      }
      // else if(usersRequests.length==0)
      //   {
      //     //usersRequests=[];
      //     //senderRequest=[];
      //   }
      emit(appDeleteRequestSuccessState());
    });
  }

*/

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

  /// CHANGE 3 ////////////////////////////////////////////////////
  /*
  List<requestModel> friends=[];
  void getFriends()
  {
    if(friends.length ==0) {
      FirebaseFirestore.instance
          .collection('Friends')
          .doc('Friends')
          .collection(user_model!.uId)
          .snapshots()
          .listen((event) {
        event.docs.forEach((element) {
          //print(element.id);
          friends.add(requestModel.fromJson(element.data()));
          //friendsChat.add(false);
        });
        getAllFriends();
        emit(appGetRequestSuccessState());
      });
    }
  }

  List<bool> friendsChat=[];


  List<userModel> usersFriends=[];
  void getAllFriends()
  {
    if(usersFriends.length==0)
      //usersRequests=[];
        {
        users.forEach((element) {
        friends.forEach((element1) {
          if (element.uId == element1.sendrUid)
            usersFriends.add(element);
        });
      });
    }
    emit(appGetAllRequestErrorState());
  }
  */

  List<userModel> friends=[];
  void getFriends()
  {
    // if(friends.length ==0) {
      //friends=[];
      FirebaseFirestore.instance
          .collection('myFriends')
          .doc('myFriends')
          .collection(user_model!.uId)
          .snapshots()
          .listen((event) {
          friends=[];
          event.docs.forEach((element) {
            if(element.data()['messagingToken']==null) {
          print(element.data()['name']);
          print(element.data()['uId']);
        }
        friends.add(userModel.fromJson(element.data()));
        });
          emit(appGetFriendsSuccessState());
      });
  }



/// ################################################################################3


  // List<userModel> chats=[];
  // void getFreindsChats()
  // {
  //   for(int i=0;i<friendsChat.length;i++)
  //   {
  //     if(friendsChat[i]==true)
  //     {
  //       chats.add(usersFriends[i]);
  //     }
  //   }
  //   //emit(appGetfriendChats());
  // }
/// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


  File? MessageImage;
  Future<void> getMessageImage()async
  {
    var pickedFile=await picker.pickImage(source:ImageSource.gallery);

    if(pickedFile !=null) {
      MessageImage=File(pickedFile.path);
      emit(appMessageImPickedSuccessState());
    }
    else {
       print('No Image Selected');
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
        //removeMessageImage();
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


/// ###################################################################################

  void onTextChanged(String v)
  {
    emit(appTextChangedState());
    changed=true;
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

   // await audioPlayer.setUrl('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3');
    //audioPlayer.setSourceUrl(x);

   // AudioSource.uri(Uri.parse('https://example.com/track1.mp3'))

  }

  Future record(String fileName)async{
    if(! is_recorderReady) return;
    await recorder.startRecorder(toFile: fileName);
  }

  Future stop({ required String receiverId,})async{
    if(! is_recorderReady) return;
    await recorder.stopRecorder().then((value) {
      final audioFile= File(value!);
      uploadMessageVoice(
          voice: audioFile,
          path: value,
         receiverId: receiverId,
      );
    });

    /*
    //await audioPlayer.setFilePath(path);
    //audioPlayer.play();
    // recorder.getRecordURL(path: path).then((value) async{
    //   //audioPlayer.play(UrlSource(value!));
    //  //await audioPlayer.play();
    //   print(value);
    // });
    */
   // print('Recorded audio : $audioFile');
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
      print(_name);
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
       // audioPlayerIsPlaying=true;
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
          print('on pause');
          emit(appAudioPlayerPause());
          audioPlayerIsPlaying=false;
          await audioPlayer.pause();
        }
        else
        {
          // audioPlayer.setUrl(
          //    'https://firebasestorage.googleapis.com/v0/b/chat-8e284.appspot.com/o/voices%2Fmm-2022-08-20%2018%3A03%3A04614240?alt=media&token=05b8ce13-bcf7-4e21-a95f-975a2fe84de3'
          // ).then((value) {
          print('on play');

          emit(appAudioPlayerPlaying());
          audioPlayerIsPlaying=true;
          await audioPlayer.play();
          //  });
        }
      }
     else if(audioPlayer.processingState==ProcessingState.idle)
      {

        print('on play in idle');

        emit(appAudioPlayerReady());
        audioPlayerIsPlaying=true;
        await audioPlayer.setUrl(url);
        await audioPlayer.play();//.then((value){
          // audioPlayerIsPlaying=false;
          // emit(appAudioPlayerRestart());
          // // audioPlayer.seek(Duration(seconds: 0));
        //});
      }
    else if(audioPlayer.processingState==ProcessingState.completed)
    {
      print('on complete');

      emit(appAudioPlayerRestart());
      audioPlayerIsPlaying=false;
      await audioPlayer.stop().then((value) {
        print('on after complete');
        emit(appAudioPlayerStop());
        audioPlayerIsPlaying=false;
        audioPlayer.seek(Duration(seconds: 0));
       // audioPlayer.stop();
      });;
      // await audioPlayer.setUrl(url).then((value)async {
      //   emit(appAudioPlayerReady());
      //   audioPlayerIsPlaying=true;
      //   await audioPlayer.play().then((value){
      //     audioPlayerIsPlaying=false;
      //     emit(appAudioPlayerRestart());
      //     // audioPlayer.seek(Duration(seconds: 0));
      //   });
      // });
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


  int getMarker()
  {
    emit(appTextChangedState());
   return marker ;
  }


//[firebase_auth/user-not-found]
//fKBZlMcRSS-WLZ7RSaigeX:APA91bFnvQzgajK1q5mwPahCu5CW2gsshhPLLm2MFyrrddwPkRUV3uHHoQITQtIrFK_Ni6vivej8tvjq75ojmV5tipwW5kHu4CWwHXHPDqI4XDZ_zWtjKnf3s9qVAHLX11MseTf3kDI7

//ekRbPk6CS5iHa4GmDGfp8L:APA91bHNH0OseWzdgyfQ5lISd1bN0cSiBsT5d30LEJYHSdIsehpSGgYIIEFE53i2D8WYvWCi3jgafF3LQG21wFBMRUZXhBdnIB9U1ZCQLGT0ubFUBm4RF-SQxFP59s_wYOQdYCyVRMxw

// https://firebasestorage.googleapis.com/v0/b/chat-8e284.appspot.com/o/voices%2Fmm-2022-08-20%2018%3A03%3A04614240?alt=media&token=05b8ce13-bcf7-4e21-a95f-975a2fe84de3

}







/*





/// Main send request
/*
  bool requested=false;
  void sendFriendRequest({required String receiverId})
  {
    requestModel modell= requestModel(sendrUid:user_model.uId );


    FirebaseFirestore.instance
        .collection('requests5')
        .doc(receiverId)
        .collection(user_model.uId)
        .doc(user_model.uId).set(modell.ToMap())
        .then((value){
           //requested=true;
          emit(appSendRequestSuccessState());
        }).catchError((onError){
        emit(appSendRequestErrorState());
       });
/*
    FirebaseFirestore.instance
        .collection('requests')
        .doc(receiverId)
        .collection(receiverId)
        .add(modell.ToMap())
        .then((value){
          print(value.id);
      emit(appSendRequestSuccessState());
    }).catchError((onError){
      emit(appSendRequestErrorState());
    });*/
  }
*/


/// Main gerRequests ///////////
/*
  List<requestModel> senderRequest=[];
  void getRequests()
  {
    //senderRequest=[];
    if( senderRequest.length ==0)
    FirebaseFirestore.instance
        .collection('requests5')
        .doc(user_model.uId)
        .collection(user_model.uId)
        .snapshots()
        .listen((event) {
            event.docs.forEach((element){
              print(element.id);
            senderRequest.add(requestModel.fromJson(element.data()));
          });
          emit(appGetRequestSuccessState());
        });
      //  .get().then((value) {
      //    value..forEach((element) {
      //   senderRequest.add(userModel.fromJson(element.data()));
      // });
     // emit(appGetRequestSuccessState());
    //}).catchError((onError){
    //  emit(appGetRequestErrorState());
    //});
  }
*/

/// //////DELETE //////////////////////////
/*
  void deleteFriendRequest({required String requestId})
  {
    FirebaseFirestore.instance
        .collection('friends')
        .doc(user_model.uId)
        .collection(user_model.uId).get().then((value) {
          value.docs.forEach((element) {
            element.reference.delete();
          });  emit(appDeleteRequestSuccessState());
    }).catchError((onError){
           emit(appDeleteRequestErrorState());
          });
    // .then((value){
    //      emit(appDeleteRequestSuccessState());
    //     }).catchError((onError){
    //     emit(appDeleteRequestErrorState());
    //    });
  }*/

// void deleteFriendRequest({required String requestId})
// {
//   FirebaseFirestore.instance
//       .collection('requests')
//       .doc('cV6zyeSqeOfZM1CAJXR1BR72CvZ2')
//       .collection('cV6zyeSqeOfZM1CAJXR1BR72CvZ2').doc().get().then((value){
//      valueforEach((element) {
//     element.reference.snapshots().listen((event2) {
//     event2.reference.delete().then((value) {emit(appDeleteRequestSuccessState());});;
//     });
//     });
//   });
//
//   //.doc('0nbfGPDhq1D0rIBeXvtl').delete().then((value) {
//     // value.docs.forEach((element) {
//     //   element.reference.delete();
//     // });
//
//     // emit(appDeleteRequestSuccessState());
//  // .catchError((onError){
//    // emit(appDeleteRequestErrorState());
//  // });
//   // .then((value){
//   //      emit(appDeleteRequestSuccessState());
//   //     }).catchError((onError){
//   //     emit(appDeleteRequestErrorState());
//   //    });
// }
// //UMZH1gABkinhuKgt49kf


/// last code for request
/*
  bool requested=false;
  void sendFriendRequest({required String receiverId})
  {
    /*FirebaseFirestore
        .instance
        .collection('users')
        .doc(user_model.uId)
        .collection('requests')
        .add({'request':receiverId})
        .then((value){
           requested=true;
          emit(appSendRequestSuccessState());
    }).catchError((onError){
      emit(appSendRequestErrorState());
    });*/

    userModel model=userModel(
      email: user_model.email,
      name: user_model.name,
      phone:user_model.phone,
      uId: user_model.uId,
      bio: user_model.bio,
      image:user_model.image,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('requests')
        .add(model.toMap())
        .then((value){
      emit(appSendRequestSuccessState());
    }).catchError((onError){
      emit(appSendRequestErrorState());
    });

  }*/


/// last code for get requests

/*
  List<userModel> senderRequest=[];
  void getRequests()
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_model.uId)
        .collection('requests')
        .get().then((value) {
          value.docs.forEach((element) {
            senderRequest.add(userModel.fromJson(element.data()));
          });
          emit(appGetRequestSuccessState());
       }).catchError((onError){
         emit(appGetRequestErrorState());
    });
  }*/


/*
  List<userModel> searcUsers=[];
  void getSearchUsers()
  {
    emit(appGetAllUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .get().then((value) {
      value.docs.forEach((element) {
        if(element.data()['uId'] !=user_model.uId)
          users.add(userModel.fromJson(element.data()));
      });
      emit(appGetUserSuccessState());
    }).catchError((onError){
      emit(appGetUserErrorState());
    });
  }*/


 */
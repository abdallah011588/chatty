
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/models/request_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class appCubit extends Cubit<appStates>
{
  appCubit():super(initialAppState());

  static appCubit get(context)=>BlocProvider.of(context);

  bool changed=false;


 late userModel user_model;

 void getUserData()
 {
   emit(appGetUserLoadingState());
   FirebaseFirestore.instance.collection('users')
       .doc(uId)
       .get().then((value) {
         user_model=userModel.fromJson(value.data()!);
        // print(value.data());
         //print(user_model.name);
         emit(appGetUserSuccessState());
       }).catchError((error){
        emit(appGetUserErrorState());
      });
 }

void signOut()async
{
  await FirebaseAuth.instance.signOut().then((value) {
    print(user_model.uId);
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
   userModel model=userModel(
       email: user_model.email,
       name: name??user_model.name,
       phone: phone??user_model.phone,
       uId: user_model.uId,
       bio: bio??user_model.bio,
       image: image??user_model.image,
   );

   FirebaseFirestore.instance
       .collection('users')
       .doc(user_model.uId)
       .update(model.toMap()).then((value)
       {
         getUserData();
       }).catchError((onError){
     emit(appUpdateUserErrorState());
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
   emit(appGetAllUserLoadingState());
   FirebaseFirestore.instance
       .collection('users')
       .get().then((value) {
         value.docs.forEach((element) {
           //if(element.data()['uId'] != user_model.uId)
             users.add(userModel.fromJson(element.data()));
         });
          //getRequests();
         emit(appGetUserSuccessState());
     }).catchError((onError){
       print(onError.toString()+'error1');
     emit(appGetUserErrorState());
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



  userModel? searchedFriend;
  void getSearchedFriend ({required String name})
  {
    usersFriends.forEach((element) {
      if(element.name==name)
      {
        searchedFriend=element;
        print(searchedFriend!.email);
      }
    });
    emit(appGetSearchedFriendSuccessState());
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


  void sendFriendRequest({required String receiverId})
  {
    requestModel modell= requestModel(sendrUid:user_model.uId );

    FirebaseFirestore.instance
        .collection('Requests').doc('Requests').
        collection(receiverId)
        .doc(user_model.uId)
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
      FirebaseFirestore.instance.collection('Requests').doc('Requests')
          .collection(user_model.uId)
          .snapshots()
          .listen((event) {
           event.docs.forEach((element){
          print(element.id);
          senderRequest.add(requestModel.fromJson(element.data()));
        });
           getallRequests();
        emit(appGetRequestSuccessState());
      });
  }


  List<userModel> usersRequests=[];
  void getallRequests()
  {
    if(usersRequests.length==0)
    //usersRequests=[];
      users.forEach((element) {
        senderRequest.forEach((element1) {
          if(element.uId==element1.sendrUid)
            usersRequests.add(element);
        });
      });
    emit(appGetAllRequestErrorState());
  }



/// ////////////////////////////////////////////////////////////////


  void acceptFriendRequest({required String friendId})
  {

    /// //////////  Set Me as his Friend ////////////

    requestModel model1= requestModel(sendrUid:user_model.uId );
    FirebaseFirestore.instance
        .collection('Friends').doc('Friends')
        .collection(friendId)
        .doc(user_model.uId)
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
        .collection('Friends').doc('Friends')
        .collection(user_model.uId)
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
    FirebaseFirestore.instance.collection('Requests').doc('Requests')
        .collection(user_model.uId)
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









///////////////////////////////////////////////////


  List<requestModel> friends=[];
  void getFriends()
  {
    if(friends.length ==0)
      FirebaseFirestore.instance.collection('Friends').doc('Friends')
          .collection(user_model.uId)
          .snapshots()
          .listen((event) {
           event.docs.forEach((element){
           //print(element.id);
           friends.add(requestModel.fromJson(element.data()));
           //friendsChat.add(false);
        });
           getAllFriends();
        emit(appGetRequestSuccessState());
      });
  }

  List<bool> friendsChat=[];


  List<userModel> usersFriends=[];
  void getAllFriends()
  {
    if(usersFriends.length==0)
      //usersRequests=[];
      users.forEach((element) {
        friends.forEach((element1) {
          if(element.uId==element1.sendrUid)
            usersFriends.add(element);
        });
      });
    emit(appGetAllRequestErrorState());
  }


/// ################################################################################3
  ///

  List<userModel> chats=[];
  void getFreindsChats()
  {
    for(int i=0;i<friendsChat.length;i++)
    {
      if(friendsChat[i]==true)
      {
        chats.add(usersFriends[i]);
      }
    }
    //emit(appGetfriendChats());
  }

  /// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


  File? MessageImage;
  Future<void> getMessageImage()async
  {
    final pickedFile=await picker.pickImage(source:ImageSource.gallery);

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

  })
  {
    messageModel msModel=messageModel(
      senderId: user_model.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
      messageImage: messageImage,
    );

    /// Set My Chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_model.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add( msModel.toMap() ).then((value)
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
        .doc(user_model.uId)
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
        .doc(user_model.uId)
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



}














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

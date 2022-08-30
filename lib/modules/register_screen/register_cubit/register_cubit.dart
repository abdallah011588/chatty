import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_states.dart';

class registerCubit extends Cubit<registerStates>{
  registerCubit() : super(initialRegisterState());


 static registerCubit get(context) =>BlocProvider.of(context);

  bool IsPass=true;
  void showPassword()
  {
    IsPass=!IsPass;
    emit(registerShowPasswordState());
  }


  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }){

    FirebaseMessaging.instance.getToken().then((value) {
      userModel user_Model=userModel(
        email: email,
        name: name,
        phone: phone,
        uId: uId,
        bio: 'bio',
        messagingToken: value!,
        image: 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?t=st=1647347030~exp=1647347630~hmac=25ba8726740b9e357adf91054b1673e062ffaee9f1e17c864807bf6edf9beca7&w=740',
      );

      print('go to storage');
      FirebaseFirestore.instance.collection('users').doc(uId).set(user_Model.toMap()).then((value){
        emit(createUserSuccessState(uId));
      }).catchError((error){
        emit( createUserErrorState(error.toString()) );
      });
    });



  }


  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
   })
  {
    emit(registerLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      userCreate(name: name, email: email, phone: phone, uId: value.user!.uid,);
      print(value.user!.uid);
    }).catchError((error){
      emit(registerErrorState());
    });

  }
















}

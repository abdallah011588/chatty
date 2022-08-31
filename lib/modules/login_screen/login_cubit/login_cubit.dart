import 'package:chat/modules/login_screen/login_cubit/login_states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class loginCubit extends Cubit<loginStates>{
  loginCubit() : super(initialLoginState());

 static loginCubit get(context) =>BlocProvider.of(context);

  bool IsPass=true;
  void showPassword()
  {
    IsPass=!IsPass;
    emit(loginShowPasswordState());
  }


  void userLogin({
    required String email,
    required String password,
  })
  {
    emit(loginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {

      uId=value.user!.uid;
      emit(loginSuccessState(value.user!.uid));
      print(value.user!.uid+'in cubit of login');

      }).catchError((error){
       emit(loginErrorState(error.toString()));
       print(error.toString());
       });
  }

}

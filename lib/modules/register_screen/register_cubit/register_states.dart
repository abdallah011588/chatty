

abstract class registerStates{}

class initialRegisterState extends registerStates{}
class registerShowPasswordState extends registerStates{}




class registerLoadingState extends registerStates{}
class registerSuccessState extends registerStates{}
class registerErrorState extends registerStates{}



//class createUserLoadingState extends registerStates{}
class createUserSuccessState extends registerStates{

  final String uId;
  createUserSuccessState(this.uId);
}
class createUserErrorState extends registerStates{

  final String error;

  createUserErrorState(this.error);
}










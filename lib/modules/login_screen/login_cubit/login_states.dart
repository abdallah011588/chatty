

abstract class loginStates{}

class initialLoginState extends loginStates{}
class loginShowPasswordState extends loginStates{}

class loginLoadingState extends loginStates{}
class loginSuccessState extends loginStates{

  final String uId;

  loginSuccessState(this.uId);
}
class loginErrorState extends loginStates{

  final String error;

  loginErrorState(this.error);

}




















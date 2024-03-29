
class userModel
{
  late String name;
  late String email;
  late String phone;
  late String uId;
  late String bio;
  late String image;
  late String messagingToken;

  userModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.uId,
    required this.bio,
    required this.image,
    required this.messagingToken,

  });


  userModel.fromJson(Map<String,dynamic> json)
  {
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    uId=json['uId'];
    bio=json['bio'];
    image=json['image'];
    messagingToken=json['messagingToken'];

  }

  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'bio':bio,
      'image':image,
      'messagingToken':messagingToken,
    };
  }


}
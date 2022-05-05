
class requestModel
{
  late String sendrUid;

  requestModel({required this.sendrUid});

  requestModel.fromJson(Map<String,dynamic> json)
  {
    sendrUid=json['senderUid'];
  }

  Map<String,dynamic> ToMap()
  {
    return {
      'senderUid':sendrUid,
    };
  }

}
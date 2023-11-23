import 'package:renapps/functions/functions.dart';

class UserModel {
  String dbId;
  String buque;
  String nums;
  String userId;
  String imgUrl;
  double rndValue;

  UserModel(this.dbId, this.buque, this.nums, this.userId, this.imgUrl,
      this.rndValue);

  UserModel.fromMap(String dbid, Map<String, dynamic> map)
      : dbId = dbid,
        buque = map['bucque'],
        nums = map['nums'],
        userId = map['user_id'],
        imgUrl = map['photo_url'],
        rndValue = 0.0;

  Future<void> updateRndValue() async {
    rndValue = await getRndValue(this);
  }
}

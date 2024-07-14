class FbUser {
  final String uid;
  FbUser ({required this.uid});
}

class FbUserData {
  final String? uid;
  final String? name;
  final String? sugars;
  final int? strength;
  FbUserData({this.uid, this.name,this.strength,this.sugars});
}

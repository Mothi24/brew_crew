import 'package:brew_crew/models/fb_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars' : sugars,
      'name' : name,
      'strength' : strength
    });
  }

  // Create Stream to monitor database changes
  Stream<List<Brew>> get brews{
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //Create a list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc.get('name') ?? '',
        sugars: doc.get('sugars') ?? '0',
        strength: doc.get('strength') ?? 0
      );
    } ).toList();
  }

  //Construct FbUserData from snapshot
  FbUserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return FbUserData(
      uid: uid,
      name: snapshot.get('name'),
      sugars: snapshot.get('sugars'),
      strength: snapshot.get('strength'),
    );
  }

  //Get user doc stream
Stream<FbUserData> get userData{
    return brewCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
}

}
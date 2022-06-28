import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference: we didn't create brews collection, so when the time this code runs that collection doesn't exist
  // firestore will go ahead and create anyway.
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) {
    return brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //get brews stream
  Stream<QuerySnapshot> get brews {
    return brewCollection.snapshots();
  }
}

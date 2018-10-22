import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sink/models/entry.dart';

class FirestoreRepository {
  static const String _COLLECTION = "entry";

  static Firestore _db = Firestore.instance;
  static CollectionReference collection = _db.collection(_COLLECTION);

  static Stream<QuerySnapshot> getEntriesSnapshot() {
    return collection.orderBy('date', descending: true).snapshots();
  }

  static Stream<QuerySnapshot> snapshotBetween(DateTime from, DateTime to) {
    return collection
        .where('date', isGreaterThanOrEqualTo: from, isLessThanOrEqualTo: to)
        .snapshots();
  }

  static void create(Entry entry) {
    collection.reference()
        .document(entry.id)
        .setData(entry.toMap());
  }

  static void delete(Entry entry) {
    collection.reference()
        .document(entry.id)
        .delete();
  }
}

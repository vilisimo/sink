import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sink/models/entry.dart';

class FirestoreRepository {
  static const String _ENTRIES_COLLECTION = "entry";

  static Firestore _db = Firestore.instance;
  static CollectionReference entries = _db.collection(_ENTRIES_COLLECTION);

  static Stream<QuerySnapshot> getEntriesSnapshot() {
    return entries.orderBy('date', descending: true).snapshots();
  }

  static Stream<QuerySnapshot> snapshotBetween(DateTime from, DateTime to) {
    return entries
        .where('date', isGreaterThanOrEqualTo: from, isLessThanOrEqualTo: to)
        .snapshots();
  }

  static void create(Entry entry) {
    entries.reference().document(entry.id).setData(entry.toMap());
  }

  static void delete(Entry entry) {
    entries.reference().document(entry.id).delete();
  }
}

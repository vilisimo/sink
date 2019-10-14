import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';

class FirestoreDatabase {
  static Firestore _db = Firestore.instance;

  final String userId;
  final CollectionReference entries;
  final CollectionReference categories;

  FirestoreDatabase._()
      // For testing only
      : this.userId = '',
        this.entries = null,
        this.categories = null;

  FirestoreDatabase(this.userId)
      : this.entries =
            _db.collection("users").document(userId).collection("entry"),
        this.categories =
            _db.collection("users").document(userId).collection("category");

  Stream<QuerySnapshot> getEntriesSnapshot() {
    return entries.orderBy('date', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getFirstEntry() {
    return entries.orderBy('date', descending: false).limit(1).snapshots();
  }

  Stream<QuerySnapshot> snapshotBetween(DateTime from, DateTime to) {
    return entries
        .where('date', isGreaterThanOrEqualTo: from, isLessThanOrEqualTo: to)
        .snapshots();
  }

  void create(Entry entry) {
    entries.reference().document(entry.id).setData(entry.toMap());
  }

  void delete(Entry entry) {
    entries.reference().document(entry.id).delete();
  }

  Future<QuerySnapshot> getCategories() async {
    return categories.orderBy('name', descending: false).getDocuments();
  }

  void createCategory(Category category) {
    categories.reference().document(category.id).setData({
      'id': category.id,
      'name': category.name,
      'icon': category.icon,
      'color': category.color.value,
      'type': category.type.index,
    });
  }
}

class TestFirestoreDatabase extends FirestoreDatabase {
  String userId;

  TestFirestoreDatabase() : super._();
}

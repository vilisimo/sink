import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';

class FirestoreDatabase {
  static Firestore _db = Firestore.instance;

  final String userId;
  final CollectionReference entries;
  final CollectionReference categories;

  FirestoreDatabase(this.userId)
      : this.entries = _db.collection(userId + "/entry"),
        this.categories = _db.collection(userId + "/category");

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

class FirestoreRepository {
  static const String _ENTRIES = "entry";
  static const String _CATEGORIES = "category";

  static Firestore _db = Firestore.instance;
  static CollectionReference entries = _db.collection(_ENTRIES);
  static CollectionReference categories = _db.collection(_CATEGORIES);

  static void createSomething(String data) {
    _db
        .collection("something/entries/antotherthing")
        .reference()
        .document('somedoc')
        .setData({'data': 'abcd', 'number': 124});
  }

  static Stream<QuerySnapshot> getEntriesSnapshot() {
    return entries.orderBy('date', descending: true).snapshots();
  }

  static Stream<QuerySnapshot> getFirstEntry() {
    return entries.orderBy('date', descending: false).limit(1).snapshots();
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

  static Future<QuerySnapshot> getCategories() async {
    return categories.orderBy('name', descending: false).getDocuments();
  }

  static void createCategory(Category category) {
    categories.reference().document(category.id).setData({
      'id': category.id,
      'name': category.name,
      'icon': category.icon,
      'color': category.color.value,
      'type': category.type.index,
    });
  }
}

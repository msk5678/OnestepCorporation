import 'package:moor_flutter/moor_flutter.dart';
part 'moor_database.g.dart';

class NotificationChks extends Table {
  TextColumn get firestoreid => text()();
  DateTimeColumn get uploadtime => dateTime().nullable()();
  TextColumn get entireChecked => text()();
  TextColumn get readChecked => text()();

  @override
  Set<Column> get primaryKey => {firestoreid};
}

@UseDao(tables: [NotificationChks])
class NotificationChksDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationChksDaoMixin {
  NotificationChksDao(AppDatabase db) : super(db);

  Future<List<NotificationChk>> getAllNotification() =>
      select(notificationChks).get();

  Stream<List<NotificationChk>> watchNotification() {
    return (select(notificationChks)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.uploadtime, mode: OrderingMode.desc),
          ])
          ..limit(1, offset: 0))
        .watch();
  }

  Stream<List<NotificationChk>> watchNotificationAll() {
    return (select(notificationChks)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.uploadtime, mode: OrderingMode.desc),
          ])
          ..where((t) => t.readChecked.equals('false')))
        .watch();
  }

  Future insertNotification(NotificationChk notificationChk) =>
      into(notificationChks).insert(notificationChk);

  Future deleteNotification(NotificationChk notificationChk) =>
      delete(notificationChks).delete(notificationChk);

  Future updateNotification(NotificationChk notificationChk) =>
      update(notificationChks).replace(notificationChk);

  Stream<QueryRow> watchsingleNotification(String firestoreid, bool type) =>
      customSelect(
        "SELECT * FROM notification_chks WHERE firestoreid LIKE '$firestoreid' AND read_checked = '$type'",
        readsFrom: {notificationChks},
      ).watchSingle();

  deleteAllNotification() => delete(notificationChks).go();
}

@UseMoor(tables: [NotificationChks], daos: [NotificationChksDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}

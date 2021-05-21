// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class NotificationChk extends DataClass implements Insertable<NotificationChk> {
  final String firestoreid;
  final DateTime uploadtime;
  final String entireChecked;
  final String readChecked;
  NotificationChk(
      {@required this.firestoreid,
      this.uploadtime,
      @required this.entireChecked,
      @required this.readChecked});
  factory NotificationChk.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return NotificationChk(
      firestoreid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}firestoreid']),
      uploadtime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}uploadtime']),
      entireChecked: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}entire_checked']),
      readChecked: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}read_checked']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || firestoreid != null) {
      map['firestoreid'] = Variable<String>(firestoreid);
    }
    if (!nullToAbsent || uploadtime != null) {
      map['uploadtime'] = Variable<DateTime>(uploadtime);
    }
    if (!nullToAbsent || entireChecked != null) {
      map['entire_checked'] = Variable<String>(entireChecked);
    }
    if (!nullToAbsent || readChecked != null) {
      map['read_checked'] = Variable<String>(readChecked);
    }
    return map;
  }

  NotificationChksCompanion toCompanion(bool nullToAbsent) {
    return NotificationChksCompanion(
      firestoreid: firestoreid == null && nullToAbsent
          ? const Value.absent()
          : Value(firestoreid),
      uploadtime: uploadtime == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadtime),
      entireChecked: entireChecked == null && nullToAbsent
          ? const Value.absent()
          : Value(entireChecked),
      readChecked: readChecked == null && nullToAbsent
          ? const Value.absent()
          : Value(readChecked),
    );
  }

  factory NotificationChk.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NotificationChk(
      firestoreid: serializer.fromJson<String>(json['firestoreid']),
      uploadtime: serializer.fromJson<DateTime>(json['uploadtime']),
      entireChecked: serializer.fromJson<String>(json['entireChecked']),
      readChecked: serializer.fromJson<String>(json['readChecked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'firestoreid': serializer.toJson<String>(firestoreid),
      'uploadtime': serializer.toJson<DateTime>(uploadtime),
      'entireChecked': serializer.toJson<String>(entireChecked),
      'readChecked': serializer.toJson<String>(readChecked),
    };
  }

  NotificationChk copyWith(
          {String firestoreid,
          DateTime uploadtime,
          String entireChecked,
          String readChecked}) =>
      NotificationChk(
        firestoreid: firestoreid ?? this.firestoreid,
        uploadtime: uploadtime ?? this.uploadtime,
        entireChecked: entireChecked ?? this.entireChecked,
        readChecked: readChecked ?? this.readChecked,
      );
  @override
  String toString() {
    return (StringBuffer('NotificationChk(')
          ..write('firestoreid: $firestoreid, ')
          ..write('uploadtime: $uploadtime, ')
          ..write('entireChecked: $entireChecked, ')
          ..write('readChecked: $readChecked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      firestoreid.hashCode,
      $mrjc(uploadtime.hashCode,
          $mrjc(entireChecked.hashCode, readChecked.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NotificationChk &&
          other.firestoreid == this.firestoreid &&
          other.uploadtime == this.uploadtime &&
          other.entireChecked == this.entireChecked &&
          other.readChecked == this.readChecked);
}

class NotificationChksCompanion extends UpdateCompanion<NotificationChk> {
  final Value<String> firestoreid;
  final Value<DateTime> uploadtime;
  final Value<String> entireChecked;
  final Value<String> readChecked;
  const NotificationChksCompanion({
    this.firestoreid = const Value.absent(),
    this.uploadtime = const Value.absent(),
    this.entireChecked = const Value.absent(),
    this.readChecked = const Value.absent(),
  });
  NotificationChksCompanion.insert({
    @required String firestoreid,
    this.uploadtime = const Value.absent(),
    @required String entireChecked,
    @required String readChecked,
  })  : firestoreid = Value(firestoreid),
        entireChecked = Value(entireChecked),
        readChecked = Value(readChecked);
  static Insertable<NotificationChk> custom({
    Expression<String> firestoreid,
    Expression<DateTime> uploadtime,
    Expression<String> entireChecked,
    Expression<String> readChecked,
  }) {
    return RawValuesInsertable({
      if (firestoreid != null) 'firestoreid': firestoreid,
      if (uploadtime != null) 'uploadtime': uploadtime,
      if (entireChecked != null) 'entire_checked': entireChecked,
      if (readChecked != null) 'read_checked': readChecked,
    });
  }

  NotificationChksCompanion copyWith(
      {Value<String> firestoreid,
      Value<DateTime> uploadtime,
      Value<String> entireChecked,
      Value<String> readChecked}) {
    return NotificationChksCompanion(
      firestoreid: firestoreid ?? this.firestoreid,
      uploadtime: uploadtime ?? this.uploadtime,
      entireChecked: entireChecked ?? this.entireChecked,
      readChecked: readChecked ?? this.readChecked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (firestoreid.present) {
      map['firestoreid'] = Variable<String>(firestoreid.value);
    }
    if (uploadtime.present) {
      map['uploadtime'] = Variable<DateTime>(uploadtime.value);
    }
    if (entireChecked.present) {
      map['entire_checked'] = Variable<String>(entireChecked.value);
    }
    if (readChecked.present) {
      map['read_checked'] = Variable<String>(readChecked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationChksCompanion(')
          ..write('firestoreid: $firestoreid, ')
          ..write('uploadtime: $uploadtime, ')
          ..write('entireChecked: $entireChecked, ')
          ..write('readChecked: $readChecked')
          ..write(')'))
        .toString();
  }
}

class $NotificationChksTable extends NotificationChks
    with TableInfo<$NotificationChksTable, NotificationChk> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotificationChksTable(this._db, [this._alias]);
  final VerificationMeta _firestoreidMeta =
      const VerificationMeta('firestoreid');
  GeneratedTextColumn _firestoreid;
  @override
  GeneratedTextColumn get firestoreid =>
      _firestoreid ??= _constructFirestoreid();
  GeneratedTextColumn _constructFirestoreid() {
    return GeneratedTextColumn(
      'firestoreid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _uploadtimeMeta = const VerificationMeta('uploadtime');
  GeneratedDateTimeColumn _uploadtime;
  @override
  GeneratedDateTimeColumn get uploadtime =>
      _uploadtime ??= _constructUploadtime();
  GeneratedDateTimeColumn _constructUploadtime() {
    return GeneratedDateTimeColumn(
      'uploadtime',
      $tableName,
      true,
    );
  }

  final VerificationMeta _entireCheckedMeta =
      const VerificationMeta('entireChecked');
  GeneratedTextColumn _entireChecked;
  @override
  GeneratedTextColumn get entireChecked =>
      _entireChecked ??= _constructEntireChecked();
  GeneratedTextColumn _constructEntireChecked() {
    return GeneratedTextColumn(
      'entire_checked',
      $tableName,
      false,
    );
  }

  final VerificationMeta _readCheckedMeta =
      const VerificationMeta('readChecked');
  GeneratedTextColumn _readChecked;
  @override
  GeneratedTextColumn get readChecked =>
      _readChecked ??= _constructReadChecked();
  GeneratedTextColumn _constructReadChecked() {
    return GeneratedTextColumn(
      'read_checked',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [firestoreid, uploadtime, entireChecked, readChecked];
  @override
  $NotificationChksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notification_chks';
  @override
  final String actualTableName = 'notification_chks';
  @override
  VerificationContext validateIntegrity(Insertable<NotificationChk> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('firestoreid')) {
      context.handle(
          _firestoreidMeta,
          firestoreid.isAcceptableOrUnknown(
              data['firestoreid'], _firestoreidMeta));
    } else if (isInserting) {
      context.missing(_firestoreidMeta);
    }
    if (data.containsKey('uploadtime')) {
      context.handle(
          _uploadtimeMeta,
          uploadtime.isAcceptableOrUnknown(
              data['uploadtime'], _uploadtimeMeta));
    }
    if (data.containsKey('entire_checked')) {
      context.handle(
          _entireCheckedMeta,
          entireChecked.isAcceptableOrUnknown(
              data['entire_checked'], _entireCheckedMeta));
    } else if (isInserting) {
      context.missing(_entireCheckedMeta);
    }
    if (data.containsKey('read_checked')) {
      context.handle(
          _readCheckedMeta,
          readChecked.isAcceptableOrUnknown(
              data['read_checked'], _readCheckedMeta));
    } else if (isInserting) {
      context.missing(_readCheckedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {firestoreid};
  @override
  NotificationChk map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return NotificationChk.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NotificationChksTable createAlias(String alias) {
    return $NotificationChksTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $NotificationChksTable _notificationChks;
  $NotificationChksTable get notificationChks =>
      _notificationChks ??= $NotificationChksTable(this);
  NotificationChksDao _notificationChksDao;
  NotificationChksDao get notificationChksDao =>
      _notificationChksDao ??= NotificationChksDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [notificationChks];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$NotificationChksDaoMixin on DatabaseAccessor<AppDatabase> {
  $NotificationChksTable get notificationChks =>
      attachedDatabase.notificationChks;
}

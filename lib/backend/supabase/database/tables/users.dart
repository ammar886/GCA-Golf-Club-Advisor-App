import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  double? get golfHandicap => getField<double>('golf_handicap');
  set golfHandicap(double? value) => setField<double>('golf_handicap', value);

  String? get homeClub => getField<String>('home_club');
  set homeClub(String? value) => setField<String>('home_club', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get clubBrand => getField<String>('club_brand');
  set clubBrand(String? value) => setField<String>('club_brand', value);

  bool? get isBlocked => getField<bool>('is_blocked');
  set isBlocked(bool? value) => setField<bool>('is_blocked', value);
}

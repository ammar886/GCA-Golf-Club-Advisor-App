import '../database.dart';

class GolfCoursesTable extends SupabaseTable<GolfCoursesRow> {
  @override
  String get tableName => 'golf_courses';

  @override
  GolfCoursesRow createRow(Map<String, dynamic> data) => GolfCoursesRow(data);
}

class GolfCoursesRow extends SupabaseDataRow {
  GolfCoursesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GolfCoursesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int? get clubId => getField<int>('club_id');
  set clubId(int? value) => setField<int>('club_id', value);

  double? get lengthM => getField<double>('length_m');
  set lengthM(double? value) => setField<double>('length_m', value);

  double? get lenthF => getField<double>('lenth_f');
  set lenthF(double? value) => setField<double>('lenth_f', value);

  double? get parM => getField<double>('par_m');
  set parM(double? value) => setField<double>('par_m', value);

  String get courseType => getField<String>('course_type')!;
  set courseType(String value) => setField<String>('course_type', value);

  int? get holes => getField<int>('holes');
  set holes(int? value) => setField<int>('holes', value);

  double? get parF => getField<double>('par_f');
  set parF(double? value) => setField<double>('par_f', value);
}

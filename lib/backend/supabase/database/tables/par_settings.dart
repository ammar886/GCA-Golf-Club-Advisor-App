import '../database.dart';

class ParSettingsTable extends SupabaseTable<ParSettingsRow> {
  @override
  String get tableName => 'par_settings';

  @override
  ParSettingsRow createRow(Map<String, dynamic> data) => ParSettingsRow(data);
}

class ParSettingsRow extends SupabaseDataRow {
  ParSettingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ParSettingsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int get value => getField<int>('value')!;
  set value(int value) => setField<int>('value', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

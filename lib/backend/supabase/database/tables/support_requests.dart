import '../database.dart';

class SupportRequestsTable extends SupabaseTable<SupportRequestsRow> {
  @override
  String get tableName => 'support_requests';

  @override
  SupportRequestsRow createRow(Map<String, dynamic> data) =>
      SupportRequestsRow(data);
}

class SupportRequestsRow extends SupabaseDataRow {
  SupportRequestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportRequestsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get subject => getField<String>('subject');
  set subject(String? value) => setField<String>('subject', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);
}

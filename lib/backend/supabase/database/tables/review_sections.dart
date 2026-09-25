import '../database.dart';

class ReviewSectionsTable extends SupabaseTable<ReviewSectionsRow> {
  @override
  String get tableName => 'review_sections';

  @override
  ReviewSectionsRow createRow(Map<String, dynamic> data) =>
      ReviewSectionsRow(data);
}

class ReviewSectionsRow extends SupabaseDataRow {
  ReviewSectionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReviewSectionsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get displayName => getField<String>('display_name')!;
  set displayName(String value) => setField<String>('display_name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  int? get displayOrder => getField<int>('display_order');
  set displayOrder(int? value) => setField<int>('display_order', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

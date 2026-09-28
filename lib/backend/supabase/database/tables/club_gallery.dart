import '../database.dart';

class ClubGalleryTable extends SupabaseTable<ClubGalleryRow> {
  @override
  String get tableName => 'club_gallery';

  @override
  ClubGalleryRow createRow(Map<String, dynamic> data) => ClubGalleryRow(data);
}

class ClubGalleryRow extends SupabaseDataRow {
  ClubGalleryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClubGalleryTable();

  int? get clubId => getField<int>('club_id');
  set clubId(int? value) => setField<int>('club_id', value);

  String? get reviewId => getField<String>('review_id');
  set reviewId(String? value) => setField<String>('review_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  DateTime? get reviewCreatedAt => getField<DateTime>('review_created_at');
  set reviewCreatedAt(DateTime? value) =>
      setField<DateTime>('review_created_at', value);
}

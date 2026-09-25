import '../database.dart';

class GolfClubsTable extends SupabaseTable<GolfClubsRow> {
  @override
  String get tableName => 'golf_clubs';

  @override
  GolfClubsRow createRow(Map<String, dynamic> data) => GolfClubsRow(data);
}

class GolfClubsRow extends SupabaseDataRow {
  GolfClubsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GolfClubsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  double? get overallRating => getField<double>('overall_rating');
  set overallRating(double? value) => setField<double>('overall_rating', value);

  int? get reviewCount => getField<int>('review_count');
  set reviewCount(int? value) => setField<int>('review_count', value);

  int? get holes => getField<int>('holes');
  set holes(int? value) => setField<int>('holes', value);

  int? get par => getField<int>('par');
  set par(int? value) => setField<int>('par', value);

  String? get courseType => getField<String>('course_type');
  set courseType(String? value) => setField<String>('course_type', value);

  String? get greenFee => getField<String>('green_fee');
  set greenFee(String? value) => setField<String>('green_fee', value);

  String? get website => getField<String>('website');
  set website(String? value) => setField<String>('website', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  double? get latitude => getField<double>('latitude');
  set latitude(double? value) => setField<double>('latitude', value);

  double? get longitude => getField<double>('longitude');
  set longitude(double? value) => setField<double>('longitude', value);
}

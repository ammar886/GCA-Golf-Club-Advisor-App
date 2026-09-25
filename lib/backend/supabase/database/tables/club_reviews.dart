import '../database.dart';

class ClubReviewsTable extends SupabaseTable<ClubReviewsRow> {
  @override
  String get tableName => 'club_reviews';

  @override
  ClubReviewsRow createRow(Map<String, dynamic> data) => ClubReviewsRow(data);
}

class ClubReviewsRow extends SupabaseDataRow {
  ClubReviewsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClubReviewsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  int get clubId => getField<int>('club_id')!;
  set clubId(int value) => setField<int>('club_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int? get overallRating => getField<int>('overall_rating');
  set overallRating(int? value) => setField<int>('overall_rating', value);

  String? get comment => getField<String>('comment');
  set comment(String? value) => setField<String>('comment', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get courseId => getField<int>('course_id');
  set courseId(int? value) => setField<int>('course_id', value);

  DateTime? get playedDate => getField<DateTime>('played_date');
  set playedDate(DateTime? value) => setField<DateTime>('played_date', value);

  double? get courseCondition => getField<double>('course_condition');
  set courseCondition(double? value) =>
      setField<double>('course_condition', value);

  double? get greens => getField<double>('greens');
  set greens(double? value) => setField<double>('greens', value);

  double? get fairways => getField<double>('fairways');
  set fairways(double? value) => setField<double>('fairways', value);

  double? get bunkers => getField<double>('bunkers');
  set bunkers(double? value) => setField<double>('bunkers', value);

  double? get layout => getField<double>('layout');
  set layout(double? value) => setField<double>('layout', value);

  double? get challenge => getField<double>('challenge');
  set challenge(double? value) => setField<double>('challenge', value);

  double? get scenery => getField<double>('scenery');
  set scenery(double? value) => setField<double>('scenery', value);

  double? get clubhouse => getField<double>('clubhouse');
  set clubhouse(double? value) => setField<double>('clubhouse', value);

  double? get proShop => getField<double>('pro_shop');
  set proShop(double? value) => setField<double>('pro_shop', value);

  double? get practiceFacilities => getField<double>('practice_facilities');
  set practiceFacilities(double? value) =>
      setField<double>('practice_facilities', value);

  double? get foodAndDrink => getField<double>('food_and_drink');
  set foodAndDrink(double? value) => setField<double>('food_and_drink', value);

  double? get changingRooms => getField<double>('changing_rooms');
  set changingRooms(double? value) => setField<double>('changing_rooms', value);

  double? get drivingRange => getField<double>('driving_range');
  set drivingRange(double? value) => setField<double>('driving_range', value);

  double? get welcome => getField<double>('welcome');
  set welcome(double? value) => setField<double>('welcome', value);

  double? get paceOfPlay => getField<double>('pace_of_play');
  set paceOfPlay(double? value) => setField<double>('pace_of_play', value);

  double? get valueForMoney => getField<double>('value_for_money');
  set valueForMoney(double? value) =>
      setField<double>('value_for_money', value);

  bool? get playAgain => getField<bool>('play_again');
  set playAgain(bool? value) => setField<bool>('play_again', value);

  List<String> get photos => getListField<String>('photos');
  set photos(List<String>? value) => setListField<String>('photos', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);
}

import '../database.dart';

class ClubRatingStatsTable extends SupabaseTable<ClubRatingStatsRow> {
  @override
  String get tableName => 'club_rating_stats';

  @override
  ClubRatingStatsRow createRow(Map<String, dynamic> data) =>
      ClubRatingStatsRow(data);
}

class ClubRatingStatsRow extends SupabaseDataRow {
  ClubRatingStatsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClubRatingStatsTable();

  int get clubId => getField<int>('club_id')!;
  set clubId(int value) => setField<int>('club_id', value);

  int? get reviewCount => getField<int>('review_count');
  set reviewCount(int? value) => setField<int>('review_count', value);

  double? get overallRating => getField<double>('overall_rating');
  set overallRating(double? value) => setField<double>('overall_rating', value);

  double? get avgCourseCondition => getField<double>('avg_course_condition');
  set avgCourseCondition(double? value) =>
      setField<double>('avg_course_condition', value);

  double? get avgGreens => getField<double>('avg_greens');
  set avgGreens(double? value) => setField<double>('avg_greens', value);

  double? get avgFairways => getField<double>('avg_fairways');
  set avgFairways(double? value) => setField<double>('avg_fairways', value);

  double? get avgBunkers => getField<double>('avg_bunkers');
  set avgBunkers(double? value) => setField<double>('avg_bunkers', value);

  double? get avgLayout => getField<double>('avg_layout');
  set avgLayout(double? value) => setField<double>('avg_layout', value);

  double? get avgChallenge => getField<double>('avg_challenge');
  set avgChallenge(double? value) => setField<double>('avg_challenge', value);

  double? get avgScenery => getField<double>('avg_scenery');
  set avgScenery(double? value) => setField<double>('avg_scenery', value);

  double? get avgClubhouse => getField<double>('avg_clubhouse');
  set avgClubhouse(double? value) => setField<double>('avg_clubhouse', value);

  double? get avgProShop => getField<double>('avg_pro_shop');
  set avgProShop(double? value) => setField<double>('avg_pro_shop', value);

  double? get avgPracticeFacilities =>
      getField<double>('avg_practice_facilities');
  set avgPracticeFacilities(double? value) =>
      setField<double>('avg_practice_facilities', value);

  double? get avgFoodAndDrink => getField<double>('avg_food_and_drink');
  set avgFoodAndDrink(double? value) =>
      setField<double>('avg_food_and_drink', value);

  double? get avgChangingRooms => getField<double>('avg_changing_rooms');
  set avgChangingRooms(double? value) =>
      setField<double>('avg_changing_rooms', value);

  double? get avgDrivingRange => getField<double>('avg_driving_range');
  set avgDrivingRange(double? value) =>
      setField<double>('avg_driving_range', value);

  double? get avgWelcome => getField<double>('avg_welcome');
  set avgWelcome(double? value) => setField<double>('avg_welcome', value);

  double? get avgPaceOfPlay => getField<double>('avg_pace_of_play');
  set avgPaceOfPlay(double? value) =>
      setField<double>('avg_pace_of_play', value);

  double? get avgValueForMoney => getField<double>('avg_value_for_money');
  set avgValueForMoney(double? value) =>
      setField<double>('avg_value_for_money', value);

  int? get recommendPercentage => getField<int>('recommend_percentage');
  set recommendPercentage(int? value) =>
      setField<int>('recommend_percentage', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CourseObjStruct extends BaseStruct {
  CourseObjStruct({
    int? holes,
    double? parM,
    double? lengthM,
    double? lengthF,
    CourseType? courseType,
    double? parF,
  })  : _holes = holes,
        _parM = parM,
        _lengthM = lengthM,
        _lengthF = lengthF,
        _courseType = courseType,
        _parF = parF;

  // "holes" field.
  int? _holes;
  int get holes => _holes ?? 0;
  set holes(int? val) => _holes = val;

  void incrementHoles(int amount) => holes = holes + amount;

  bool hasHoles() => _holes != null;

  // "par_m" field.
  double? _parM;
  double get parM => _parM ?? 0.0;
  set parM(double? val) => _parM = val;

  void incrementParM(double amount) => parM = parM + amount;

  bool hasParM() => _parM != null;

  // "length_m" field.
  double? _lengthM;
  double get lengthM => _lengthM ?? 0.0;
  set lengthM(double? val) => _lengthM = val;

  void incrementLengthM(double amount) => lengthM = lengthM + amount;

  bool hasLengthM() => _lengthM != null;

  // "length_f" field.
  double? _lengthF;
  double get lengthF => _lengthF ?? 0.0;
  set lengthF(double? val) => _lengthF = val;

  void incrementLengthF(double amount) => lengthF = lengthF + amount;

  bool hasLengthF() => _lengthF != null;

  // "courseType" field.
  CourseType? _courseType;
  CourseType? get courseType => _courseType;
  set courseType(CourseType? val) => _courseType = val;

  bool hasCourseType() => _courseType != null;

  // "par_f" field.
  double? _parF;
  double get parF => _parF ?? 0.0;
  set parF(double? val) => _parF = val;

  void incrementParF(double amount) => parF = parF + amount;

  bool hasParF() => _parF != null;

  static CourseObjStruct fromMap(Map<String, dynamic> data) => CourseObjStruct(
        holes: castToType<int>(data['holes']),
        parM: castToType<double>(data['par_m']),
        lengthM: castToType<double>(data['length_m']),
        lengthF: castToType<double>(data['length_f']),
        courseType: data['courseType'] is CourseType
            ? data['courseType']
            : deserializeEnum<CourseType>(data['courseType']),
        parF: castToType<double>(data['par_f']),
      );

  static CourseObjStruct? maybeFromMap(dynamic data) => data is Map
      ? CourseObjStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'holes': _holes,
        'par_m': _parM,
        'length_m': _lengthM,
        'length_f': _lengthF,
        'courseType': _courseType?.serialize(),
        'par_f': _parF,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'holes': serializeParam(
          _holes,
          ParamType.int,
        ),
        'par_m': serializeParam(
          _parM,
          ParamType.double,
        ),
        'length_m': serializeParam(
          _lengthM,
          ParamType.double,
        ),
        'length_f': serializeParam(
          _lengthF,
          ParamType.double,
        ),
        'courseType': serializeParam(
          _courseType,
          ParamType.Enum,
        ),
        'par_f': serializeParam(
          _parF,
          ParamType.double,
        ),
      }.withoutNulls;

  static CourseObjStruct fromSerializableMap(Map<String, dynamic> data) =>
      CourseObjStruct(
        holes: deserializeParam(
          data['holes'],
          ParamType.int,
          false,
        ),
        parM: deserializeParam(
          data['par_m'],
          ParamType.double,
          false,
        ),
        lengthM: deserializeParam(
          data['length_m'],
          ParamType.double,
          false,
        ),
        lengthF: deserializeParam(
          data['length_f'],
          ParamType.double,
          false,
        ),
        courseType: deserializeParam<CourseType>(
          data['courseType'],
          ParamType.Enum,
          false,
        ),
        parF: deserializeParam(
          data['par_f'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'CourseObjStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CourseObjStruct &&
        holes == other.holes &&
        parM == other.parM &&
        lengthM == other.lengthM &&
        lengthF == other.lengthF &&
        courseType == other.courseType &&
        parF == other.parF;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([holes, parM, lengthM, lengthF, courseType, parF]);
}

CourseObjStruct createCourseObjStruct({
  int? holes,
  double? parM,
  double? lengthM,
  double? lengthF,
  CourseType? courseType,
  double? parF,
}) =>
    CourseObjStruct(
      holes: holes,
      parM: parM,
      lengthM: lengthM,
      lengthF: lengthF,
      courseType: courseType,
      parF: parF,
    );

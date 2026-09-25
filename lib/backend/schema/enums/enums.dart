import 'package:collection/collection.dart';

enum CourseType {
  Links,
  Parkland,
}

enum CrudOp {
  create,
  edit,
  view,
}

enum AdminTabs {
  home,
  subAdmins,
  profile,
  reviews,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (CourseType):
      return CourseType.values.deserialize(value) as T?;
    case (CrudOp):
      return CrudOp.values.deserialize(value) as T?;
    case (AdminTabs):
      return AdminTabs.values.deserialize(value) as T?;
    default:
      return null;
  }
}

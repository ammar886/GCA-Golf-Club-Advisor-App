import '/components/category_chip/category_chip_widget.dart';
import '/components/course_list_item/course_list_item_widget.dart';
import '/components/section_header/section_header_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'search_widget.dart' show SearchWidget;
import 'package:flutter/material.dart';

class SearchModel extends FlutterFlowModel<SearchWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextField.
  late TextFieldModel textFieldModel;
  // Model for CategoryChip.
  late CategoryChipModel categoryChipModel1;
  // Model for CategoryChip.
  late CategoryChipModel categoryChipModel2;
  // Model for CategoryChip.
  late CategoryChipModel categoryChipModel3;
  // Model for CategoryChip.
  late CategoryChipModel categoryChipModel4;
  // Model for CategoryChip.
  late CategoryChipModel categoryChipModel5;
  // Model for SectionHeader.
  late SectionHeaderModel sectionHeaderModel1;
  // Model for CourseListItem.
  late CourseListItemModel courseListItemModel1;
  // Model for CourseListItem.
  late CourseListItemModel courseListItemModel2;
  // Model for CourseListItem.
  late CourseListItemModel courseListItemModel3;
  // Model for SectionHeader.
  late SectionHeaderModel sectionHeaderModel2;
  // Model for CourseListItem.
  late CourseListItemModel courseListItemModel4;
  // Model for CourseListItem.
  late CourseListItemModel courseListItemModel5;

  @override
  void initState(BuildContext context) {
    textFieldModel = createModel(context, () => TextFieldModel());
    categoryChipModel1 = createModel(context, () => CategoryChipModel());
    categoryChipModel2 = createModel(context, () => CategoryChipModel());
    categoryChipModel3 = createModel(context, () => CategoryChipModel());
    categoryChipModel4 = createModel(context, () => CategoryChipModel());
    categoryChipModel5 = createModel(context, () => CategoryChipModel());
    sectionHeaderModel1 = createModel(context, () => SectionHeaderModel());
    courseListItemModel1 = createModel(context, () => CourseListItemModel());
    courseListItemModel2 = createModel(context, () => CourseListItemModel());
    courseListItemModel3 = createModel(context, () => CourseListItemModel());
    sectionHeaderModel2 = createModel(context, () => SectionHeaderModel());
    courseListItemModel4 = createModel(context, () => CourseListItemModel());
    courseListItemModel5 = createModel(context, () => CourseListItemModel());
  }

  @override
  void dispose() {
    textFieldModel.dispose();
    categoryChipModel1.dispose();
    categoryChipModel2.dispose();
    categoryChipModel3.dispose();
    categoryChipModel4.dispose();
    categoryChipModel5.dispose();
    sectionHeaderModel1.dispose();
    courseListItemModel1.dispose();
    courseListItemModel2.dispose();
    courseListItemModel3.dispose();
    sectionHeaderModel2.dispose();
    courseListItemModel4.dispose();
    courseListItemModel5.dispose();
  }
}

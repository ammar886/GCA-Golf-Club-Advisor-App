import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_styled_border.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/pages/my_reviews/my_reviews_widget.dart';
import 'write_review_model.dart';
export 'write_review_model.dart';

class WriteReviewWidget extends StatefulWidget {
  const WriteReviewWidget({super.key, this.clubDetails});

  final GolfClubsRow? clubDetails;

  static String routeName = 'WriteReview';
  static String routePath = '/writeReview';

  @override
  State<WriteReviewWidget> createState() => _WriteReviewWidgetState();
}

class _WriteReviewWidgetState extends State<WriteReviewWidget> {
  late WriteReviewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WriteReviewModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    if (widget.clubDetails != null) {
      _model.selectedClub = widget.clubDetails;
    } else {
      // If no club passed, query the default / first club
      GolfClubsTable()
          .queryRows(queryFn: (q) => q.order('id', ascending: true).limit(1))
          .then((clubs) {
            if (clubs.isNotEmpty && mounted && _model.selectedClub == null) {
              safeSetState(() {
                _model.selectedClub = clubs.first;
              });
            }
          });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _submitReview() async {
    if (currentUserUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please log in to submit a review.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    if (_model.isSubmitting) return;

    final club = _model.selectedClub ?? widget.clubDetails;
    if (club == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to identify golf club. Please try again.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    // Validation: Played date is REQUIRED
    if (_model.datePicked == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select the date you played.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    // Validation: Would you play here again is REQUIRED
    if (_model.playToggle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select whether you would play here again (Yes / No).',
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    // Validation: Review text is REQUIRED
    final commentText = _model.textController?.text.trim() ?? '';
    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your review text.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    safeSetState(() => _model.isSubmitting = true);

    try {
      final playedDateStr = dateTimeFormat("yyyy-MM-dd", _model.datePicked);

      // overall_rating in Supabase is smallint, so send integer to prevent invalid input syntax for smallint
      final overallRatingInt = (_model.ratingBarValue1 ?? 0.0).round().toInt();

      final fullData = <String, dynamic>{
        'club_id': club.id,
        'user_id': currentUserUid,
        'overall_rating': overallRatingInt,
        'status': 'pending',
        'course_condition': (_model.ratingBarValue2 ?? 0.0).toDouble(),
        'greens': (_model.ratingBarValue3 ?? 0.0).toDouble(),
        'fairways': (_model.ratingBarValue4 ?? 0.0).toDouble(),
        'bunkers': (_model.ratingBarValue5 ?? 0.0).toDouble(),
        'layout': (_model.ratingBarValue6 ?? 0.0).toDouble(),
        'challenge': (_model.ratingBarValue7 ?? 0.0).toDouble(),
        'scenery': (_model.ratingBarValue8 ?? 0.0).toDouble(),
        'clubhouse': (_model.ratingBarValue9 ?? 0.0).toDouble(),
        'pro_shop': (_model.ratingBarValue10 ?? 0.0).toDouble(),
        'practice_facilities': (_model.ratingBarValue11 ?? 0.0).toDouble(),
        'food_and_drink': (_model.ratingBarValue12 ?? 0.0).toDouble(),
        'changing_rooms': (_model.ratingBarValue13 ?? 0.0).toDouble(),
        'driving_range': (_model.ratingBarValue14 ?? 0.0).toDouble(),
        'welcome': (_model.ratingBarValue15 ?? 0.0).toDouble(),
        'pace_of_play': (_model.ratingBarValue16 ?? 0.0).toDouble(),
        'value_for_money': (_model.ratingBarValue17 ?? 0.0).toDouble(),
        'play_again': _model.playToggle ?? true,
        'comment': commentText,
        'photos': _model.uploadedPhotoUrls,
        'played_date': playedDateStr,
      };

      try {
        await ClubReviewsTable().insert(fullData);
      } catch (insertErr) {
        final errStr = insertErr.toString();
        // Check constraint error if remote DB constraint hasn't been updated to allow 0
        if (errStr.contains('club_reviews_overall_rating_check')) {
          throw Exception(
            'Your database constraint requires an overall rating between 1 and 5. '
            'Please run the updated SQL migration in Supabase or select 1 to 5 stars.',
          );
        }
        // Fallback for base schema if migration hasn't been run yet
        if (errStr.contains('PGRST204') || errStr.contains('column')) {
          await ClubReviewsTable().insert({
            'club_id': club.id,
            'user_id': currentUserUid,
            'overall_rating': overallRatingInt,
            'comment': commentText,
          });
        } else {
          rethrow;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Your review has been submitted and is pending approval!',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );

        context.pushNamed(MyReviewsWidget.routeName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit review: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } finally {
      if (mounted) {
        safeSetState(() => _model.isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final club = _model.selectedClub ?? widget.clubDetails;
    final clubName = club?.name ?? 'Golf Club';
    final clubLocation = [
      if (club?.city != null && club!.city!.isNotEmpty) club.city,
      if (club?.country != null && club!.country!.isNotEmpty) club.country,
    ].join(', ');
    final clubImage =
        club?.imageUrl ??
        'https://dimg.dreamflow.cloud/v1/image/luxury%20golf%20course%20green%20with%20sand%20trap';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.arrow_back,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () {
                              context.safePop();
                            },
                          ),
                          Text(
                            'Write a Review',
                            style: FlutterFlowTheme.of(context).titleMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(
                                      context,
                                    ).titleMedium.fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  lineHeight: 1.5,
                                ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: _submitReview,
                            child: _model.isSubmitting
                                ? SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Submit',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).primary,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 30.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                shape: BoxShape.rectangle,
                              ),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 0),
                                fadeOutDuration: Duration(milliseconds: 0),
                                imageUrl: clubImage,
                                fit: BoxFit.cover,
                                alignment: Alignment(0.0, 0.0),
                                errorWidget: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.golf_course,
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).primary,
                                      size: 32.0,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clubName,
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).titleMedium.fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        lineHeight: 1.5,
                                      ),
                                ),
                                if (clubLocation.isNotEmpty)
                                  Text(
                                    clubLocation,
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodySmall.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodySmall.fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).secondaryText,
                                          letterSpacing: 0.0,
                                          lineHeight: 1.6,
                                        ),
                                  ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 16.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'When did you play? *',
                            style: FlutterFlowTheme.of(context).bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(
                                      context,
                                    ).bodyMedium.fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final _datePickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    _model.datePicked ?? getCurrentTimestamp,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2050),
                                builder: (context, child) {
                                  return wrapInMaterialDatePickerTheme(
                                    context,
                                    child!,
                                    headerBackgroundColor: FlutterFlowTheme.of(
                                      context,
                                    ).primary,
                                    headerForegroundColor: FlutterFlowTheme.of(
                                      context,
                                    ).info,
                                    headerTextStyle:
                                        FlutterFlowTheme.of(
                                          context,
                                        ).headlineLarge.override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).headlineLarge.fontStyle,
                                          ),
                                          fontSize: 32.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    pickerBackgroundColor: FlutterFlowTheme.of(
                                      context,
                                    ).secondaryBackground,
                                    pickerForegroundColor: FlutterFlowTheme.of(
                                      context,
                                    ).primaryText,
                                    selectedDateTimeBackgroundColor:
                                        FlutterFlowTheme.of(context).primary,
                                    selectedDateTimeForegroundColor:
                                        FlutterFlowTheme.of(context).info,
                                    actionButtonForegroundColor:
                                        FlutterFlowTheme.of(
                                          context,
                                        ).primaryText,
                                    iconSize: 24.0,
                                  );
                                },
                              );

                              if (_datePickedDate != null) {
                                safeSetState(() {
                                  _model.datePicked = DateTime(
                                    _datePickedDate.year,
                                    _datePickedDate.month,
                                    _datePickedDate.day,
                                  );
                                });
                              }
                            },
                            child: Text(
                              _model.datePicked != null
                                  ? dateTimeFormat("yMMMd", _model.datePicked)
                                  : 'Select date *',
                              style: FlutterFlowTheme.of(context).bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).bodyMedium.fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overall Rating',
                            style: FlutterFlowTheme.of(context).titleSmall
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(
                                      context,
                                    ).titleSmall.fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  lineHeight: 1.5,
                                ),
                          ),
                          RatingBar.builder(
                            onRatingUpdate: (newValue) => safeSetState(
                              () => _model.ratingBarValue1 = newValue,
                            ),
                            itemBuilder: (context, index) => Icon(
                              Icons.star_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            direction: Axis.horizontal,
                            initialRating: _model.ratingBarValue1 ??= 0.0,
                            unratedColor: FlutterFlowTheme.of(context).accent1,
                            itemCount: 5,
                            itemSize: 24.0,
                            glowColor: FlutterFlowTheme.of(context).primary,
                            minRating: 0.0,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.golf_course,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24.0,
                              ),
                              Text(
                                'COURSE',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ].divide(SizedBox(width: 6.0)),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              4.0,
                              0.0,
                              0.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Course condition',
                                  style: FlutterFlowTheme.of(context).bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                RatingBar.builder(
                                  onRatingUpdate: (newValue) => safeSetState(
                                    () => _model.ratingBarValue2 = newValue,
                                  ),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star_rounded,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  direction: Axis.horizontal,
                                  initialRating: _model.ratingBarValue2 ??= 0.0,
                                  unratedColor: FlutterFlowTheme.of(
                                    context,
                                  ).accent1,
                                  itemCount: 5,
                                  itemSize: 18.0,
                                  glowColor: FlutterFlowTheme.of(
                                    context,
                                  ).primary,
                                  minRating: 0.0,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Greens',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue3 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue3 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Fairways',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue4 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue4 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bunkers',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue5 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue5 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Layout',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue6 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue6 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Challenge',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue7 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue7 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Scenery',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue8 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue8 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.house_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24.0,
                              ),
                              Text(
                                'FACILITIES',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ].divide(SizedBox(width: 6.0)),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              4.0,
                              0.0,
                              0.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Clubhouse',
                                  style: FlutterFlowTheme.of(context).bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                RatingBar.builder(
                                  onRatingUpdate: (newValue) => safeSetState(
                                    () => _model.ratingBarValue9 = newValue,
                                  ),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star_rounded,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  direction: Axis.horizontal,
                                  initialRating: _model.ratingBarValue9 ??= 0.0,
                                  unratedColor: FlutterFlowTheme.of(
                                    context,
                                  ).accent1,
                                  itemCount: 5,
                                  itemSize: 18.0,
                                  glowColor: FlutterFlowTheme.of(
                                    context,
                                  ).primary,
                                  minRating: 0.0,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pro shop',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue10 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue10 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Practice facilities',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue11 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue11 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Food & drink',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue12 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue12 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Changing rooms',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue13 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue13 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Driving range',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue14 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue14 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.smile,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24.0,
                              ),
                              Text(
                                'EXPERIENCE',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ].divide(SizedBox(width: 6.0)),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              4.0,
                              0.0,
                              0.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Welcome',
                                  style: FlutterFlowTheme.of(context).bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                RatingBar.builder(
                                  onRatingUpdate: (newValue) => safeSetState(
                                    () => _model.ratingBarValue15 = newValue,
                                  ),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star_rounded,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  direction: Axis.horizontal,
                                  initialRating: _model.ratingBarValue15 ??=
                                      0.0,
                                  unratedColor: FlutterFlowTheme.of(
                                    context,
                                  ).accent1,
                                  itemCount: 5,
                                  itemSize: 18.0,
                                  glowColor: FlutterFlowTheme.of(
                                    context,
                                  ).primary,
                                  minRating: 0.0,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pace of play',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue16 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue16 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Value for money',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              RatingBar.builder(
                                onRatingUpdate: (newValue) => safeSetState(
                                  () => _model.ratingBarValue17 = newValue,
                                ),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                direction: Axis.horizontal,
                                initialRating: _model.ratingBarValue17 ??= 0.0,
                                unratedColor: FlutterFlowTheme.of(
                                  context,
                                ).accent1,
                                itemCount: 5,
                                itemSize: 18.0,
                                glowColor: FlutterFlowTheme.of(context).primary,
                                minRating: 0.0,
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                      Text(
                        'Would you play here again? *',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).bodyMedium.fontStyle,
                          ),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.playToggle = true;
                                safeSetState(() {});
                              },
                              child: Container(
                                width: 100.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: _model.playToggle == true
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(
                                            context,
                                          ).secondaryText,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.thumb_up_off_alt,
                                      color: _model.playToggle == true
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(
                                              context,
                                            ).secondaryText,
                                      size: 18.0,
                                    ),
                                    Text(
                                      'Yes',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontStyle,
                                            ),
                                            color: _model.playToggle == true
                                                ? FlutterFlowTheme.of(
                                                    context,
                                                  ).primary
                                                : FlutterFlowTheme.of(
                                                    context,
                                                  ).secondaryText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                          ),
                                    ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.playToggle = false;
                                safeSetState(() {});
                              },
                              child: Container(
                                width: 100.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: _model.playToggle == false
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(
                                            context,
                                          ).secondaryText,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.thumb_down_outlined,
                                      color: _model.playToggle == false
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(
                                              context,
                                            ).secondaryText,
                                      size: 18.0,
                                    ),
                                    Text(
                                      'No',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontStyle,
                                            ),
                                            color: _model.playToggle == false
                                                ? FlutterFlowTheme.of(
                                                    context,
                                                  ).primary
                                                : FlutterFlowTheme.of(
                                                    context,
                                                  ).secondaryText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                          ),
                                    ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                      Text(
                        'Your review *',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).bodyMedium.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: false,
                          enabled: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Share your experience...',
                            hintStyle: FlutterFlowTheme.of(context).labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(
                                      context,
                                    ).labelMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(
                                      context,
                                    ).labelMedium.fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(
                                    context,
                                  ).labelMedium.fontWeight,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(
                              context,
                            ).secondaryBackground,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(
                                    context,
                                  ).bodyMedium.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(
                                    context,
                                  ).bodyMedium.fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(
                                  context,
                                ).bodyMedium.fontWeight,
                              ),
                          maxLines: null,
                          minLines: 3,
                          maxLength: 1000,
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          enableInteractiveSelection: true,
                          validator: _model.textControllerValidator.asValidator(
                            context,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Add Photos',
                            style: FlutterFlowTheme.of(context).bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(
                                      context,
                                    ).bodyMedium.fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            '(optional)',
                            style: FlutterFlowTheme.of(context).bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(
                                      context,
                                    ).bodyMedium.fontStyle,
                                  ),
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ].divide(SizedBox(width: 2.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final selectedMedia =
                                  await selectMediaWithSourceBottomSheet(
                                    context: context,
                                    allowPhoto: true,
                                  );
                              if (selectedMedia != null &&
                                  selectedMedia.isNotEmpty) {
                                safeSetState(
                                  () => _model.isUploadingPhoto = true,
                                );
                                try {
                                  final downloadUrls =
                                      await uploadSupabaseStorageFiles(
                                        bucketName: 'golfClub',
                                        selectedFiles: selectedMedia,
                                      );
                                  safeSetState(() {
                                    _model.uploadedPhotoUrls.addAll(
                                      downloadUrls,
                                    );
                                  });
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to upload photo: $e',
                                        ),
                                        backgroundColor: FlutterFlowTheme.of(
                                          context,
                                        ).error,
                                      ),
                                    );
                                  }
                                } finally {
                                  safeSetState(
                                    () => _model.isUploadingPhoto = false,
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(
                                  context,
                                ).secondaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
                                border: FlutterFlowStyledBorder(
                                  side: BorderSide(
                                    color: FlutterFlowTheme.of(
                                      context,
                                    ).primaryText,
                                  ),
                                  style: FlutterFlowDashStyle.dashed,
                                  dashLength: 6.0,
                                  dashGap: 4.0,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 16.0,
                                  ),
                                  Text(
                                    'Add Photo',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).primary,
                                          fontSize: 10.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontWeight,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 6.0)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (_model.isUploadingPhoto)
                                    Container(
                                      width: 80.0,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).secondaryBackground,
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: 24.0,
                                        height: 24.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).primary,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ..._model.uploadedPhotoUrls.map(
                                    (photoUrl) => Container(
                                      height: 80.0,
                                      child: Stack(
                                        alignment: AlignmentDirectional(
                                          1.0,
                                          -1.0,
                                        ),
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(
                                              0.0,
                                              0.0,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: CachedNetworkImage(
                                                imageUrl: photoUrl,
                                                width: 80.0,
                                                height: 70.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional(
                                              1.0,
                                              -1.0,
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                    8.0,
                                                  ),
                                              child: InkWell(
                                                onTap: () {
                                                  safeSetState(() {
                                                    _model.uploadedPhotoUrls
                                                        .remove(photoUrl);
                                                  });
                                                },
                                                child: Container(
                                                  width: 22.0,
                                                  height: 22.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).secondaryBackground,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).primaryText,
                                                    size: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                    ].divide(SizedBox(height: 16.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'my_reviews_model.dart';

export 'my_reviews_model.dart';

class MyReviewsWidget extends StatefulWidget {
  const MyReviewsWidget({super.key});

  static String routeName = 'MyReviews';
  static String routePath = '/myReviews';

  @override
  State<MyReviewsWidget> createState() => _MyReviewsWidgetState();
}

class _MyReviewsWidgetState extends State<MyReviewsWidget> {
  late MyReviewsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyReviewsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserReviews();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadUserReviews() async {
    safeSetState(() => _model.isLoading = true);

    try {
      final reviews = await ClubReviewsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('user_id', currentUserUid)
            .order('created_at', ascending: false),
      );

      _model.userReviews = reviews;

      // Extract unique club IDs to fetch club metadata
      final clubIds = reviews.map((r) => r.clubId).toSet().toList();

      if (clubIds.isNotEmpty) {
        final clubs = await GolfClubsTable().queryRows(
          queryFn: (q) => q.inFilterOrNull('id', clubIds),
        );

        _model.clubMap = {
          for (var club in clubs) club.id: club,
        };
      }
    } catch (e) {
      debugPrint('Error loading user reviews: $e');
    } finally {
      if (mounted) {
        safeSetState(() => _model.isLoading = false);
      }
    }
  }

  List<ClubReviewsRow> get _filteredReviews {
    final all = _model.userReviews ?? [];

    if (_model.currentFilter == 'All') {
      return all;
    }

    return all
        .where(
          (r) =>
              (r.status ?? 'pending').toLowerCase() ==
              _model.currentFilter.toLowerCase(),
        )
        .toList();
  }

  int _countByStatus(String status) {
    final all = _model.userReviews ?? [];

    if (status == 'All') {
      return all.length;
    }

    return all
        .where(
          (r) => (r.status ?? 'pending').toLowerCase() == status.toLowerCase(),
        )
        .length;
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color border;
    Color text;
    IconData icon;
    String label;

    switch (status.toLowerCase()) {
      case 'approved':
        bg = const Color(0x1F10B981);
        border = const Color(0xFF10B981);
        text = const Color(0xFF059669);
        icon = Icons.check_circle_rounded;
        label = 'Approved';
        break;

      case 'rejected':
        bg = const Color(0x1FEF4444);
        border = const Color(0xFFEF4444);
        text = const Color(0xFFDC2626);
        icon = Icons.cancel_rounded;
        label = 'Rejected';
        break;

      case 'pending':
      default:
        bg = const Color(0x22F59E0B);
        border = const Color(0xFFF59E0B);
        text = const Color(0xFFD97706);
        icon = Icons.hourglass_top_rounded;
        label = 'Pending Approval';
        break;
    }

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(
        8.0,
        4.0,
        10.0,
        4.0,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: border,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: text,
            size: 14.0,
          ),
          const SizedBox(width: 4.0),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String key) {
    final isSelected = _model.currentFilter == key;
    final count = _countByStatus(key);

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        safeSetState(() => _model.currentFilter = key);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? FlutterFlowTheme.of(context).onPrimary
                    : FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            const SizedBox(width: 6.0),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.25)
                    : FlutterFlowTheme.of(context).alternate,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? FlutterFlowTheme.of(context).onPrimary
                      : FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubRatingRow(String label, double? score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.0,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 14.0,
              ),
              const SizedBox(width: 3.0),
              Text(
                (score ?? 0.0).toStringAsFixed(1),
                style: GoogleFonts.inter(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ClubReviewsRow review) {
    final club = _model.clubMap[review.clubId];

    final clubName = club?.name ?? 'Golf Club #${review.clubId}';

    final clubLocation = [
      if (club?.city != null && club!.city!.isNotEmpty) club.city,
      if (club?.country != null && club!.country!.isNotEmpty) club.country,
    ].join(', ');

    final clubImage = club?.imageUrl ??
        'https://dimg.dreamflow.cloud/v1/image/luxury%20golf%20course%20green%20with%20sand%20trap';

    // FlutterFlow currently generates id as String?,
    // although the Supabase column itself is NOT NULL.
    final reviewId = review.id;

    final isExpanded =
        reviewId != null && _model.expandedReviewIds.contains(reviewId);

    final playedDateStr = review.playedDate != null
        ? dateTimeFormat("yMMMd", review.playedDate)
        : null;

    final createdDateStr = review.createdAt != null
        ? dateTimeFormat("yMMMd", review.createdAt)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Club Info + Status Badge
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: clubImage,
                    width: 54.0,
                    height: 54.0,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 54.0,
                      height: 54.0,
                      color: FlutterFlowTheme.of(context).alternate,
                      child: Icon(
                        Icons.golf_course,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clubName,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (clubLocation.isNotEmpty)
                        Text(
                          clubLocation,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 6.0),

                      // status is nullable in the generated model,
                      // so use the DB default as fallback.
                      _buildStatusBadge(
                        review.status ?? 'pending',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).alternate,
          ),

          // Rating & Dates Row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    RatingBarIndicator(
                      // overall_rating is smallint in Supabase.
                      // RatingBarIndicator requires a double.
                      rating: (review.overallRating ?? 0).toDouble(),
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      itemCount: 5,
                      itemSize: 18.0,
                      direction: Axis.horizontal,
                      unratedColor: FlutterFlowTheme.of(context).accent1,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      (review.overallRating ?? 0).toDouble().toStringAsFixed(1),
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (playedDateStr != null)
                      Text(
                        'Played: $playedDateStr',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (createdDateStr != null)
                      Text(
                        'Posted: $createdDateStr',
                        style: GoogleFonts.inter(
                          fontSize: 10.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Comment
          if (review.comment != null && review.comment!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: Text(
                review.comment!,
                style: GoogleFonts.inter(
                  fontSize: 13.0,
                  height: 1.5,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ),

          // Photos
          if (review.photos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: SizedBox(
                height: 60.0,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8.0),
                  itemBuilder: (context, idx) {
                    final photoUrl = review.photos[idx];

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: photoUrl,
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          width: 60.0,
                          height: 60.0,
                          color: FlutterFlowTheme.of(context).alternate,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 20.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Play Again Badge
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Icon(
                  (review.playAgain ?? true)
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_down_alt_rounded,
                  size: 14.0,
                  color: (review.playAgain ?? true)
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                ),
                const SizedBox(width: 6.0),
                Text(
                  (review.playAgain ?? true)
                      ? 'Would play here again'
                      : 'Would not play here again',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: (review.playAgain ?? true)
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ),

          // Detailed Breakdown Accordion Toggle
          InkWell(
            onTap: () {
              if (reviewId == null) {
                return;
              }

              safeSetState(() {
                if (isExpanded) {
                  _model.expandedReviewIds.remove(reviewId);
                } else {
                  _model.expandedReviewIds.add(reviewId);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .primaryBackground
                    .withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isExpanded
                        ? 'Hide rating breakdown'
                        : 'View rating breakdown',
                    style: GoogleFonts.inter(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 18.0,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Breakdown Section
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(16.0),
              color: FlutterFlowTheme.of(context)
                  .primaryBackground
                  .withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Category
                  Row(
                    children: [
                      Icon(
                        Icons.golf_course,
                        size: 16.0,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'COURSE',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6.0),

                  _buildSubRatingRow(
                    'Course Condition',
                    review.courseCondition,
                  ),
                  _buildSubRatingRow(
                    'Greens',
                    review.greens,
                  ),
                  _buildSubRatingRow(
                    'Fairways',
                    review.fairways,
                  ),
                  _buildSubRatingRow(
                    'Bunkers',
                    review.bunkers,
                  ),
                  _buildSubRatingRow(
                    'Layout',
                    review.layout,
                  ),
                  _buildSubRatingRow(
                    'Challenge',
                    review.challenge,
                  ),
                  _buildSubRatingRow(
                    'Scenery',
                    review.scenery,
                  ),

                  const SizedBox(height: 12.0),

                  // Facilities Category
                  Row(
                    children: [
                      Icon(
                        Icons.house_rounded,
                        size: 16.0,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'FACILITIES',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6.0),

                  _buildSubRatingRow(
                    'Clubhouse',
                    review.clubhouse,
                  ),
                  _buildSubRatingRow(
                    'Pro shop',
                    review.proShop,
                  ),
                  _buildSubRatingRow(
                    'Practice facilities',
                    review.practiceFacilities,
                  ),
                  _buildSubRatingRow(
                    'Food & drink',
                    review.foodAndDrink,
                  ),
                  _buildSubRatingRow(
                    'Changing rooms',
                    review.changingRooms,
                  ),
                  _buildSubRatingRow(
                    'Driving range',
                    review.drivingRange,
                  ),

                  const SizedBox(height: 12.0),

                  // Experience Category
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.faceSmile,
                        size: 14.0,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'EXPERIENCE',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6.0),

                  _buildSubRatingRow(
                    'Welcome',
                    review.welcome,
                  ),
                  _buildSubRatingRow(
                    'Pace of play',
                    review.paceOfPlay,
                  ),
                  _buildSubRatingRow(
                    'Value for money',
                    review.valueForMoney,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 60.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.rate_review_outlined,
                color: FlutterFlowTheme.of(context).primary,
                size: 40.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              _model.currentFilter == 'All'
                  ? 'No reviews yet'
                  : 'No ${_model.currentFilter.toLowerCase()} reviews',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              _model.currentFilter == 'All'
                  ? 'Your posted reviews for golf courses and clubs will appear here. Newly posted reviews will initially have pending status.'
                  : 'No reviews found under the selected filter.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                color: FlutterFlowTheme.of(context).secondaryText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24.0),
            FFButtonWidget(
              onPressed: () {
                context.safePop();
              },
              text: 'Explore Golf Clubs',
              options: FFButtonOptions(
                width: 180.0,
                height: 42.0,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: GoogleFonts.inter(
                  color: FlutterFlowTheme.of(context).onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredReviews;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        elevation: 0.5,
        leading: FlutterFlowIconButton(
          buttonSize: 40.0,
          fillColor: Colors.transparent,
          icon: Icon(
            Icons.arrow_back,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 24.0,
          ),
          onPressed: () => context.safePop(),
        ),
        title: Text(
          'My Reviews',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 22.0,
            ),
            onPressed: _loadUserReviews,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserReviews,
          color: FlutterFlowTheme.of(context).primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filter Chips
              Container(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                padding: const EdgeInsets.fromLTRB(
                  16.0,
                  12.0,
                  16.0,
                  14.0,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'All'),
                      const SizedBox(width: 8.0),
                      _buildFilterChip('Pending', 'pending'),
                      const SizedBox(width: 8.0),
                      _buildFilterChip('Approved', 'approved'),
                      const SizedBox(width: 8.0),
                      _buildFilterChip('Rejected', 'rejected'),
                    ],
                  ),
                ),
              ),

              // Reviews Content
              Expanded(
                child: _model.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    : filtered.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              return _buildReviewCard(
                                filtered[index],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

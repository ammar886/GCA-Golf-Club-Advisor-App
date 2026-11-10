import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/components/navbar_widget.dart';
import '/components/review_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reviews_management_model.dart';
export 'reviews_management_model.dart';

class ReviewsManagementWidget extends StatefulWidget {
  const ReviewsManagementWidget({
    super.key,
    this.loadReviews,
    this.reviewItemBuilder,
  });

  final Future<List<ClubReviewsRow>> Function()? loadReviews;
  final Widget Function(ClubReviewsRow review, int index)? reviewItemBuilder;

  static String routeName = 'reviewsManagement';
  static String routePath = '/reviewsManagement';

  static List<ClubReviewsRow> filterByStatus(
    List<ClubReviewsRow> reviews,
    String status,
  ) {
    final target = status.trim().toLowerCase();
    return reviews
        .where((r) => (r.status ?? '').trim().toLowerCase() == target)
        .toList();
  }

  @override
  State<ReviewsManagementWidget> createState() =>
      _ReviewsManagementWidgetState();
}

class _ReviewsManagementWidgetState extends State<ReviewsManagementWidget>
    with TickerProviderStateMixin {
  late ReviewsManagementModel _model;
  late Future<List<ClubReviewsRow>> _reviewsFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewsManagementModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    _reviewsFuture = _fetchReviews();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<List<ClubReviewsRow>> _fetchReviews() {
    if (widget.loadReviews != null) {
      return widget.loadReviews!();
    }
    return ClubReviewsTable().queryRows(
      queryFn: (q) => q.order('created_at'),
    );
  }

  Future<void> _refreshReviews() async {
    final future = _fetchReviews();
    safeSetState(() {
      _reviewsFuture = future;
    });
    await future;
  }

  Widget _buildReviewsList(
    List<ClubReviewsRow> reviews, {
    required String emptyMessage,
  }) {
    if (reviews.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshReviews,
        color: FlutterFlowTheme.of(context).primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 64.0),
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 48.0,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                const SizedBox(height: 12.0),
                Text(
                  emptyMessage,
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshReviews,
      color: FlutterFlowTheme.of(context).primary,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 20.0, 12.0, 24.0),
        scrollDirection: Axis.vertical,
        itemCount: reviews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16.0),
        itemBuilder: (context, listViewIndex) {
          final review = reviews[listViewIndex];
          if (widget.reviewItemBuilder != null) {
            return widget.reviewItemBuilder!(review, listViewIndex);
          }
          final modelKey = review.id ?? 'idx_$listViewIndex';
          return wrapWithModel(
            model: _model.reviewModels.getModel(
              modelKey,
              listViewIndex,
            ),
            updateCallback: () => safeSetState(() {}),
            child: ReviewWidget(
              key: Key('Key9fp_$modelKey'),
              reviewDetails: review,
              onReturned: _refreshReviews,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Reviews',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 22.0,
              ),
              onPressed: _refreshReviews,
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                child: TabBar(
                  controller: _model.tabBarController,
                  labelColor: FlutterFlowTheme.of(context).primary,
                  unselectedLabelColor:
                      FlutterFlowTheme.of(context).secondaryText,
                  labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                        ),
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  unselectedLabelStyle:
                      FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                            ),
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                  indicatorColor: FlutterFlowTheme.of(context).primary,
                  indicatorWeight: 3.0,
                  tabs: const [
                    Tab(text: 'Pending Reviews'),
                    Tab(text: 'Approved Reviews'),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<ClubReviewsRow>>(
                  future: _reviewsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load reviews.',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      );
                    }
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      );
                    }
                    final allReviews = snapshot.data!;
                    final pendingReviews =
                        ReviewsManagementWidget.filterByStatus(
                            allReviews, 'pending');
                    final approvedReviews =
                        ReviewsManagementWidget.filterByStatus(
                            allReviews, 'approved');

                    return TabBarView(
                      controller: _model.tabBarController,
                      children: [
                        _buildReviewsList(
                          pendingReviews,
                          emptyMessage: 'No pending reviews',
                        ),
                        _buildReviewsList(
                          approvedReviews,
                          emptyMessage: 'No approved reviews',
                        ),
                      ],
                    );
                  },
                ),
              ),
              wrapWithModel(
                model: _model.navbarModel,
                updateCallback: () => safeSetState(() {}),
                child: NavbarWidget(
                  tabSelected: AdminTabs.reviews,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

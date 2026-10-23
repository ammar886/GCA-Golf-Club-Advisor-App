import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'user_management_model.dart';
export 'user_management_model.dart';

class UserManagementWidget extends StatefulWidget {
  const UserManagementWidget({super.key});

  static String routeName = 'userManagement';
  static String routePath = '/userManagement';

  @override
  State<UserManagementWidget> createState() => _UserManagementWidgetState();
}

class _UserManagementWidgetState extends State<UserManagementWidget> {
  late UserManagementModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  bool _isAdmin = false;
  List<UsersRow> _allUsers = [];
  Set<String> _activeUserIdsToday = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserManagementModel());
    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _checkAdminAndFetchData();
    });
  }

  Future<void> _checkAdminAndFetchData() async {
    safeSetState(() => _isLoading = true);

    // 1. Role verification: Verify that user is strictly an admin
    bool hasAdminRole = FFAppState().currentRole == 'admin';

    if (!hasAdminRole && currentUserUid.isNotEmpty) {
      try {
        final currentRows = await UsersTable().queryRows(
          queryFn: (q) => q.eqOrNull('id', currentUserUid),
        );
        final userRole = currentRows.firstOrNull?.role;
        if (userRole == 'admin') {
          FFAppState().currentRole = 'admin';
          hasAdminRole = true;
        }
      } catch (e) {
        debugPrint('Error verifying admin role: $e');
      }
    }

    if (!hasAdminRole) {
      safeSetState(() {
        _isAdmin = false;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Access restricted: Administrator privileges required.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: Duration(seconds: 3),
          ),
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed(HomeWidget.routeName);
        }
      }
      return;
    }

    _isAdmin = true;

    // 2. Fetch all users from Supabase
    try {
      final users = await UsersTable().queryRows(
        queryFn: (q) => q.order('created_at', ascending: false),
      );

      // 3. Determine active users today
      // Activity is derived from:
      // a) Account creation date within 24 hours or today
      // b) Any club reviews created today
      // c) The currently logged in user
      final now = DateTime.now();
      final activeIds = <String>{};

      // Current active user is always active today
      if (currentUserUid.isNotEmpty) {
        activeIds.add(currentUserUid);
      }

      for (final u in users) {
        if (u.createdAt != null) {
          final diff = now.difference(u.createdAt!);
          final isSameDay = u.createdAt!.year == now.year &&
              u.createdAt!.month == now.month &&
              u.createdAt!.day == now.day;
          if (isSameDay || diff.inHours < 24) {
            if (u.id != null) activeIds.add(u.id!);
          }
        }
      }

      try {
        final todayReviews = await ClubReviewsTable().queryRows(
          queryFn: (q) => q.order('created_at', ascending: false).limit(100),
        );
        for (final r in todayReviews) {
          if (r.createdAt != null) {
            final diff = now.difference(r.createdAt!);
            final isSameDay = r.createdAt!.year == now.year &&
                r.createdAt!.month == now.month &&
                r.createdAt!.day == now.day;
            if (isSameDay || diff.inHours < 24) {
              activeIds.add(r.userId);
            }
          }
        }
      } catch (e) {
        debugPrint('Could not fetch reviews for activity: $e');
      }

      safeSetState(() {
        _allUsers = users;
        _activeUserIdsToday = activeIds;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching users: $e');
      safeSetState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  List<UsersRow> get _filteredUsers {
    return _allUsers.where((user) {
      // Role filter
      if (_model.selectedRoleFilter != 'All') {
        if ((user.role ?? 'user').toLowerCase() !=
            _model.selectedRoleFilter.toLowerCase()) {
          return false;
        }
      }

      // Status filter
      if (_model.selectedStatusFilter == 'Active') {
        if (user.isBlocked == true) return false;
      } else if (_model.selectedStatusFilter == 'Blocked') {
        if (user.isBlocked != true) return false;
      }

      // Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final fullName =
            '${user.firstName ?? ''} ${user.lastName ?? ''}'.toLowerCase();
        final email = (user.email ?? '').toLowerCase();
        final club = (user.homeClub ?? '').toLowerCase();
        if (!fullName.contains(q) && !email.contains(q) && !club.contains(q)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    if (_isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Loading User Management...',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isAdmin) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 64.0,
                  color: FlutterFlowTheme.of(context).error,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Access Restricted',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'This page is only accessible to system administrators.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                SizedBox(height: 24.0),
                FFButtonWidget(
                  onPressed: () async {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(HomeWidget.routeName);
                    }
                  },
                  text: 'Back to Safety',
                  options: FFButtonOptions(
                    width: 180.0,
                    height: 44.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.plusJakartaSans(),
                          color: Colors.white,
                        ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final totalUsers = _allUsers.length;
    // Active today count is users present in active set, capped at total users
    final activeToday = max(
      1,
      _allUsers.where((u) => u.id != null && _activeUserIdsToday.contains(u.id)).length,
    );
    final activeRate = totalUsers > 0
        ? (activeToday / totalUsers).clamp(0.0, 1.0)
        : 0.0;
    final activePercentage = (activeRate * 100).toStringAsFixed(1);

    final filteredList = _filteredUsers;

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
              size: 26.0,
            ),
            onPressed: () async {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AdminHomeWidget.routeName);
              }
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.admin_panel_settings_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 26.0,
              ),
              SizedBox(width: 8.0),
              Text(
                'User Management',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20.0,
                    ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Refresh Users',
              icon: Icon(
                Icons.refresh_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              onPressed: () => _checkAdminAndFetchData(),
            ),
          ],
          centerTitle: true,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                  onRefresh: () => _checkAdminAndFetchData(),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. STATS OVERVIEW CARDS
                        Row(
                          children: [
                            // Total Users Card
                            Expanded(
                              child: _buildMetricCard(
                                title: 'Total Users',
                                value: totalUsers.toString(),
                                subtitle: 'Registered Accounts',
                                icon: Icons.groups_rounded,
                                iconColor: FlutterFlowTheme.of(context).primary,
                                badgeText: 'All Roles',
                                badgeColor: FlutterFlowTheme.of(context).primary.withOpacity(0.12),
                                badgeTextColor: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                            SizedBox(width: 12.0),
                            // Active Today Card
                            Expanded(
                              child: _buildMetricCard(
                                title: 'Active Today',
                                value: activeToday.toString(),
                                subtitle: '$activePercentage% Engagement',
                                icon: Icons.bolt_rounded,
                                iconColor: Color(0xFFF59E0B),
                                badgeText: 'Past 24h',
                                badgeColor: Color(0xFFF59E0B).withOpacity(0.15),
                                badgeTextColor: Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.0),

                        // 2. COMPARISON CHART (Total Users vs. Active Today)
                        _buildComparisonChart(
                          totalUsers: totalUsers,
                          activeToday: activeToday,
                          activeRate: activeRate,
                          activePercentage: activePercentage,
                        ),

                        SizedBox(height: 20.0),

                        // 3. SEARCH & FILTERS
                        _buildSearchAndFilters(),

                        SizedBox(height: 16.0),

                        // 4. DATA TABLE SECTION
                        _buildDataTableCard(filteredList),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Navbar for Admin
              wrapWithModel(
                model: _model.navbarModel,
                updateCallback: () => safeSetState(() {}),
                child: NavbarWidget(
                  tabSelected: AdminTabs.userManagement,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- STAT CARD WIDGET ---
  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24.0,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.0),
          Text(
            value,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                  fontSize: 28.0,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
          ),
          SizedBox(height: 4.0),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPARISON CHART WIDGET ---
  Widget _buildComparisonChart({
    required int totalUsers,
    required int activeToday,
    required double activeRate,
    required String activePercentage,
  }) {
    final primaryColor = FlutterFlowTheme.of(context).primary;
    final accentColor = Color(0xFFF59E0B); // Amber / orange for active today

    return Container(
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Activity Comparison',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                          ),
                          fontSize: 16.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    'Total Registered vs. Active in Past 24h',
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insights_rounded,
                      size: 15.0,
                      color: primaryColor,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'Live Metrics',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.0),

          // Side-by-side comparative visualization & Circular Gauge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Ratio Indicator
              CircularPercentIndicator(
                radius: 46.0,
                lineWidth: 9.0,
                percent: activeRate,
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: accentColor,
                backgroundColor: primaryColor.withOpacity(0.15),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$activePercentage%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    Text(
                      'Active',
                      style: GoogleFonts.inter(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 20.0),

              // Bar Comparison Visualization
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bar 1: Total Users
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  'Total Users',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$totalUsers users (100%)',
                              style: GoogleFonts.inter(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Container(
                            height: 10.0,
                            width: double.infinity,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 14.0),

                    // Bar 2: Active Today
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  'Active Today',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$activeToday users ($activePercentage%)',
                              style: GoogleFonts.inter(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.0),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final fillWidth = constraints.maxWidth * activeRate;
                            return Stack(
                              children: [
                                Container(
                                  height: 10.0,
                                  width: constraints.maxWidth,
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                Container(
                                  height: 10.0,
                                  width: max(12.0, fillWidth),
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SEARCH AND FILTERS ---
  Widget _buildSearchAndFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input
        TextFormField(
          controller: _model.searchController,
          focusNode: _model.searchFocusNode,
          onChanged: (val) {
            safeSetState(() {
              _searchQuery = val.trim();
            });
          },
          decoration: InputDecoration(
            hintText: 'Search users by name, email, club...',
            hintStyle: GoogleFonts.inter(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14.0,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 18.0,
                    ),
                    onPressed: () {
                      _model.searchController?.clear();
                      safeSetState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 1.5,
              ),
            ),
          ),
          style: GoogleFonts.inter(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 14.0,
          ),
        ),

        SizedBox(height: 12.0),

        // Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Role: All', _model.selectedRoleFilter == 'All', () {
                safeSetState(() => _model.selectedRoleFilter = 'All');
              }),
              SizedBox(width: 8.0),
              _buildFilterChip('Admins', _model.selectedRoleFilter == 'admin', () {
                safeSetState(() => _model.selectedRoleFilter = 'admin');
              }),
              SizedBox(width: 8.0),
              _buildFilterChip('Sub-Admins', _model.selectedRoleFilter == 'subAdmin', () {
                safeSetState(() => _model.selectedRoleFilter = 'subAdmin');
              }),
              SizedBox(width: 8.0),
              _buildFilterChip('Regular Users', _model.selectedRoleFilter == 'user', () {
                safeSetState(() => _model.selectedRoleFilter = 'user');
              }),
              SizedBox(width: 14.0),
              Container(
                width: 1.0,
                height: 20.0,
                color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.15),
              ),
              SizedBox(width: 14.0),
              _buildFilterChip('All Status', _model.selectedStatusFilter == 'All', () {
                safeSetState(() => _model.selectedStatusFilter = 'All');
              }),
              SizedBox(width: 8.0),
              _buildFilterChip('Active Only', _model.selectedStatusFilter == 'Active', () {
                safeSetState(() => _model.selectedStatusFilter = 'Active');
              }),
              SizedBox(width: 8.0),
              _buildFilterChip('Blocked Only', _model.selectedStatusFilter == 'Blocked', () {
                safeSetState(() => _model.selectedStatusFilter = 'Blocked');
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    final primaryColor = FlutterFlowTheme.of(context).primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : FlutterFlowTheme.of(context).primaryText.withOpacity(0.12),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
          ),
        ),
      ),
    );
  }

  // --- DATA TABLE CARD ---
  Widget _buildDataTableCard(List<UsersRow> users) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Directory (${users.length})',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                        ),
                        fontSize: 16.0,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                ),
                Text(
                  'Tap row for details',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1.0, color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08)),

          if (users.isEmpty)
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.person_search_rounded,
                      size: 48.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'No users found matching your criteria',
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                columnSpacing: 22.0,
                horizontalMargin: 16.0,
                headingTextStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                dataTextStyle: GoogleFonts.inter(
                  fontSize: 13.0,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                columns: const [
                  DataColumn(label: Text('USER')),
                  DataColumn(label: Text('EMAIL')),
                  DataColumn(label: Text('ROLE')),
                  DataColumn(label: Text('HOME CLUB / HCP')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('JOINED')),
                  DataColumn(label: Text('ACTION')),
                ],
                rows: users.map((user) {
                  final fullName =
                      '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
                  final displayName = fullName.isEmpty ? 'Unnamed User' : fullName;
                  final role = user.role ?? 'user';
                  final isBlocked = user.isBlocked == true;
                  final joined = user.createdAt != null
                      ? DateFormat('MMM d, yyyy').format(user.createdAt!)
                      : 'N/A';
                  final handicap = user.golfHandicap != null
                      ? user.golfHandicap!.toStringAsFixed(1)
                      : '-';
                  final club = user.homeClub ?? 'None';

                  return DataRow(
                    onSelectChanged: (_) => _openUserDetail(user),
                    cells: [
                      // User Column (Avatar + Name)
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 16.0,
                              backgroundColor: FlutterFlowTheme.of(context)
                                  .primary
                                  .withOpacity(0.15),
                              backgroundImage: user.photoUrl != null &&
                                      user.photoUrl!.isNotEmpty
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null ||
                                      user.photoUrl!.isEmpty
                                  ? Text(
                                      displayName.isNotEmpty
                                          ? displayName[0].toUpperCase()
                                          : '?',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: FlutterFlowTheme.of(context).primary,
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 10.0),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 130.0),
                              child: Text(
                                displayName,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Email Column
                      DataCell(
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 160.0),
                          child: Text(
                            user.email ?? 'No email',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ),
                      ),

                      // Role Column
                      DataCell(_buildRoleBadge(role)),

                      // Home Club / Handicap
                      DataCell(
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 140.0),
                          child: Text(
                            '$club (Hcp: $handicap)',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 12.0),
                          ),
                        ),
                      ),

                      // Status Column
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            color: isBlocked
                                ? FlutterFlowTheme.of(context).error.withOpacity(0.12)
                                : Color(0xFF10B981).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6.0,
                                height: 6.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isBlocked
                                      ? FlutterFlowTheme.of(context).error
                                      : Color(0xFF10B981),
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                isBlocked ? 'Blocked' : 'Active',
                                style: GoogleFonts.inter(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w600,
                                  color: isBlocked
                                      ? FlutterFlowTheme.of(context).error
                                      : Color(0xFF047857),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Joined Date Column
                      DataCell(
                        Text(
                          joined,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ),

                      // Action Column
                      DataCell(
                        InkWell(
                          onTap: () => _openUserDetail(user),
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 15.0,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (role.toLowerCase()) {
      case 'admin':
        bg = Color(0xFF8B5CF6).withOpacity(0.15);
        fg = Color(0xFF7C3AED);
        label = 'Admin';
        icon = Icons.verified_user_rounded;
        break;
      case 'subadmin':
        bg = Color(0xFF3B82F6).withOpacity(0.15);
        fg = Color(0xFF2563EB);
        label = 'SubAdmin';
        icon = Icons.security_rounded;
        break;
      default:
        bg = FlutterFlowTheme.of(context).primaryText.withOpacity(0.08);
        fg = FlutterFlowTheme.of(context).primaryText;
        label = 'User';
        icon = Icons.person_rounded;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.0, color: fg),
          SizedBox(width: 4.0),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  void _openUserDetail(UsersRow user) async {
    await context.pushNamed(
      UserDetailViewWidget.routeName,
      queryParameters: {
        'user': serializeParam(
          user,
          ParamType.SupabaseRow,
        ),
        'userId': serializeParam(
          user.id,
          ParamType.String,
        ),
      }.withoutNulls,
    );
    // Refresh user list upon returning
    _checkAdminAndFetchData();
  }
}

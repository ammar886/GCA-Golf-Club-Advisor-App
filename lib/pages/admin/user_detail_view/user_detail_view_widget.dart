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
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'user_detail_view_model.dart';
export 'user_detail_view_model.dart';

class UserDetailViewWidget extends StatefulWidget {
  const UserDetailViewWidget({
    super.key,
    this.user,
    this.userId,
  });

  final UsersRow? user;
  final String? userId;

  static String routeName = 'userDetailView';
  static String routePath = '/userDetailView';

  @override
  State<UserDetailViewWidget> createState() => _UserDetailViewWidgetState();
}

class _UserDetailViewWidgetState extends State<UserDetailViewWidget> {
  late UserDetailViewModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  bool _isAdmin = false;
  UsersRow? _user;
  List<ClubReviewsRow> _userReviews = [];
  Map<int, String> _clubNames = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserDetailViewModel());
    _user = widget.user;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAdminAndFetchDetails();
    });
  }

  Future<void> _checkAdminAndFetchDetails() async {
    safeSetState(() => _isLoading = true);

    // 1. Role verification: Strict check for admin role
    bool hasAdminRole = FFAppState().currentRole == 'admin';

    if (!hasAdminRole && currentUserUid.isNotEmpty) {
      try {
        final currentRows = await UsersTable().queryRows(
          queryFn: (q) => q.eqOrNull('id', currentUserUid),
        );
        if (currentRows.firstOrNull?.role == 'admin') {
          FFAppState().currentRole = 'admin';
          hasAdminRole = true;
        }
      } catch (e) {
        debugPrint('Error verifying admin: $e');
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
            content: Text('Access Denied: Administrator role required.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
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

    // 2. Fetch or refresh user details
    final targetId = _user?.id ?? widget.userId;
    if (targetId != null && targetId.isNotEmpty) {
      try {
        final rows = await UsersTable().queryRows(
          queryFn: (q) => q.eqOrNull('id', targetId),
        );
        if (rows.isNotEmpty) {
          _user = rows.first;
        }
      } catch (e) {
        debugPrint('Error fetching user: $e');
      }

      // 3. Fetch reviews by this user
      try {
        final reviews = await ClubReviewsTable().queryRows(
          queryFn: (q) =>
              q.eqOrNull('user_id', targetId).order('created_at', ascending: false),
        );
        _userReviews = reviews;

        // Fetch club names for these reviews
        final clubIds = reviews.map((r) => r.clubId).toSet().toList();
        if (clubIds.isNotEmpty) {
          final clubs = await GolfClubsTable().queryRows(
            queryFn: (q) => q.inFilterOrNull('id', clubIds),
          );
          for (final c in clubs) {
            _clubNames[c.id] = c.name ?? 'Golf Club #${c.id}';
          }
        }
      } catch (e) {
        debugPrint('Error fetching user reviews: $e');
      }
    }

    safeSetState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _toggleBlockStatus() async {
    if (_user == null || _user!.id == null) return;
    final currentlyBlocked = _user!.isBlocked == true;
    final newStatus = !currentlyBlocked;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (alertDialogContext) => AlertDialog(
        title: Text(newStatus ? 'Block User' : 'Unblock User'),
        content: Text(
          newStatus
              ? 'Are you sure you want to block this user? They will not be able to access the application.'
              : 'Are you sure you want to unblock this user? Their access will be restored.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: newStatus
                  ? FlutterFlowTheme.of(context).error
                  : FlutterFlowTheme.of(context).primary,
            ),
            child: Text(newStatus ? 'Block' : 'Unblock'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await UsersTable().update(
        data: {'is_blocked': newStatus},
        matchingRows: (q) => q.eqOrNull('id', _user!.id!),
      );

      safeSetState(() {
        _user!.isBlocked = newStatus;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus
                  ? 'User has been blocked successfully.'
                  : 'User has been unblocked successfully.',
            ),
            backgroundColor: newStatus
                ? FlutterFlowTheme.of(context).error
                : FlutterFlowTheme.of(context).primary,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error updating blocked status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  Future<void> _changeRoleDialog() async {
    if (_user == null || _user!.id == null) return;
    final currentRole = _user!.role ?? 'user';
    String? selectedRole = currentRole;

    final updated = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Change User Role'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select the role for ${_user?.firstName ?? 'this user'}:',
                    style: GoogleFonts.inter(fontSize: 14.0),
                  ),
                  SizedBox(height: 16.0),
                  RadioListTile<String>(
                    title: Text('Regular User'),
                    subtitle: Text('Standard golfer access'),
                    value: 'user',
                    groupValue: selectedRole,
                    onChanged: (val) => setDialogState(() => selectedRole = val),
                  ),
                  RadioListTile<String>(
                    title: Text('SubAdmin'),
                    subtitle: Text('Manage clubs & reviews'),
                    value: 'subAdmin',
                    groupValue: selectedRole,
                    onChanged: (val) => setDialogState(() => selectedRole = val),
                  ),
                  RadioListTile<String>(
                    title: Text('Administrator'),
                    subtitle: Text('Full access to all settings and users'),
                    value: 'admin',
                    groupValue: selectedRole,
                    onChanged: (val) => setDialogState(() => selectedRole = val),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, null),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, selectedRole),
                  child: Text('Save Role'),
                ),
              ],
            );
          },
        );
      },
    );

    if (updated != null && updated != currentRole) {
      try {
        await UsersTable().update(
          data: {'role': updated},
          matchingRows: (q) => q.eqOrNull('id', _user!.id!),
        );

        safeSetState(() {
          _user!.role = updated;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Role updated to $updated.'),
              backgroundColor: FlutterFlowTheme.of(context).primary,
            ),
          );
        }
      } catch (e) {
        debugPrint('Error updating role: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update role: $e'),
              backgroundColor: FlutterFlowTheme.of(context).error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    if (_isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              FlutterFlowTheme.of(context).primary,
            ),
          ),
        ),
      );
    }

    if (!_isAdmin) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Text('Access Restricted'),
        ),
      );
    }

    final user = _user;
    if (user == null) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          title: Text('User Details'),
        ),
        body: Center(
          child: Text('User not found'),
        ),
      );
    }

    final fullName = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
    final displayName = fullName.isEmpty ? 'Unnamed User' : fullName;
    final role = user.role ?? 'user';
    final isBlocked = user.isBlocked == true;
    final joined = user.createdAt != null
        ? DateFormat('MMMM d, yyyy h:mm a').format(user.createdAt!)
        : 'N/A';

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
            onPressed: () => context.pop(),
          ),
          title: Text(
            'User Details',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 20.0,
                ),
          ),
          actions: [
            IconButton(
              tooltip: isBlocked ? 'Unblock User' : 'Block User',
              icon: Icon(
                isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
                color: isBlocked
                    ? Color(0xFF10B981)
                    : FlutterFlowTheme.of(context).error,
              ),
              onPressed: _toggleBlockStatus,
            ),
          ],
          centerTitle: true,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. HERO HEADER PROFILE CARD
                      _buildHeroProfileCard(
                        user: user,
                        displayName: displayName,
                        role: role,
                        isBlocked: isBlocked,
                      ),

                      SizedBox(height: 16.0),

                      // 2. QUICK METRICS ROW
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              label: 'Reviews',
                              value: _userReviews.length.toString(),
                              icon: Icons.rate_review_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: _buildMetricTile(
                              label: 'Handicap',
                              value: user.golfHandicap != null
                                  ? user.golfHandicap!.toStringAsFixed(1)
                                  : 'N/A',
                              icon: Icons.sports_golf_rounded,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: _buildMetricTile(
                              label: 'Status',
                              value: isBlocked ? 'Blocked' : 'Active',
                              icon: isBlocked
                                  ? Icons.lock_rounded
                                  : Icons.check_circle_rounded,
                              color: isBlocked
                                  ? FlutterFlowTheme.of(context).error
                                  : Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.0),

                      // 3. ACCOUNT & PERSONAL INFO CARD
                      _buildSectionCard(
                        title: 'Account Information',
                        icon: Icons.badge_rounded,
                        children: [
                          _buildDetailRow(
                            label: 'User ID',
                            valueWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 160.0),
                                  child: Text(
                                    user.id ?? 'N/A',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontFamily: 'monospace',
                                      fontSize: 12.0,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.0),
                                InkWell(
                                  onTap: () {
                                    if (user.id != null) {
                                      Clipboard.setData(ClipboardData(text: user.id!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('User ID copied to clipboard'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.copy_rounded,
                                    size: 16.0,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildDetailRow(
                            label: 'Email',
                            value: user.email ?? 'Not provided',
                          ),
                          _buildDetailRow(
                            label: 'First Name',
                            value: user.firstName ?? 'Not provided',
                          ),
                          _buildDetailRow(
                            label: 'Last Name',
                            value: user.lastName ?? 'Not provided',
                          ),
                          _buildDetailRow(
                            label: 'Role',
                            valueWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildRoleBadge(role),
                                SizedBox(width: 8.0),
                                InkWell(
                                  onTap: _changeRoleDialog,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 3.0),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Text(
                                      'Change',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                        color: FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildDetailRow(
                            label: 'Account Created',
                            value: joined,
                          ),
                          _buildDetailRow(
                            label: 'Access Status',
                            valueWidget: Text(
                              isBlocked ? 'Blocked (Access Denied)' : 'Active (Normal)',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: isBlocked
                                    ? FlutterFlowTheme.of(context).error
                                    : Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.0),

                      // 4. GOLF PROFILE CARD
                      _buildSectionCard(
                        title: 'Golf Profile',
                        icon: Icons.golf_course_rounded,
                        children: [
                          _buildDetailRow(
                            label: 'Home Club',
                            value: user.homeClub ?? 'Not set',
                          ),
                          _buildDetailRow(
                            label: 'Handicap',
                            value: user.golfHandicap != null
                                ? user.golfHandicap!.toStringAsFixed(1)
                                : 'Not set',
                          ),
                          _buildDetailRow(
                            label: 'Preferred Brand',
                            value: user.clubBrand ?? 'Not set',
                          ),
                        ],
                      ),

                      SizedBox(height: 16.0),

                      // 5. REVIEWS ACTIVITY SECTION
                      _buildReviewsSection(),

                      SizedBox(height: 20.0),

                      // 6. ADMIN ACTIONS
                      _buildAdminActionsCard(isBlocked),
                    ],
                  ),
                ),
              ),

              // Bottom Navbar
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

  // --- HERO PROFILE CARD ---
  Widget _buildHeroProfileCard({
    required UsersRow user,
    required String displayName,
    required String role,
    required bool isBlocked,
  }) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36.0,
            backgroundColor:
                FlutterFlowTheme.of(context).primary.withOpacity(0.15),
            backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                ? NetworkImage(user.photoUrl!)
                : null,
            child: user.photoUrl == null || user.photoUrl!.isEmpty
                ? Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                        ),
                        fontSize: 20.0,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                ),
                SizedBox(height: 4.0),
                Text(
                  user.email ?? 'No email address',
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    _buildRoleBadge(role),
                    SizedBox(width: 8.0),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                      decoration: BoxDecoration(
                        color: isBlocked
                            ? FlutterFlowTheme.of(context).error.withOpacity(0.12)
                            : Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        isBlocked ? 'Blocked' : 'Active Account',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: isBlocked
                              ? FlutterFlowTheme.of(context).error
                              : Color(0xFF047857),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              Icon(icon, size: 16.0, color: color),
            ],
          ),
          SizedBox(height: 6.0),
          Text(
            value,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                  fontSize: 18.0,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.0, color: FlutterFlowTheme.of(context).primary),
              SizedBox(width: 8.0),
              Text(
                title,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                      ),
                      fontSize: 16.0,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
              ),
            ],
          ),
          SizedBox(height: 14.0),
          Divider(
            height: 1.0,
            color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
          ),
          SizedBox(height: 10.0),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    String? value,
    Widget? valueWidget,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          valueWidget ??
              Text(
                value ?? '-',
                style: GoogleFonts.inter(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Container(
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.reviews_rounded,
                    size: 20.0,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Club Reviews (${_userReviews.length})',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                          ),
                          fontSize: 16.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.0),
          Divider(
            height: 1.0,
            color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
          ),
          SizedBox(height: 12.0),

          if (_userReviews.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  'No reviews submitted by this user yet.',
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _userReviews.length,
              separatorBuilder: (_, __) => Divider(
                height: 16.0,
                color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.06),
              ),
              itemBuilder: (context, idx) {
                final rev = _userReviews[idx];
                final clubName = _clubNames[rev.clubId] ?? 'Golf Club #${rev.clubId}';
                final rating = rev.overallRating ?? 0;
                final dateStr = rev.createdAt != null
                    ? DateFormat('MMM d, yyyy').format(rev.createdAt!)
                    : '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            clubName,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (starIdx) => Icon(
                              starIdx < rating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 16.0,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (rev.comment != null && rev.comment!.isNotEmpty) ...[
                      SizedBox(height: 4.0),
                      Text(
                        rev.comment!,
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ],
                    SizedBox(height: 4.0),
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAdminActionsCard(bool isBlocked) {
    return Container(
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_rounded,
                  size: 20.0, color: FlutterFlowTheme.of(context).primary),
              SizedBox(width: 8.0),
              Text(
                'Admin Actions',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                      ),
                      fontSize: 16.0,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: FFButtonWidget(
                  onPressed: _changeRoleDialog,
                  text: 'Change Role',
                  icon: Icon(Icons.manage_accounts_rounded, size: 16.0),
                  options: FFButtonOptions(
                    height: 42.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.plusJakartaSans(),
                          color: Colors.white,
                          fontSize: 13.0,
                        ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: FFButtonWidget(
                  onPressed: _toggleBlockStatus,
                  text: isBlocked ? 'Unblock User' : 'Block User',
                  icon: Icon(
                    isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
                    size: 16.0,
                  ),
                  options: FFButtonOptions(
                    height: 42.0,
                    color: isBlocked
                        ? Color(0xFF10B981)
                        : FlutterFlowTheme.of(context).error,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.plusJakartaSans(),
                          color: Colors.white,
                          fontSize: 13.0,
                        ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
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
}

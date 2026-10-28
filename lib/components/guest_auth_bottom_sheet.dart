import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';

class GuestAuthBottomSheet extends StatelessWidget {
  const GuestAuthBottomSheet({
    super.key,
    this.title,
    this.message,
    this.icon,
  });

  final String? title;
  final String? message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        24.0,
        12.0,
        24.0,
        MediaQuery.of(context).viewPadding.bottom + 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 48.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 20.0),

          // Icon container
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.rate_review_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 32.0,
            ),
          ),
          const SizedBox(height: 16.0),

          // Title
          Text(
            title ?? 'Sign in to Add Reviews',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 20.0,
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 10.0),

          // Message
          Text(
            message ??
                'You are currently browsing as a guest. To share your feedback, rate golf clubs, and help fellow golfers, please sign in or create an account.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  lineHeight: 1.5,
                ),
          ),
          const SizedBox(height: 24.0),

          // Sign In button
          FFButtonWidget(
            onPressed: () async {
              Navigator.pop(context);
              context.pushNamed(LoginWidget.routeName);
            },
            text: 'Sign In',
            options: FFButtonOptions(
              width: double.infinity,
              height: 46.0,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                    ),
                    color: Colors.white,
                    fontSize: 15.0,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 12.0),

          // Create Account button
          FFButtonWidget(
            onPressed: () async {
              Navigator.pop(context);
              context.pushNamed(SignupWidget.routeName);
            },
            text: 'Create an Account',
            options: FFButtonOptions(
              width: double.infinity,
              height: 46.0,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                    ),
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 15.0,
                    letterSpacing: 0.0,
                  ),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 1.5,
              ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 10.0),

          // Continue Browsing button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Continue Browsing as Guest',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                    ),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 13.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<T?> showGuestAuthBottomSheet<T>(
  BuildContext context, {
  String? title,
  String? message,
  IconData? icon,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (context) => GuestAuthBottomSheet(
      title: title,
      message: message,
      icon: icon,
    ),
  );
}

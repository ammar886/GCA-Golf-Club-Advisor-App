import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'upload_slot_model.dart';
export 'upload_slot_model.dart';

class UploadSlotWidget extends StatefulWidget {
  const UploadSlotWidget({super.key});

  @override
  State<UploadSlotWidget> createState() => _UploadSlotWidgetState();
}

class _UploadSlotWidgetState extends State<UploadSlotWidget> {
  late UploadSlotModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadSlotModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Icon(
        Icons.add_a_photo_rounded,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 24.0,
      ),
    );
  }
}

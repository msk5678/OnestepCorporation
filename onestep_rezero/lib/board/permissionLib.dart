import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class OneStepPermission {
  Future<Map<Permission, PermissionStatus>> _permissionRequest() async {
    Map<Permission, PermissionStatus> _statuses;

    if (Platform.isIOS) {
      _statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();
      return _statuses;
    } else {
      _statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();

      return _statuses;
    }
  }

  checkCamStorePermission(Function function) async {
    try {
      Map<Permission, PermissionStatus> _statuses = await _permissionRequest();
      if (!(_statuses.containsValue("PermissionStatus.granted") ||
          _statuses.containsValue("PermissionStatus.restricted") ||
          _statuses.containsValue("PermissionStatus.permanentlyDenied")))
        function();
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:permission_handler/permission_handler.dart';

Future<bool> requestMicPermission() async {
  var status = await Permission.microphone.status;
  if (!status.isGranted) {
    status = await Permission.microphone.request();
  }
  status.isGranted ? null : openAppSettings();
  return status.isGranted ? true : false;
}

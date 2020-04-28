import 'package:permission_handler/permission_handler.dart';

allowedCameraPermission() async {
  final cameraRequest = await Permission.camera.request();
  if (cameraRequest.isGranted)
    return true;
  else
    return false;
}

allowedStoragePermission() async {
  final storageRequest = await Permission.storage.request();
  if (storageRequest.isGranted)
    return true;
  else
    return false;
}

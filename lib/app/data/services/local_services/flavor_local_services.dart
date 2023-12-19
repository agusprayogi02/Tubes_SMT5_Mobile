import 'package:get_storage/get_storage.dart';

abstract class FlavorLocalServices {
  String get image;
  String get name;
  String get baseUrl;

  Future<void> setImage(String value);
  Future<void> setName(String value);
  Future<void> setBaseUrl(String value);
}

class FlavorLocalServicesImpl extends FlavorLocalServices {
  final _box = GetStorage();
  final _keyName = "flavor-name-ddddd";
  final _keyImage = "flavor-Image-ddddd";
  final _keyBaseUrl = "flavor-baseeurrlll-ddddd";

  @override
  String get image => _box.read(_keyImage) ?? "assets/img/logo.png";

  @override
  String get name => _box.read(_keyName) ?? "Tentu Bisa";

  @override
  Future<void> setImage(String value) {
    return _box.write(_keyImage, value);
  }

  @override
  Future<void> setName(String value) {
    return _box.write(_keyName, value);
  }

  @override
  String get baseUrl => _box.read(_keyBaseUrl) ?? "http://192.168.72.188:8080/";

  @override
  Future<void> setBaseUrl(String value) {
    return _box.write(_keyBaseUrl, value);
  }
}

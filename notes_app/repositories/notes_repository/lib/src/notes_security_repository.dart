import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tuple/tuple.dart';

class NoteSecurityRepository {
  final _storage = new FlutterSecureStorage();
  static const int saltLength = 64;

  Future<String> getSecurityKeyFromPassword(String password) async {
    return _isSecurityKeyExist().then((isExist) => isExist == true
        ? _validatePassword(password)
            .then((isValid) => isValid == true ? _loadSecurityKey() : throw Exception("Wrong password"))
        : _createSecurityKey(password));
  }

  Future<String> getSecurityKey() async {
    return _loadSecurityKey();
  }

  Future<void> wipeSecurityKey() async {
    return _deleteSecurityKey().then((value) => _deleteSalt());
  }

  Future<String> _createSecurityKey(String password) async {
      var result = _generateSecurityKeySaltPair(password);
      await _saveSecurityKey(result.item1).whenComplete(() => _saveSalt(result.item2));
      return result.item1;
  }

  Future<bool> _validatePassword(String password) async {
    String salt = await _loadSalt();
    return ((await _loadSecurityKey()) == (await _generateSecurityKey(password, salt)));
  }

  Future<bool> _isSecurityKeyExist() async {
    return (await _storage.read(key: "securityKey")) != null;
  }

  /*
  * FlutterSecureStorage allows store data securely(encrypted)
  */
  Future<void> _saveSecurityKey(String securityKey) async {
    return _storage.write(key: "securityKey", value: securityKey);
  }

  Future<String> _loadSecurityKey() async {
    return _storage.read(key: "securityKey");
  }

  Future<void> _deleteSecurityKey() async {
    return _storage.delete(key: "securityKey");
  }

  void _saveSalt(String salt) async {
    return _storage.write(key: "salt", value: salt);
  }

  Future<String> _loadSalt() async {
    return _storage.read(key: "salt");
  }

  Future<void> _deleteSalt() async {
    return _storage.delete(key: "salt");
  }

  Tuple2<String, String> _generateSecurityKeySaltPair(String password) {
    final salt = _Salt.generateAsBase64String(saltLength);
    final key = sha256.convert(utf8.encode(salt + password)).toString();
    //It had to be 32 byte because of the Hive library
    return Tuple2(key.substring(0, 32), salt);
  }

  String _generateSecurityKey(String password, String salt) {
    //It had to be 32 byte because of the Hive library
    return sha256.convert(utf8.encode(salt + password)).toString().substring(0, 32);
  }
}

/*
* I know that custom encryption is bad, but crypto package from flutter team does not have salt generator.
* So i use that one. It seems ok.
* */
class _Salt {
  static List<int> generate(int length) {
    var buffer = new Uint8List(length);
    var rng = new Random.secure();
    for (var i = 0; i < length; i++) {
      buffer[i] = rng.nextInt(256);
    }
    return buffer;
  }

  static String generateAsBase64String(int length) {
    var encoder = new Base64Encoder();
    return encoder.convert(generate(length));
  }
}

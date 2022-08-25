import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../../ui/strings.dart';

uploadStatusImages(Function(String) callback) async{
  callback(strings.get(227)); /// "Upload status images ...",

  double percentage = 0;
  var oneStep = 100/statusesDataInit.length;
  for (var item in statusesDataInit){
    await _uploadImages(item);
    percentage += oneStep;
    callback(strings.get(227) + " ${percentage.toStringAsFixed(0)}%"); /// "Upload status images ... %%",
  }
}

_uploadImages(StatusData item) async {
  ByteData byteData = await rootBundle.load(item.assetName);
  Uint8List _imageData = byteData.buffer.asUint8List();
  var f = Uuid().v4();
  var name = "statuses/$f.jpg";
  // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
  // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
  item.serverPath = await dbSaveFile(name, _imageData);
  item.localFile = name;
}

Future<String?> uploadStatusImage(StatusData item, Uint8List _imageData) async {
  try{
    var f = Uuid().v4();
    var name = "provider/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    item.serverPath = await dbSaveFile(name, _imageData);
    item.localFile = name;
  } catch (e) {
    return e.toString();
  }
  return null;
}


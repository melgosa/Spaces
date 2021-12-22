import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/painting.dart';

class ImageProviderApp with ChangeNotifier {
  File _selectedFile;
  bool _inProcess = false;
  String _path = '';

  final prefs = PreferenciasUsuario();

  File get imageFile => this._selectedFile;

  bool get inProcess => this._inProcess;

  String get path => this._path;

  ImageProviderApp(){
    print('Constructor llamamdo de image');
    this._path = prefs.profilePicPath;
    if(this._path.length > 0)
      this._selectedFile = File(this._path);
    notifyListeners();
  }

  getImage(ImageSource source) async {
    this._inProcess = true;

    final ImagePicker _picker = ImagePicker();
    XFile image = await _picker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "Redimensionar foto",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          ),
        iosUiSettings: IOSUiSettings(
          cancelButtonTitle: 'Cancelar',
          title: 'Redimensionar foto',
          doneButtonTitle: 'Ok'
      )
      );

      this._selectedFile = cropped;
      notifyListeners();
      await _savePhotoOnDevice();
      this._inProcess = false;
    } else {
      this._inProcess = false;
    }
    notifyListeners();
  }

  _savePhotoOnDevice() async{
    final Directory directory = await getApplicationDocumentsDirectory();
    String appDocPath = directory.path;
    print('Guardado en: $appDocPath/profilepic.jpg');

    File imageExist = File(appDocPath + '/profilepic.jpg');
    if(await imageExist.exists()) {
      await imageExist.delete();
      imageCache.clearLiveImages();
      imageCache.clear();
      PaintingBinding.instance.imageCache.clear();
    }

    this._selectedFile = await this._selectedFile.copy('$appDocPath/profilepic.jpg');
    prefs.profilePicPath = '$appDocPath/profilepic.jpg';
    this._path = '$appDocPath/profilepic.jpg';
    notifyListeners();
  }
}

//data/user/0/com.gh.spacesgh/app_flutter

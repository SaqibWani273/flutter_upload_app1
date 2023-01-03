//import 'dart:html';
import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

class UploadData extends ChangeNotifier {
  UploadData(BuildContext context);
  var isVideoSelected = false;
  var isImageSelected = false;
  var isUploading = false;
  var isPaused = false;
  // late PlatformFile selectedVideo;
  late PlatformFile selectedImage;
  late String selectedImagePath;
  late Reference videoRef;
  late Reference imageRef;

  late UploadTask uploadTask;
  int progress = 0;
  var isUploadSuccessfull = false;
  var isUploadCancelled = false;
  // function to select video using filePicker

// function to select image using filePicker()
  Future selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    selectedImage = result!.files.first;
    selectedImagePath = result.files.first.path!;
    isImageSelected = true;
    notifyListeners();
  }

//function to cancel ongoing upload
  cancelUploading(BuildContext contxt) {
    print('cancel uploading called');
    //when video is cancelled ,delete the uploaded image
    imageRef.delete();
    uploadTask.cancel();

    isUploadCancelled = true;
    ScaffoldMessenger.of(contxt).showSnackBar(
      SnackBar(
        content: Text(
          'Uploading Cancelled !!!',
        ),
      ),
    );

    notifyListeners();
  }

  pauseUploading() {
    uploadTask.pause();
    isPaused = true;
    notifyListeners();
  }

  resumeUploading() {
    uploadTask.resume();
    isPaused = false;
    notifyListeners();
  }
}

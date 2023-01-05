//import 'dart:html';
import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UploadData extends ChangeNotifier {
  UploadData(BuildContext context);
  var isImageSelected = false;
  var isUploading = false;
  var isLoggedIn = FirebaseAuth.instance.currentUser != null ? true : false;
  // var isPaused = false;
  late PlatformFile selectedImage;
  late String selectedImagePath;
  late Reference imageRef;

  //late UploadTask uploadTask;
  int progress = 0;
  var isUploadSuccessfull = false;
  var isUploadCancelled = false;

  var selectedCategory = 'Category A';
  var Categories = [
    'Category A',
    'Category B',
    'Category C',
    'Category D',
    'Category E',
  ];
  var months = [
    'Jan',
    'Feb',
    'March',
    'April',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

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

  Future<void> upload(String url, String description) async {
    DateTime currentDate = DateTime.now();
    String myDate =
        '${currentDate.day}-${months[currentDate.month - 1]}-${currentDate.year}';
    String idFromDate = '$currentDate${currentDate.microsecond}';
    String uploaderId = FirebaseAuth.instance.currentUser!.uid;

    try {
      //upload image to firebase storage

      final firebaseStorageImagePath =
          'complete_videos_list/$uploaderId/thumbnails/$currentDate';
      final imageRef = FirebaseStorage.instance.ref(firebaseStorageImagePath);
      final imageFile = File(selectedImagePath);
      await imageRef.putFile(imageFile);

      // get image url
      final storageRef = FirebaseStorage.instance.ref();
      final imageUrl =
          await storageRef.child(firebaseStorageImagePath).getDownloadURL();

      //upload to realtime db
      DatabaseReference ref = FirebaseDatabase.instance
          .ref('completeVideosList/$selectedCategory/$uploaderId');
      final Map<String, dynamic> uploadFile = {
        'videoUrl': url,
        'description': description,
        'date': currentDate.toString(),
        'imageUrl': imageUrl,
        'dateToDisplay': myDate,
        // 'user':uploaderEmail,
        'id': currentDate.toString(),
        'category': selectedCategory,
      };
      DatabaseReference newRef = ref.push();
      await newRef.set(uploadFile);
    } catch (e) {
      print(e.toString());
    }
  }

  void changeCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
//login data

  void changeLoginStatus(bool loginStatus) {
    isLoggedIn = loginStatus;
    notifyListeners();
  }

  void forgotPassword() {
    print("forgot password() called");
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    try {
      print('sign in ()');
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (FirebaseAuth.instance.currentUser != null) {
        isLoggedIn = true;
        notifyListeners();
      }
      final user = await FirebaseAuth.instance.currentUser!;

      print("User =$user");
    } on FirebaseAuthException catch (e) {
      print('firebase error $e');
      //errorCallback(e);
    }
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    isLoggedIn = false;
    notifyListeners();
  }
}

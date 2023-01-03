import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'dart:io';

import 'models/data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: ((context) => UploadData(context)),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Container(
              margin: EdgeInsets.only(
                left: 60,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Upload Screen'),
                  IconButton(onPressed: () {}, icon: Icon(Icons.person))
                ],
              ),
            ),
          ),
          drawer: Drawer(),
          body: Consumer<UploadData>(
            builder: (context, upload, child) => UploadTab(upload),
          )),
    );
  }
}

class UploadTab extends StatelessWidget {
  final UploadData upload;
  UploadTab(this.upload, {Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController videoTitle = TextEditingController();
  final TextEditingController speaker = TextEditingController();
  final TextEditingController videoDescription = TextEditingController();
  final TextEditingController videoDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final selectedVideoName = upload.fileName;

    return Center(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (upload.isImageSelected)
                    Image.file(
                      File(upload.selectedImagePath),
                      width: 200,
                      height: 100,
                    ),
                  TextButton.icon(
                    onPressed: upload.selectImage,
                    icon: Icon(upload.isImageSelected
                        ? Icons.image_rounded
                        : Icons.attach_file_outlined),
                    label: upload.isImageSelected
                        ? Text('Thumbnail Image')
                        : Text("select a thumbnail image    *"),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: videoTitle,
                    decoration: InputDecoration(
                      hintText: 'Enter the video Title *',
                    ),
                    validator: ((value) {
                      if (value == Null || value!.isEmpty)
                        return 'Enter a Title';
                      else
                        return null;
                    }),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: speaker,
                    decoration:
                        InputDecoration(hintText: "Enter Speaker's Name    *"),
                    validator: ((value) {
                      if (value == Null || value!.isEmpty)
                        return "Enter Speaker's Name  ";
                      else
                        return null;
                    }),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: videoDate,
                    decoration: InputDecoration(hintText: 'Enter the Date'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: videoDescription,
                    decoration: InputDecoration(
                      hintText:
                          'Enter the Brief Description about the video     *',
                    ),
                    validator: ((value) {
                      if (value == Null || value!.isEmpty)
                        return 'Enter a Description';
                      else
                        return null;
                    }),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      upload.isUploading
                          ? Row(
                              children: [
                                ElevatedButton(
                                  child: Text('Cancel upload'),
                                  onPressed: () {
                                    upload.cancelUploading(context);
                                  },
                                ),
                                ElevatedButton(
                                  child: Text(
                                      'Uploading Video ${upload.progress} %'),
                                  onPressed: () {},
                                )
                              ],
                            )
                          : ElevatedButton(
                              child: Text('Upload'), onPressed: () {}),
                    ],
                  )
                ],
              ),
            )),
      ),
    ));
  }
}

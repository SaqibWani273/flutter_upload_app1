import 'package:backend_app/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: ((context) => UploadData(context)),
          ),
        ],
        child: Consumer<UploadData>(
          builder: ((context, data, _) => MyApp(data)),
        )),
  );
}

class MyApp extends StatelessWidget {
  final UploadData data;
  const MyApp(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    if (!data.isLoggedIn
        // !Provider.of<LoginData>(context, listen: false).isLoggedIn
        ) {
      return MaterialApp(
        home: LoginScreen(data),
      );
    } else {
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
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('Login Screen'),
              ),
              GestureDetector(
                onTap: Provider.of<UploadData>(listen: false, context).signOut,
                child: ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: Text("Logout"),
                ),
              ),
            ],
          ),
        ),
        body: UploadTab(data),
      ));
    }
  }
}

class UploadTab extends StatelessWidget {
  final UploadData upload;
  UploadTab(this.upload, {Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController videoUrl = TextEditingController();
  final TextEditingController videoDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final selectedVideoName = upload.fileName;

    return Center(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: Card(
        elevation: 13.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Select a Thubmnail Image'),
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
                          : Text("upload image   *"),
                    ),
                    Visibility(
                      visible: false,
                      child: TextFormField(),
                    ),
                    SizedBox(height: 10),
                    Text('Enter Youtube Video Url'),
                    TextFormField(
                      controller: videoUrl,
                      decoration: InputDecoration(
                        hintText: 'Please enter proper url *',
                      ),
                      validator: ((value) {
                        if (value == Null || value!.isEmpty)
                          return 'Enter a Proper Url !';
                        else
                          return null;
                      }),
                    ),
                    SizedBox(height: 10),
                    Text('Select video category'),
                    DropdownButton(
                      value: upload.selectedCategory,
                      icon: Icon(Icons.arrow_drop_down_outlined),
                      items: upload.Categories.map(
                        (String category) => DropdownMenuItem(
                          child: Text(category),
                          value: category,
                        ),
                      ).toList(),
                      onChanged: ((value) => upload.changeCategory(
                            value.toString(),
                          )),
                    ),
                    SizedBox(height: 10),
                    Text('Enter Video Description'),
                    TextFormField(
                      controller: videoDescription,
                      decoration: const InputDecoration(
                        hintText:
                            'e.g. Topic  | Speaker Name  | venue | Date  *',
                      ),
                      validator: ((value) {
                        if (value == Null || value!.isEmpty)
                          return 'Enter a Description';
                        else
                          return null;
                      }),
                    ),
                    SizedBox(height: 10),
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
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(38.0),
                              child: ElevatedButton(
                                  child: Text('Upload'),
                                  onPressed: () {
                                    if (!upload.isImageSelected) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor:
                                              Color.fromARGB(255, 65, 8, 4),
                                          content: Text(
                                            'Please Select an Image...',
                                            style: TextStyle(
                                                //  color: Colors.red,
                                                ),
                                          ),
                                        ),
                                      );
                                    }
                                    if (_formKey.currentState!.validate() &&
                                        upload.isImageSelected) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Uploading Video...',
                                          ),
                                        ),
                                      );
                                      upload.upload(
                                        videoUrl.text.trim(),
                                        videoDescription.text.trim(),
                                      );
                                    }
                                  }),
                            ),
                          ),
                  ],
                ),
              )),
        ),
      ),
    ));
  }
}

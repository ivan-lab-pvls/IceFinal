import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // Добавим библиотеку для работы с камерой

class UserScreen extends StatefulWidget {
  final VoidCallback onClosePressed;

  UserScreen({
    required this.onClosePressed,
  });

  @override
  _UserScreenState createState() => _UserScreenState();
}

late SharedPreferences prefs;
String? showBons;

class _UserScreenState extends State<UserScreen> {
  final StreamController<int> selectedController =
      StreamController<int>.broadcast();

  TextEditingController _usernameController = TextEditingController();
  var _userPhotoFile;
  @override
  void initState() {
    super.initState();
    _loadCachedUsername();
  }

  Future<String> _loadCachedUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  void _saveUsernameToCache(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<void> _takeUserPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final File photoFile = File(image.path);
      setState(() {
        _userPhotoFile = photoFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 140.0),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/fort_bg.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height * .47,
              width: MediaQuery.of(context).size.width * .8,
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 1.65,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: InkWell(
                  onTap: () {
                    widget.onClosePressed();
                  },
                  child: Image.asset(
                    'assets/images/cancel.png',
                    fit: BoxFit.contain,
                    height: 70,
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .1,
              left: MediaQuery.of(context).size.width * .1,
              child: InkWell(
                onTap: () {
                  _takeUserPhoto();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey,
                  ),
                  child: _userPhotoFile != null
                      ? Image.file(_userPhotoFile!)
                      : const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                left: MediaQuery.of(context).size.width * 0.17,
                child: FutureBuilder<String>(
                  future: _loadCachedUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final cachedUsername = snapshot.data;
                      print(cachedUsername);
                      return cachedUsername != null
                          ? Center(
                              child: Text(
                                '$cachedUsername',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Positioned(
                              top: MediaQuery.of(context).size.height * 0.4,
                              left: MediaQuery.of(context).size.width *
                                  0.2, // Изменил координату left
                              child: Container(
                                height: 100,
                                width: 100,
                                color: Colors.red,
                                child: TextField(
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Input your nickname: ',
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                    }
                  },
                )),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.26,
              child: InkWell(
                onTap: () {
                  final username = _usernameController.text;
                  _saveUsernameToCache(username);
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: const Center(
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

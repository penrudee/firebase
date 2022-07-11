import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_layout/locator.dart';
import 'package:learn_layout/repository/auth_repo.dart';
import 'package:learn_layout/repository/storage_repo.dart';
import 'package:learn_layout/states/avatar.dart';

import 'package:learn_layout/utility/my_constant.dart';
import 'package:learn_layout/view_controller/user_controller.dart';

import '../models/user_models.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool statusRedEye = true;
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _key2 = GlobalKey<FormState>();
  late UserModel _currentUser = locator.get<UserController>().currentUser;

  @override
  void initState() {
    emailController.text = _currentUser.email ?? "email@email.com";
    getImageUrlFromFirebaseStoreage();
  }

  @override
  Widget build(BuildContext context) {
    var imagEURL = _currentUser.avatarUrl;
    var userIDD = _currentUser.uid;
    print("current user get user profileurl??????????? $imagEURL");
    print("current user get id profile $userIDD");
    print("user email ==============${_currentUser.email}");
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Profile",
          style: TextStyle(fontFamily: "Kanit Regular"),
        ),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              buildUserAvatar(),
              // buildName(size),
              buildEmail(size),
              buildPassword(size),
              buildConfirmPassword(size),
              buildButtonCreate(size)
            ],
          )),
    );
  }

  updateProfile() async {
    var message;
  }

  _picImageFromGallery() async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    var imagePath = pickedFile!.path;

    File imageFile = File(imagePath);

    await locator.get<UserController>().uploadProfilePicture(imageFile);
    // setState(() {});
    getImageUrlFromFirebaseStoreage();
  }

  _pickImageFromCamera() async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    var imagePath = pickedFile!.path;
    File imageFile = File(imagePath);
    await locator.get<UserController>().uploadProfilePicture(imageFile);
    // setState(() {});
    getImageUrlFromFirebaseStoreage();
  }

  Row buildName(double imageSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: imageSize * 0.6,
          child: TextFormField(
            controller: _userEmailController,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Username :',
              prefixIcon: Icon(
                Icons.face,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double imageSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: imageSize * 0.6,
          child: Form(
            key: _key2,
            child: TextFormField(
              controller: passwordController,
              validator: validatePassword,
              obscureText: statusRedEye,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      statusRedEye = !statusRedEye;
                    });
                  },
                  icon: statusRedEye
                      ? Icon(
                          Icons.remove_red_eye,
                          color: MyConstant.dark,
                        )
                      : Icon(
                          Icons.remove_red_eye_outlined,
                          color: MyConstant.dark,
                        ),
                ),
                labelStyle: MyConstant().h3Style(),
                labelText: 'New Password :',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: MyConstant.dark,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildConfirmPassword(double imageSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: imageSize * 0.6,
          child: TextFormField(
            controller: confirmController,
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: statusRedEye
                    ? Icon(
                        Icons.remove_red_eye,
                        color: MyConstant.dark,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: MyConstant.dark,
                      ),
              ),
              labelStyle: MyConstant().h3Style(),
              labelText: 'Confirm Password :',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildEmail(double imageSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: imageSize * 0.6,
          child: Form(
            key: _key1,
            child: TextFormField(
              controller: emailController,
              validator: validateEmail,
              decoration: InputDecoration(
                labelStyle: MyConstant().h3Style(),
                labelText: 'Email :',
                prefixIcon: Icon(
                  Icons.email,
                  color: MyConstant.dark,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildButtonCreate(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (_key1.currentState!.validate() &&
                  _key2.currentState!.validate()) {}
            },
            child: Text(
              'Done!',
              style: TextStyle(color: MyConstant.light),
            ),
          ),
        ),
      ],
    );
  }

  String pickLinkAvatar = '';
  void getImageUrlFromFirebaseStoreage() async {
    FirebaseStorage st = FirebaseStorage.instance;
    Reference ref = st.ref().child("user/profile/${_currentUser.uid}");
    ref.getDownloadURL().then((value) async {
      setState(() {
        pickLinkAvatar = value;
        print("test reload avatar url ###############");
      });
    });
  }

  Container buildUserAvatar() {
    return Container(
        child: GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text("From Gallery"),
                      onTap: () {
                        _picImageFromGallery();

                        Navigator.of(context).pop();

                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text("From Camera"),
                      onTap: () {
                        _pickImageFromCamera();

                        Navigator.of(context).pop();

                        setState(() {});
                      },
                    )
                  ],
                ),
              );
            });
      },
      child: Center(
          child: _currentUser.avatarUrl == null
              ? CircleAvatar(
                  radius: 50.0,
                  child: Icon(Icons.photo_camera),
                )
              : CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(
                      _currentUser.avatarUrl ?? MyConstant.iconCamera),
                )),
    ));
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Email address is required.';
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) {
    return 'Invalid Email Address format.';
  }
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password is required.';
  }
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return 'Password must be at least 8 characters,\n include an uppercase letter, number \n and symbol.';
  }
}

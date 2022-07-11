import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:learn_layout/locator.dart';
import 'package:learn_layout/states/home.dart';

import 'package:learn_layout/utility/my_constant.dart';
import 'package:learn_layout/utility/service_locator.dart';
import 'package:learn_layout/view_controller/user_controller.dart';
import 'package:learn_layout/widgets/show_description.dart';
import 'package:learn_layout/widgets/show_image.dart';
import 'package:learn_layout/widgets/show_title.dart';

import '../repository/auth_repo.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool statusRedEye = true;
  String? username;
  String? pass;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _key2 = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    checkAuth(context);
  }

  Widget build(BuildContext context) {
    // สร้างตัวแปร imageSize สำหรับควบคุมขนาดรูปภาพให้แปรผันตามขนาดจอ
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          behavior: HitTestBehavior.opaque,
          child: ListView(
            children: [
              buildImage(size),
              buildAppName(),
              buildAppDescription(),
              buildUser(size),
              buildPassword(size),
              buildLogin(size),
              buildButtonForgotPassword(size),
              buildCreateAccount(),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    await locator
        .get<UserController>()
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        // await _auth
        //     .signInWithEmailAndPassword(

        //         email: emailController.text.trim(),
        //         password: passwordController.text.trim())
        .then((user) {
      checkAuth(context);
    }).catchError((error) {
      print("Error ###### $error");
      final snackBar = SnackBar(
        content: Text(
          error.message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      // scaffoldKey.currentState?.showSnackBar(snackBar);ใช้ไม่ได้
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future checkAuth(BuildContext context) async {
    var user = await _auth.currentUser;
    // final user1 = _auth.currentUser;
    // final u = _auth.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(user),
            ));
      });
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Home(user)));
    }
  }

  Row buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'New Account ?',
          textStyle: MyConstant().h3Style(),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pushNamed(context, MyConstant.routeCreateUser),
          child: Text('Create Account'),
        ),
      ],
    );
  }

  Row buildLogin(double size) {
    String errorMessage = '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () async {
              // await HttpService.login(username, pass, context);
              if (_key1.currentState!.validate() &&
                  _key2.currentState!.validate()) {
                // try {
                await signIn();
                // } on FirebaseAuthException catch (error) {
                //   errorMessage = error.message!;
                // }
                setState(() {});
              }
            },
            child: Text(
              'Login',
              style: TextStyle(color: MyConstant.light),
            ),
          ),
        ),
      ],
    );
  }

  Row buildButtonForgotPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myRedButtonStyle(),
            onPressed: () {
              Navigator.pushNamed(context, MyConstant.routeResetPassword);
              setState(() {});
            },
            child: Text(
              'Forgot password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Row buildUser(double imageSize) {
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
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              decoration: InputDecoration(
                labelStyle: MyConstant().h3Style(),
                labelText: 'Email :',
                prefixIcon: Icon(
                  Icons.email_outlined,
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
              onChanged: (value) {
                setState(() {
                  pass = value;
                });
              },
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
                labelText: 'Password :',
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

  Row buildAppDescription() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowDescription(
          title: MyConstant.appDescription,
          textStyle: MyConstant().h2Style(),
        ),
      ],
    );
  }

  Row buildAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: MyConstant.appName,
          textStyle: MyConstant().h1Style(),
        ),
      ],
    );
  }

  Row buildImage(double imageSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: imageSize * 0.6,
            child: ShowImage(pathImage: MyConstant.image4)),
      ],
    );
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

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:learn_layout/models/user_models.dart';
import 'package:learn_layout/states/authen.dart';
import 'package:learn_layout/utility/my_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../locator.dart';
import '../view_controller/user_controller.dart';

// import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  final User user;
  // final UserModel user;

  const Home(this.user, {Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserModel _currentUser = locator.get<UserController>().currentUser;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => getImageUrlFromFirebaseStoreage());
    getImageUrlFromFirebaseStoreage();
    print("Hi there!");
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          height: size.height * 0.8,
          decoration: BoxDecoration(
              image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(MyConstant.blueBanner),
          )),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                buildHeader(),
                Expanded(
                  child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      children: <Widget>[
                        buildAI(),
                        buildDrugs(),
                        buildChat(),
                        buildCoin(),
                      ],
                      crossAxisCount: 2),
                ),
              ],
            ),
          ),
        ),
        buildAdV(size)
      ],
    ));
  }

  Container buildAdV(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.75),
      child: ClipRect(
        // Banner
        child: Banner(
          message: "20% off ! !",
          location: BannerLocation.topEnd,
          color: MyConstant.primary,
          child: Container(
            color: Colors.green[100],
            height: size.height * 0.25,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                children: <Widget>[
                  Image.network(
                    'https://i.ibb.co/vq9bTnV/New-Project.png',
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Text('Your error widget');
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildHeader() {
    var user_profile = _auth.currentUser;
    // เอา string ที่อยู่หลัง @ ออกทั้งหมด
    var userName = user_profile!.email.toString();
    userName = userName.substring(0, userName.indexOf('@'));

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 64,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(pickLinkAvatar),
            radius: 32,
          ),
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName.toString(),
                style: TextStyle(
                    fontFamily: "Kanit Bold",
                    color: Color(0xff60b07a),
                    fontSize: 16),
              ),
              InkWell(
                child: Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: "Kanit Regular",
                      color: Color(0xff60b07a),
                      fontSize: 15),
                ),
                onTap: () {
                  Navigator.pushNamed(context, MyConstant.routeUserProfile)
                      .then((value) => getImageUrlFromFirebaseStoreage());
                  setState(() {});
                },
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Color(0xff60b07a),
            ),
            child: Container(
              margin: EdgeInsets.all(5),
              child: Center(
                  child: Row(
                children: [
                  // Text(
                  //   ' \$100',
                  //   style: TextStyle(
                  //     fontFamily: "Kanit Bold",
                  //     fontSize: 15,
                  //     color: Colors.yellow[300],
                  //   ),
                  // ),
                  IconButton(
                      onPressed: () {
                        signOut(context);
                      },
                      icon: Icon(Icons.exit_to_app))
                ],
              )),
            ),
          )
        ],
      ),
    );
  }

  Card buildAI() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: ElevatedButton(
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAiIdentification),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              MyConstant.ai,
              height: 100,
            ),
            Text(
              'AI Drug Identification',
              style: TextStyle(
                  fontFamily: "Kanit Regular",
                  fontSize: 15,
                  color: Color(0xff60b07a)),
            )
          ],
        ),
      ),
    );
  }

  Card buildDrugs() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, MyConstant.routeAlldrugs),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              MyConstant.image2,
              height: 100,
            ),
            Text(
              'All Drugs List',
              style: TextStyle(
                  fontFamily: "Kanit Regular",
                  fontSize: 15,
                  color: Color(0xff60b07a)),
            )
          ],
        ),
      ),
    );
  }

  Card buildChat() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              MyConstant.chat,
              height: 100,
            ),
            Text(
              'Chat Room',
              style: TextStyle(
                  fontFamily: "Kanit Regular",
                  fontSize: 15,
                  color: Color(0xff60b07a)),
            )
          ],
        ),
      ),
    );
  }

  Card buildCoin() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              MyConstant.coin,
              height: 100,
            ),
            Text(
              'Collect \$DDen Coin',
              style: TextStyle(
                  fontFamily: "Kanit Regular",
                  fontSize: 15,
                  color: Color(0xff60b07a)),
            )
          ],
        ),
      ),
    );
  }

  void signOut(BuildContext context) {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Authen()),
        ModalRoute.withName('/'));
  }
}

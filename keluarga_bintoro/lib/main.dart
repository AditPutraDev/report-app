import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'ui/pages/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(primaryColor: Color(0xFFB71C1C), fontFamily: "Quicksand"),
        title: 'Keluarga Bintoro',
        home: LandingPage());
  }
}

// class SplashPage extends StatefulWidget {
//   @override
//   _SplashPageState createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 3), () {
//       checkLoginStatus();
//     });
//   }

//   checkLoginStatus() async {
//     final SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//     final String token =
//         sharedPreferences.getString("token"); //change with access_token
//     print(token);
//     if (token == null || token.isEmpty) {
//       Navigator.push(context, MaterialPageRoute(builder: (_) => LandingPage()));
//     } else {
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (BuildContext context) => HomePage()),
//           (Route<dynamic> route) => false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red[900],
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // FlutterLogo(
//           //   size: 80,
//           // ),
//           SpinKitThreeBounce(color: Colors.white, size: 24)
//         ],
//       ),
//     );
//   }
// }

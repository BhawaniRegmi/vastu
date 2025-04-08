// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:logistics/main_presenter.dart';
// import 'package:logistics/scan.dart';

// import 'login/login_screen.dart';


// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
//     runApp(new MyApp());
//   });
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home:
//      SplashPage()
//     );
//   }

// }

// class SplashPage extends StatefulWidget {
//   SplashPage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _SplashPage createState() => _SplashPage();
// }



// class _SplashPage  extends State<SplashPage> implements SplashContract{


//   BuildContext _ctx;
//   SplashPresenter _presenter;
//   final scaffoldKey = new GlobalKey<ScaffoldState>();

//   _SplashPage() {

//     _presenter = new SplashPresenter(this);

//   }

//   @override
//   void initState() {
//     super.initState();


//     _checkUserStatus();
//   }

//   void _checkUserStatus() {
//     _presenter.isLogin();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _ctx = context;
//     return Scaffold(
//         body:  Center(
//       child: Container(
//         margin: EdgeInsets.all(40),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/splash_logo.png"),
//           ),
//         ),
//       ),
//     ));
//   }

//   @override
//   void isLogin(bool status) {

//     Future.delayed(const Duration(milliseconds: 1000), () {
//       if(status == true){
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => QRViewExample()),
//               (Route<dynamic> route) => false,
//         );

//         // Navigator.pushAndRemoveUntil(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => PackageDetailScreen(code:"IND04GHBP67D" ,)),
//         //       (Route<dynamic> route) => false,
//         // );

//         // Navigator.push(
//         //   _ctx,
//         //   MaterialPageRoute(builder: (context) => PackageDetailPage(code: "IND03GKB4ZFC",)),
//         // );
//       }
//       else{
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//               (Route<dynamic> route) => false,
//         );
//       }
//     });

//   }
// }


import 'package:flutter/material.dart';
import 'package:logistics/galliMap/alertDialog.dart';
import 'package:logistics/galliMap/signatureMap.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignatureMap(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  void showCustomSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('Are you sure marked location is delivered location?')),
          TextButton(
            onPressed: () {
              print("Yes pressed");
              
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.pop(context);
            },
            child: Text('YES'),
          ),
          TextButton(
            onPressed: () {
              print("No pressed");
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Text('NO'),
          ),
        ],
      ),
      duration: Duration(seconds: 12),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Snackbar Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignatureMap()),
            ),
          child: Text('Show Snackbar'),
        ),
      ),
    );
  }
}

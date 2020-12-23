part of 'pages.dart';

class HomePage extends StatefulWidget {
  final String role, imageUrl;
  HomePage({this.role, this.imageUrl});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final title = ["Daily Report", "Quality Control"];
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("access_token") == "access_token") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LandingPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LandingPage()),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        ),
        body: ListView(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(color: Colors.red[900]),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10, left: 28),
                    child: Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(widget.imageUrl)),
                        SizedBox(width: 8),
                        Text(
                          "Selamat Datang,\nKeluarga Bintoro",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 90, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          height: height / 4,
                          width: width / 2.2,
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.red[400],
                            child: Center(child: Text("Daily Report")),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DailyReportPage(title[0])));
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: height / 4,
                          width: width / 2.2,
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.red[400],
                            child: Center(child: Text("Quality Control")),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListProjectPage(
                                      title: title[1], role: widget.role)));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
        // body: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: title.length,
        //     itemBuilder: (context, i) {
        //       return Card(
        //         child: Column(
        //           children: [Text(title[i])],
        //         ),
        //       );
        //     }),
        );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 360.0 - 200);
    path.quadraticBezierTo(size.width / 2, 240, size.width, 360.0 - 200);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

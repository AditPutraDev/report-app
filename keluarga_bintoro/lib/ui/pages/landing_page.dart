part of 'pages.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final auth = [cleanAuthUrl + "login", pestAuthUrl + "login"];
  final role = [cleanAuthUrl, pestAuthUrl];
  final image = [
    "https://crm.bintorocorp.co.id/assets/web/img/order-services/1592749458.png",
    "https://crm.bintorocorp.co.id/assets/web/img/order-services/1592750075.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        automaticallyImplyLeading: false,
        elevation: 0,
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
                child: Text("Pilih Jenis Jasa",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 90, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Menus(
                      image: image[0],
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SignInPage(
                                      authUrl: auth[0],
                                      role: role[0],
                                      imageUrl: image[0],
                                    )));
                      },
                    ),
                    Menus(
                      image: image[1],
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SignInPage(
                                      authUrl: auth[1],
                                      role: role[1],
                                      imageUrl: image[1],
                                    )));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

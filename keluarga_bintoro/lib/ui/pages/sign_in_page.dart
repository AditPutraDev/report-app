part of 'pages.dart';

class SignInPage extends StatefulWidget {
  final String authUrl, role, imageUrl;
  SignInPage({this.authUrl, this.role, this.imageUrl});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController usernameController =
      TextEditingController(text: "fairuz");
  TextEditingController passwordController =
      TextEditingController(text: "fairuz");

  bool isPasswordValid = false;
  bool isSigningIn = false;
  bool _secureText = true;
  bool _isLoading = false;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.red[900],
              Colors.red[800],
              Colors.red[400],
            ],
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 30, bottom: 20),
                      child: Text("Selamat Datang,\nKeluarga Bintoro",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 65),
                    TextField(
                      cursorColor: Colors.red,
                      controller: usernameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Username",
                          hintText: "Username"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            isPasswordValid = text.length >= 0;
                          });
                        },
                        cursorColor: Colors.red,
                        obscureText: _secureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Password",
                            hintText: "Password",
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 40, bottom: 30),
                      child: RaisedButton(
                          color: Colors.red[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: _isLoading
                              ? SpinKitThreeBounce(
                                  color: Colors.white, size: 24)
                              : Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                          onPressed: usernameController.text == "" ||
                                  passwordController.text == ""
                              ? null
                              : () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  signIn(usernameController.text,
                                      passwordController.text);
                                }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  signIn(String username, password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': username, 'password': password};
    var jsonResponse = null;

    var response = await http.post(widget.authUrl, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode != 401 && jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString(
            "access_token", jsonResponse['access_token']);
        sharedPreferences.setString("link", jsonResponse['link']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomePage(role: widget.role, imageUrl: widget.imageUrl),
            ),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
      print(response.statusCode);
    }
  }
}

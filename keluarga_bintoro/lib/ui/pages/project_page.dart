part of 'pages.dart';

class ProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Text("Project"),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Container(
                height: 50,
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Center(child: Text("Persiapan")),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Center(child: Text("Material")),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Center(child: Text("Proses")),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Center(child: Text("Hasil")),
                ),
              ),
            ])));
  }
}

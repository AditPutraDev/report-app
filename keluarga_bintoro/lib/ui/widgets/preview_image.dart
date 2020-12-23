part of 'widgets.dart';

class DetailPage extends StatelessWidget {
  final String image;
  DetailPage({this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          SafeArea(
              child: Container(
            color: Colors.white,
          )),
          Hero(
            tag: image,
            child: Material(
              child: InkWell(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: image,
                    placeholder: (context, url) => Center(
                        child: SpinKitCircle(
                      color: Colors.red[900],
                    )),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  //Image.network(image, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

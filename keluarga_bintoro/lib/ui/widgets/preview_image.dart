part of 'widgets.dart';

class DetailPage extends StatelessWidget {
  final String image;
  DetailPage({this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.red[900],
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
          Container(
            width: double.infinity,
            height: 55,
            color: Colors.red[900],
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

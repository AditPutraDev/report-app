part of 'widgets.dart';

class Menus extends StatelessWidget {
  final String image;
  final Function onTap;
  Menus({this.image, this.onTap});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      child: Container(
        height: height / 4.5,
        width: width / 2.2,
        child: Card(
          elevation: 5,
          shadowColor: Colors.red[400],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CachedNetworkImage(
              imageUrl: image,
              placeholder: (context, url) => Center(
                  child: SpinKitCircle(
                color: Colors.red[900],
              )),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

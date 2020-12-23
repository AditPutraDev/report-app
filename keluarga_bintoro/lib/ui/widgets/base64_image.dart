part of 'widgets.dart';

class Base64Image extends StatelessWidget {
  final String data;
  final double width;
  const Base64Image(
    this.data, {
    Key key,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null || data.isEmpty) {
      return Container(
        color: Colors.grey[100],
        child: Icon(
          Icons.image_outlined,
          color: Colors.grey,
        ),
        width: width,
        height: width,
      );
    }
    final _bytesImage = Base64Decoder().convert(data);
    return Image.memory(
      _bytesImage,
      fit: BoxFit.cover,
      width: width,
      height: width,
      colorBlendMode: BlendMode.darken,
    );
  }
}

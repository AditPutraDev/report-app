part of 'pages.dart';

class DailyReportPage extends StatelessWidget {
  final String title;
  DailyReportPage(this.title);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        centerTitle: true,
        title: Text(title),
      ),
    );
  }
}

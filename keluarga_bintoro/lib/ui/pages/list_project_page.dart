part of 'pages.dart';

class ListProjectPage extends StatefulWidget {
  final String role, title;
  ListProjectPage({this.role, this.title});
  @override
  _ListProjectPageState createState() => _ListProjectPageState();
}

class _ListProjectPageState extends State<ListProjectPage> {
  bool isLoading = false;
  bool more = true;

  List<ReportModel> dataProject = List();
  ScrollController _scrollController = ScrollController();

  _loadMore() async {
    setState(() {
      isLoading = true;
    });

    final data = await ProjectService.getListProject(role: widget.role);

    if (data.reports != null && data.reports.isNotEmpty) {
      setState(() {
        isLoading = false;
        dataProject.addAll(data.reports);
      });
    } else {
      setState(() {
        isLoading = false;
        more = false;
      });
    }
  }

  _loadData() async {
    setState(() {
      isLoading = true;
    });
    final data = await ProjectService.getListProject(role: widget.role);

    if (data.reports != null && data.reports.isNotEmpty) {
      setState(() {
        dataProject.addAll(data.reports);
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    this._loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (more) _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Text(
                  "Report",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 12),
            (dataProject.isEmpty && isLoading)
                ? Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.red[900],
                    ),
                  )
                : Center(
                    child: Card(
                      elevation: 3,
                      shadowColor: Colors.red[400],
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text("Subjek Jadwal")),
                          DataColumn(label: Text("Tanggal")),
                        ],
                        rows: dataProject
                            .map(
                              (report) => DataRow(cells: [
                                DataCell(Text(report.eventName ?? "")),
                                DataCell(Text(report.updateAt ?? ""))
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                  ),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: RaisedButton(
            color: Colors.red[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Text(
              "Create New",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QualityControlPage(
                        title: widget.title, role: widget.role))),
          ),
        ),
      ),
    );
  }
}

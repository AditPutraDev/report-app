part of 'pages.dart';

class QualityControlPage extends StatefulWidget {
  final String title, role;
  QualityControlPage({this.title, this.role});

  @override
  _QualityControlPageState createState() => _QualityControlPageState();
}

class _QualityControlPageState extends State<QualityControlPage> {
  List<Schedule> schedules;

  bool isLoading = false;
  int projectIndex = 0;
  int scheduleIndex = 0;

  bool more = true;
  List<ProjectModel> dataProject = List();
  List<dynamic> data = List();
  List<dynamic> projectList = List();
  List<dynamic> reportData = List();
  ScrollController _scrollController = ScrollController();

  _loadMore() async {
    setState(() {
      isLoading = true;
    });

    final data = await ProjectService.getProjectsData(role: widget.role);

    if (data.projects != null && data.projects.isNotEmpty) {
      setState(() {
        isLoading = false;
        dataProject.addAll(data.projects);
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
    final data = await ProjectService.getProjectsData(role: widget.role);

    if (data.projects != null && data.projects.isNotEmpty) {
      setState(() {
        dataProject.addAll(data.projects);
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
    projectList.length;
    super.dispose();
  }

  String _project = "";
  String _idSchedule = "";

  final picker = ImagePicker();

  imgSourceDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ambil Gambar Dari"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.photo),
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Tutup",
                style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      String baseimage = base64Encode(imageBytes);

      print(baseimage);

      return ImageModel(
        base64: baseimage,
        name: pickedFile.path.split("/").last,
      );
    }
    return null;
  }

  void submitHandler() async {
    SchedulePost schedulePost = SchedulePost(
      eventId: int.parse(_idSchedule),
      details: schedules.map((e) {
        return Detail(
          date: e.date,
          detailId: e.detailId,
          name: e.name,
          imageAfter: e.data.imageAfters
              .map(
                (v) => ImagePost(
                  image: v.base64,
                  name: v.name,
                  path: v.path,
                ),
              )
              .toList(),
          imageBefore: e.data.imageBefores
              .map(
                (v) => ImagePost(
                  image: v.base64,
                  name: v.name,
                  path: v.path,
                ),
              )
              .toList(),
          information: e.data.information,
          suggestion: e.data.suggestion,
          qty: e.data.qty,
        );
      }).toList(),
    );

    String data = schedulePostToJson(schedulePost);
    print(data);
    setState(() {
      isLoading = true;
    });
    await ProjectService.postReport(role: widget.role, data: data).then((res) {
      if (res == true) {
        Navigator.of(context).pop();
      }
    });
    setState(() {
      isLoading = false;
    });
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
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Subjek Jadwal",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              (dataProject.isEmpty && isLoading)
                  ? Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.red[900],
                      ),
                    )
                  : DropdownButton<ProjectModel>(
                      isExpanded: true,
                      hint: Text("Pilih subjek jadwal"),
                      value: _project != "" ? dataProject[projectIndex] : null,
                      items: dataProject.map((value) {
                        return DropdownMenuItem(
                          child: Container(
                              child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Text(value.text.toString()))),
                          value: value,
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await ProjectService.getProjectsById(
                                    id: value.id.toString(), role: widget.role)
                                .then((value) {
                              schedules = value;
                              setState(() {});
                              schedules.forEach((element) {
                                if (element.data != null &&
                                    element.data.imageAfters != null)
                                  element.data.imageAfters.forEach((e) async {
                                    e.base64 =
                                        await networkImageToBase64(e.src);
                                  });
                                if (element.data != null &&
                                    element.data.imageBefores != null)
                                  element.data.imageBefores.forEach((e) async {
                                    e.base64 =
                                        await networkImageToBase64(e.src);
                                    // print(e.src);
                                    // print(e.path);
                                    // print(e.base64);
                                  });
                                setState(() {});
                              });
                            });
                            setState(() {
                              isLoading = false;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _project = value.text;
                          _idSchedule = value.id.toString();
                          //_getProjectListById(id: value.id.toString());
                          projectIndex = dataProject
                              .indexWhere((e) => e.text == value.text);
                        });
                      },
                    ),
              // (projectList.isEmpty && isLoading && projectIndex == null)
              //     ? Center(
              //         child: SpinKitThreeBounce(
              //           size: 24,
              //           color: Colors.red[900],
              //         ),
              //       )
              //     : DropdownButton(
              //         isExpanded: true,
              //         hint: Text("Select Your Project"),
              //         value: _project != "" ? projectList[projectIndex] : null,
              //         items: projectList.map((value) {
              //           return DropdownMenuItem(
              //             child: Text(value['text']),
              //             value: value,
              //           );
              //         }).toList(),
              //         onChanged: (value) {
              //           setState(() {
              //             _getProjectListById(id: value['id'].toString());
              //             _project = value['text'];
              //             projectIndex = projectList
              //                 .indexWhere((e) => e['text'] == value['text']);
              //           });
              //         },
              //       ),
              SizedBox(height: 24),
              // DropdownButton(
              //   isExpanded: true,
              //   hint: Text("Select Your Pekerjaan"),
              //   value: _valFriends,
              //   items: _myFriends.map((value) {
              //     return DropdownMenuItem(
              //       child: Text(value),
              //       value: value,
              //     );
              //   }).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       _valFriends = value;
              //     });
              //   },
              // ),
              if (schedules != null && isLoading)
                Center(
                  child: SpinKitThreeBounce(
                    size: 24,
                    color: Colors.red[900],
                  ),
                ),
              // if (schedules != null && !isLoading)
              //   TextField(
              //     decoration: InputDecoration(labelText: 'Event ID'),
              //     controller: TextEditingController(text: _idSchedule),
              //     enabled: false,
              //   ),
              if (schedules != null && !isLoading)
                ...schedules.map(
                  (e) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TextField(
                        //   decoration: InputDecoration(labelText: 'Detail ID '),
                        //   controller: TextEditingController(
                        //       text: e.detailId.toString()),
                        //   enabled: false,
                        // ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Jasa',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          controller: TextEditingController(text: e.name),
                          onChanged: (val) {
                            e.name = val;
                          },
                        ),
                        Row(children: [
                          Expanded(
                            child: TextField(
                              onTap: () async {
                                var date = await showDatePicker(
                                    context: context,
                                    initialDate: e.date ?? DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract((Duration(days: 365))),
                                    lastDate: DateTime.now()
                                        .add((Duration(days: 365))));
                                if (date != null) {
                                  e.date = date;
                                  setState(() {});
                                }
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Tanggal',
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              controller: TextEditingController(
                                  text: e.date.toString().split(' ').first),
                            ),
                          ),
                          SizedBox(width: 25),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Jumlah Tertangkap',
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              controller: TextEditingController(
                                  text: e.data?.qty?.toString() ?? '0'),
                              onChanged: (val) {
                                e.data.qty = int.tryParse(val ?? '0') ?? 0;
                              },
                            ),
                          ),
                        ]),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Saran',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          controller: TextEditingController(
                              text: e.data?.suggestion ?? ''),
                          onChanged: (val) {
                            e.data.suggestion = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Keterangan',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          controller: TextEditingController(
                              text: e.data?.information ?? ''),
                          onChanged: (val) {
                            e.data.information = val;
                          },
                        ),
                        SizedBox(height: 20),
                        Text('Gambar Sebelum Pengerjaan *',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        if (e.data != null)
                          ...e.data.imageBefores.map((v) {
                            return Row(
                              children: [
                                Expanded(
                                  child: v.base64 != null
                                      ? Base64Image(v.base64)
                                      : Hero(
                                          tag: v.src,
                                          child: Material(
                                            child: InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    DetailPage(image: v.src),
                                              )),
                                              child: Container(
                                                width: 100,
                                                height: 250,
                                                child: Card(
                                                  child: CachedNetworkImage(
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    imageUrl: v.src,
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                SpinKitCircle(
                                                      color: Colors.red[900],
                                                    )),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    e.data.imageBefores
                                        .removeWhere((element) => element == v);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[900],
                                  ),
                                )
                              ],
                            );
                          }),
                        SizedBox(height: 10),
                        FlatButton(
                          child: Container(
                            width: double.maxFinite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.file_upload),
                                Text('upload gambar'),
                              ],
                            ),
                            alignment: Alignment.center,
                          ),
                          color: Colors.grey[300],
                          onPressed: () async {
                            final imgSource = await imgSourceDialog();
                            if (imgSource != null) {
                              await getImage(imgSource).then((v) {
                                if (v is ImageModel) {
                                  e.data.imageBefores.add(v);
                                  setState(() {});
                                }
                              });
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        Text('Gambar Sesudah Pengerjaan *',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        if (e.data != null)
                          ...e.data.imageAfters.map((v) {
                            return Row(
                              children: [
                                Expanded(
                                  child: v.base64 != null
                                      ? Base64Image(v.base64)
                                      : Hero(
                                          tag: v.src,
                                          child: Material(
                                            child: InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    DetailPage(image: v.src),
                                              )),
                                              child: Container(
                                                width: 100,
                                                height: 250,
                                                child: Card(
                                                  child: CachedNetworkImage(
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    imageUrl: v.src,
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                SpinKitCircle(
                                                      color: Colors.red[900],
                                                    )),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    e.data.imageAfters
                                        .removeWhere((element) => element == v);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[900],
                                  ),
                                )
                              ],
                            );
                          }),
                        SizedBox(height: 10),
                        FlatButton(
                          child: Container(
                            width: double.maxFinite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.file_upload),
                                Text('upload gambar'),
                              ],
                            ),
                            alignment: Alignment.center,
                          ),
                          color: Colors.grey[300],
                          onPressed: () async {
                            final imgSource = await imgSourceDialog();
                            if (imgSource != null) {
                              await getImage(imgSource).then((v) {
                                if (v is ImageModel) {
                                  e.data.imageAfters.add(v);
                                  setState(() {});
                                }
                              });
                            }
                          },
                        ),
                        Divider(
                          height: 25,
                          color: Colors.grey,
                        ),
                      ],
                    );
                  },
                ).toList(),
              SizedBox(height: 100),
            ],
          ),
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
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => submitHandler(),
          ),
        ),
      ),
    );
  }
}

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
            ListView(
              children: [
                Hero(
                  tag: image,
                  child: Material(
                      child: InkWell(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: Image.network(image, fit: BoxFit.cover),
                    ),
                  )),
                ),
              ],
            ),
          ],
        ));
  }
}

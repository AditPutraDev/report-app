import 'dart:convert';

List<Schedule> scheduleFromJson(String str) =>
    List<Schedule>.from(json.decode(str).map((x) => Schedule.fromJson(x)));

class Schedule {
  Schedule({
    this.detailId,
    this.name,
    this.date,
    this.data,
  });

  int detailId;
  String name;
  DateTime date;
  Data data;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        detailId: json["detail_id"] == null ? null : json["detail_id"],
        name: json["name"] == null ? null : json["name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        data: json["data"] == null || json["data"] is String
            ? Data(
                imageBefores: [],
                imageAfters: [],
              )
            : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.reportId,
    this.clientOrderDetailId,
    this.qty,
    this.imageBefore,
    this.imageAfter,
    this.suggestion,
    this.information,
    this.imageBefores,
    this.imageAfters,
  });

  int reportId;
  int clientOrderDetailId;
  int qty;
  String imageBefore;
  String imageAfter;
  String suggestion;
  String information;
  List<ImageModel> imageBefores;
  List<ImageModel> imageAfters;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        reportId: json["report_id"] == null ? null : json["report_id"],
        clientOrderDetailId: json["client_order_detail_id"] == null
            ? null
            : json["client_order_detail_id"],
        qty: json["qty"] == null ? null : json["qty"],
        imageBefore: json["image_before"] == null ? null : json["image_before"],
        imageAfter: json["image_after"] == null ? null : json["image_after"],
        suggestion: json["suggestion"] == null ? null : json["suggestion"],
        information: json["information"] == null ? null : json["information"],
        imageBefores: json["image_befores"] == null
            ? null
            : List<ImageModel>.from(
                json["image_befores"].map((x) => ImageModel.fromJson(x))),
        imageAfters: json["image_afters"] == null
            ? null
            : List<ImageModel>.from(
                json["image_afters"].map((x) => ImageModel.fromJson(x))),
      );
}

class ImageModel {
  ImageModel({
    this.name,
    this.src,
    this.path,
    this.base64,
  });

  String name;
  String src;
  String path;
  String base64;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        src: json["src"] == null ? null : json["src"],
        path: json["path"] == null ? null : json["path"],
      );
}

String schedulePostToJson(SchedulePost data) => json.encode(data.toJson());

class SchedulePost {
  SchedulePost({
    this.eventId,
    this.details,
  });

  int eventId;
  List<Detail> details;

  Map<String, dynamic> toJson() => {
        "event_id": eventId == null ? null : eventId,
        "details": details == null
            ? null
            : List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    this.detailId,
    this.qty,
    this.name,
    this.date,
    this.imageBefore,
    this.imageAfter,
    this.suggestion,
    this.information,
  });

  int detailId;
  int qty;
  String name;
  DateTime date;
  List<ImagePost> imageBefore;
  List<ImagePost> imageAfter;
  String suggestion;
  String information;

  Map<String, dynamic> toJson() => {
        "detail_id": detailId == null ? null : detailId,
        "qty": qty == null ? null : qty,
        "name": name == null ? null : name,
        "date": date == null
            ? null
            : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "image_before": imageBefore == null
            ? null
            : List<dynamic>.from(imageBefore.map((x) => x.toJson())),
        "image_after": imageAfter == null
            ? null
            : List<dynamic>.from(imageAfter.map((x) => x.toJson())),
        "suggestion": suggestion == null ? null : suggestion,
        "information": information == null ? null : information,
      };
}

class ImagePost {
  ImagePost({
    this.name,
    this.path,
    this.image,
  });

  String name;
  String path;
  String image;

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "path": path == null ? null : path,
        "image": image == null ? null : image,
      };
}

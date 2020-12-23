import 'dart:convert';

class ProjectModel {
  int id;
  String text;

  ProjectModel({this.id, this.text});
  factory ProjectModel.fromJson(Map<String, dynamic> map) {
    return ProjectModel(id: map['id'], text: map['text']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "text": text};
  }

  @override
  String toString() {
    return 'Data Project{id: $id, text: $text}';
  }

  List<ProjectModel> projectFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<ProjectModel>.from(
        data.map((item) => ProjectModel.fromJson(item)));
  }

  String projectToJson(ProjectModel data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}

class ReportModel {
  int id;
  String updateAt;
  String eventName;
  ReportModel({this.updateAt, this.id, this.eventName});
  factory ReportModel.fromJson(Map<String, dynamic> map) {
    return ReportModel(
        id: map['id'],
        updateAt: map['updated_at'],
        eventName: map['event']['name']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "updated_at": updateAt, "name": eventName};
  }

  @override
  String toString() {
    return 'List Project{id: $id, updated_at: $updateAt, name: $eventName}';
  }

  List<ReportModel> reportFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<ReportModel>.from(
        data.map((item) => ReportModel.fromJson(item)));
  }

  String reportToJson(ReportModel data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}

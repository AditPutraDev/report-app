import 'package:keluarga_bintoro/models/project_model.dart';

class Projects {
  List<ProjectModel> projects;
  bool more;

  Projects({this.projects, this.more});
  factory Projects.fromJosn(Map<String, dynamic> json) {
    return Projects(
        more: json['pagination']['more'] as bool,
        projects: (json["results"] as List)
            .map((e) => e == null ? null : ProjectModel.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() => {"more": more, "projects": projects};
}

class Report {
  List<ReportModel> reports;
  bool more;
  Report({this.more, this.reports});
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        more: json['more'] as bool,
        reports: (json["results"] as List)
            .map((e) => e == null ? null : ReportModel.fromJson(e))
            .toList());
  }
  Map<String, dynamic> toJson() => {"more": more, "report": reports};
}

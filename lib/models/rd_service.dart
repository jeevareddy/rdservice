part of 'package:rdservice/rdservice.dart';

class RDService {
  late final String info;
  late final String status;

  bool get isReady {
    return status == "READY";
  }

  RDService(this.info, this.status);

  RDService.fromJson(Map<String, dynamic> json) {
    info = json['info'] ?? '';
    status = json['status'] ?? '';
  }
  Map<String, dynamic> toJson() {
    return {
      'info': info,
      'status': status,
    };
  }
}

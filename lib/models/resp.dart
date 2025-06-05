part of 'package:rdservice/rdservice.dart';

class Resp {
  late final String errCode;

  late final String errInfo;

  late final String fCount;

  late final String fType;

  late final String iCount;

  late final String iType;

  late final String pCount;

  late final String pType;

  late final String nmPoints;

  late final String qScore;

  Resp(this.errCode, this.errInfo, this.fCount, this.fType, this.iCount,
      this.iType, this.pCount, this.pType, this.nmPoints, this.qScore);

  Resp.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'] ?? '';
    errInfo = json['errInfo'] ?? '';
    fCount = json['fCount'] ?? '';
    fType = json['fType'] ?? '';
    iCount = json['iCount'] ?? '';
    iType = json['iType'] ?? '';
    pCount = json['pCount'] ?? '';
    pType = json['pType'] ?? '';
    nmPoints = json['nmPoints'] ?? '';
    qScore = json['qScore'] ?? '';
  }
  Map<String, dynamic> toJson() {
    return {
      'errCode': errCode,
      'errInfo': errInfo,
      'fCount': fCount,
      'fType': fType,
      'iCount': iCount,
      'iType': iType,
      'pCount': pCount,
      'pType': pType,
      'nmPoints': nmPoints,
      'qScore': qScore,
    };
  }
}

part of 'package:rdservice/rdservice.dart';

class PidData {
  late final Resp resp;

  late final DeviceInfo deviceInfo;

  late final Skey skey;

  late final String hmac;

  late final Data data;

  PidData(this.resp, this.deviceInfo, this.skey, this.hmac, this.data);

  PidData.fromJson(Map<String, dynamic> json) {
    resp = Resp.fromJson(json['Resp'] ?? {});
    deviceInfo = DeviceInfo.fromJson(json['DeviceInfo'] ?? {});
    skey = Skey.fromJson(json['Skey'] ?? {});
    hmac = json['Hmac']?['\$t'] ?? '';
    data = Data.fromJson(json['Data'] ?? {});
  }
  Map<String, dynamic> toJson() {
    return {
      'Resp': resp.toJson(),
      'DeviceInfo': deviceInfo.toJson(),
      'Skey': skey.toJson(),
      'Hmac': {'\$t': hmac},
      'Data': data.toJson(),
    };
  }
}

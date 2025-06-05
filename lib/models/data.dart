part of 'package:rdservice/rdservice.dart';

class Data {
  late final String type;
  late final String value;

  Data(this.type, this.value);

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    value = json['\$t'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      '\$t': value,
    };
  }
}
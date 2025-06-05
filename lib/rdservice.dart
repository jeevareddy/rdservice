import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:xml2json/xml2json.dart';

import 'models/skey.dart';

part 'models/data.dart';
part 'models/device_info.dart';
part 'models/pid_data.dart';
part 'models/rd_service.dart';
part 'models/resp.dart';

class Msf100 {
  static final _parser = Xml2Json();

  static const MethodChannel _channel = MethodChannel('msf100');

  static Future<PidData?> capture() async {
    final String? result = await _channel.invokeMethod('capture');
    if (result != null) {
      return _serilizePIDData(result);
    }
    return null;
  }

  static Future<RDService?> getDeviceInfo() async {
    final String? result = await _channel.invokeMethod('deviceInfo');
    if (result != null) {
      return _serilizeRDService(result);
    }
    return null;
  }

  static RDService _serilizeRDService(String rdService) {
    _parser.parse(rdService);
    final _jsonString = _parser.toGData();
    final _json = jsonDecode(_jsonString) as Map<String, dynamic>;
    final _rdService = (_json['RDService'] ?? {}) as Map<String, dynamic>;
    return RDService.fromJson(_rdService);
  }

  static PidData _serilizePIDData(String deviceInfo) {
    _parser.parse(deviceInfo);
    final _jsonString = _parser.toGData();
    final _json = jsonDecode(_jsonString) as Map<String, dynamic>;
    final _pidData = (_json['PidData'] ?? {}) as Map<String, dynamic>;
    return PidData.fromJson(_pidData);
  }
}

//Sample Data

//Device Info

// <RDService info="Mantra Authentication Vendor Device Manager" status="READY">
//   <Interface id="CAPTURE" path="in.gov.uidai.rdservice.fp.CAPTURE"/>
//   <Interface id="DEVICEINFO" path="in.gov.uidai.rdservice.fp.INFO"/>
// </RDService>


//PID Data

// <PidData>
//    <Data type="X">MjAyMS0wOS0wMVQxMToyNToyNvUrhr/kCyKbwXqD3Cp+QEFX61mmkYIfpaEBKU+Ly6EFCcotuBpu+5X5HAGO5wdHXxklAneSU/aUWIAFOA2QWvdw4Uw2XNpbMlqHYELkezAR96Efs44bbtiQYBELtg7/tIYR5U2ZNUcFkQvOhxsytTbi38a2VXtPDa3Tp2LU7EjWS6HQsWcUGmulwL6Rq9P3Im0rGbKl3ypEwAtr6sNfc5AEFOnEYauVPcicZ9qwltHt8a5oZs+burphyQEsgxsE5H/wjT0FIs0UIdQ/1XikcoTabmWKNjYUy3Hu6s4sYvpOlU/2t1m1DZKPJHXphJ51FHanCMnUx0urHeDH3T7N4qpO0JNk2HS3u2bUQgJM7+Te7sMb3w3GP9tzGDlcWe21M5nziSnAez2nN7fXeA7LmMcb/9nYyFuKF8GoNRUcNeLAph0kTGD77b0OAVnpYjTNYdXNXsE7/IeiA8ii0H+lFpkK7ANBMcn6xSNDDjn/JedAXUrwAcOuhbWitlaXPZZ0rDhgtS1dotYjD9bAipRcTjAQWPzHTcCMUPotvCwt9NJm/6eIA8gWqMq2zVurrFj2EH5fsxxh0EeIO20Ro6BbX9O4ArddOk/5tPsAfSsDFOMnVLeue7AaUj4/x+/kTKb6REGyvmkOL8A8EkugTMZuWi/P0mKjFtHXJ5TaWHuyrMHd0j+Ly6ATcLB/5/mNPjnBLhlXwzkdxKqB98AzKCJ/wNv6q50G+A/UpK0hZMV4Z++1X08WyPvE7/JTzRy4lyW1H6kwSxX0I4MLFbxgbOFHuGlAZxLyf815IMhDN9dvbyT3a3SLo0YbWYzMBCXy1denUCiR3UVqJ2T/0b9YkGYh0Fg8zRfRosrVMVjxOr22NSZ9KRN6uVOFjcJbtPlgY6PtsFQcjxJWOihrOV7lM1qSQjET1ZZCa9leaFTh/1XUMhkk6xciQ0ooJGJ2eXzF4kHAZ0S01UOCI/qaaYci7HlCZEOBXnLR0dbJ9JJLegyd5J2LlB8SWnd3ECvTjYZHeDZWgqvvf2txmBfZZM4CYaLibegCqI+uo+gBF0m4gAy6yzhp0H2+JGVVZYNWZAScvsVx2VMazVkld0DLk2mGF/ABUtpFK9UGUQ==</Data>
//    <DeviceInfo dc="d78b5e38-e452-47ac-97ef-a26b248d1d5b" dpId="MANTRA.MSIPL" mc="MIIEGjCCAwKgAwIBAgIGAXuf6o1/MA0GCSqGSIb3DQEBCwUAMIHqMSowKAYDVQQDEyFEUyBNYW50cmEgU29mdGVjaCBJbmRpYSBQdnQgTHRkIDcxQzBBBgNVBDMTOkIgMjAzIFNoYXBhdGggSGV4YSBvcHBvc2l0ZSBHdWphcmF0IEhpZ2ggQ291cnQgUyBHIEhpZ2h3YXkxEjAQBgNVBAkTCUFobWVkYWJhZDEQMA4GA1UECBMHR3VqYXJhdDEdMBsGA1UECxMUVGVjaG5pY2FsIERlcGFydG1lbnQxJTAjBgNVBAoTHE1hbnRyYSBTb2Z0ZWNoIEluZGlhIFB2dCBMdGQxCzAJBgNVBAYTAklOMB4XDTIxMDkwMTA1MzczNVoXDTIxMTAwMTA1NTIzM1owgbAxJDAiBgkqhkiG9w0BCQEWFXN1cHBvcnRAbWFudHJhdGVjLmNvbTELMAkGA1UEBhMCSU4xEDAOBgNVBAgTB0dVSkFSQVQxEjAQBgNVBAcTCUFITUVEQUJBRDEOMAwGA1UEChMFTVNJUEwxHjAcBgNVBAsTFUJpb21ldHJpYyBNYW51ZmFjdHVyZTElMCMGA1UEAxMcTWFudHJhIFNvZnRlY2ggSW5kaWEgUHZ0IEx0ZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKpeohrAtOZPTjGLc2LXu5lvxeQfwFtOv7FBJP1IKSGbsvceSeyHmU2A3Wc2or1FuLeHrjnOuu7ULCK1T+QQxuHcTQAgqrIBPMFYt+kh+TGi+yXZCEAMqbXDlXuKgv/kNReBBOanGvqDnw7m8jo/5H9mWnNHRGJAHcrQIBocQqn4EczF0BdDyIad6VSDP/5+XgkiL61Su++6RBZGVtoVoePZ5z8Pt5D920G+xngYtR/ijX2BZYlU0Tg0sbcgki41J8mtxkPODZLbxZZLyxgYOr00/ZLtfumSVac5ue/WB/LoKLlhx3Myuoe+CxldmIa3u+oLL50yrtHTwR1leOWbVs0CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAqVfvOc6XFdZ6Fll5iZhhpv8qYarr232jN6BT2JPShtmzCpdUEvekhQ8auDJalKg8Ofk5kQ4AmoIXKPxNIk65fISCl1HIuGHyUiGuqSF0XIGs8pfA0SDuUo7pS/kCC0lToMrf//uwG48bPwUkDHDG/voM9+HG0C66bKAcsIZyLwhw47Lhrgnurgs7EivfEHVPz2wAmt/nD21YW0nx2O2RZorkrfdJNKMv/scV7dYDFZ07272Mo2OalfZNl5HyFuWFrPfoOY/xciGsxPFDbIFMPCdcNzjLpKYCypCFQLpKuWuUq5d/SWXChvIB9dhVyqDJ+Gh+DwzsGREME6YJ6BkGKw==" mi="MFS100" rdsId="MANTRA.AND.001" rdsVer="1.0.4">
//       <additional_info>
//          <Param name="srno" value="4136139"/>
//          <Param name="sysid" value="c534219aff741473"/>
//          <Param name="ts" value="2021-09-01T11:25:29+05:30"/>
//       </additional_info>
//    </DeviceInfo>
//    <Hmac>cIS5OI6pB5yEjaAHLaVX0KCpfwhZn/wZ5uNr1KmzRzQ5kJW88U565HAhtUXUZBqq</Hmac>
//    <Resp errCode="0" errInfo="Capture Success" fCount="1" fType="0" iCount="0" iType="0" nmPoints="34" pCount="0" pType="0" qScore="100"/>
//    <Skey ci="20200916">
// YNjHcW3ySpbE+sJfjVNpl4nH7SqrTk0TzamrWXuSGoJHBhdmYVdzB3hWgXovrzzchQHbkiw1dLnnVvin/agrCZP5cUzEkO42dBvrfQxrQGpIUntrKCi5CAGoRy7W8zxZXLb1iMFaLGjlbPG9cEK9lrHhZUWZNvRbutyKWvgLDUm4p7JZsbuW8FiH+aSHPJh11un3zpHsU8/oI7+4HYtNwotJTdS2d/DOcAdHoACtYS8/LbePjj9geDrH/bx+swVErUGOSx8/aYNl1es8YI3wHsn6VX66FEgNwy0CHk/ECzbAYEwB3M3/lk1lFI4r9+6Ugf9txkuAmQVxAS+gbAHZ/g==
// </Skey>
// </PidData>

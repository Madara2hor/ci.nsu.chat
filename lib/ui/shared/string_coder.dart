import 'dart:convert';

class StringCoder {
  static final Codec<String, String> stringToBase64 = utf8.fuse(base64);
  static final String key = "s0m3s3cr31k3y";

  static encodeMessage(String decodedMessage) {
    return stringToBase64.encode(key + decodedMessage + key);
  }

  static decodeMessage(String encodedMessage) {
    var encodedString = stringToBase64.decode(encodedMessage);
    return encodedString.replaceAll(key, "");
  }
}

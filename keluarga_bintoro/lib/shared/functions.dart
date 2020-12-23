import 'dart:convert';

import 'package:http/http.dart';

Future<String> networkImageToBase64(String imageUrl) async {
  Response response = await get(imageUrl);
  final bytes = response?.bodyBytes;
  return (bytes != null ? base64Encode(bytes) : null);
}

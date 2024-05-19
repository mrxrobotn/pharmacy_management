import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:developer' as devtools show log;

Future<bool> sendNotificationMessage({
  required String recipientToken,
  required String title,
  required String body,
}) async {
  // Link the firebase project with the REST api server
  final jsonCredentials =
  await rootBundle.loadString('assets/data/pharmacy-mangement-211cc2b2b925.json');
  final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  final client = await auth.clientViaServiceAccount(
    creds,
    ['https://www.googleapis.com/auth/cloud-platform'],
  );

  // Send a POST request to the client using his Token
  const String senderId = '273289006400';
  final response = await client.post(
    Uri.parse('https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
    headers: {
      'content-type': 'application/json',
    },
    body: jsonEncode({
      'message': {
        'token': recipientToken,
        'notification': {'title': title, 'body': body}
      },
    }),
  );

  client.close();
  if (response.statusCode == 200) {
    return true; // Success!
  }

  devtools.log(
      'Notification Sending Error Response status: ${response.statusCode}');
  devtools.log('Notification Response body: ${response.body}');
  return false;
}
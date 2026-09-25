import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class SendBrevoMailCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? password = '',
    int? id,
    String? apiKey,
  }) async {
    apiKey ??= FFDevEnvironmentValues().brevoKey;

    final ffApiRequestBody = '''
{
  "sender": {
    "name": "GCA",
    "email": "jeremy.davies@golfclubadvisor.co.uk"
  },
  "to": [
    {
      "email": "${escapeStringForJson(email)}"
    }
  ],
  "templateId": ${id},
  "params": {
"email": "${escapeStringForJson(email)}",
    "password": "${escapeStringForJson(password)}"

  },
  "htmlContent": "<html><head></head><body><p>Hello,</p>This is my first transactional email sent from Brevo.</p></body></html>"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'sendBrevoMail',
      apiUrl: 'https://api.brevo.com/v3/smtp/email',
      callType: ApiCallType.POST,
      headers: {
        'api-key': '${apiKey}',
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SupportMailCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    int? id,
    String? apiKey,
    String? name = '',
    String? subject = '',
    String? description = '',
  }) async {
    apiKey ??= FFDevEnvironmentValues().brevoKey;

    final ffApiRequestBody = '''
{
  "sender": {
    "name": "GCA",
    "email": "jeremy.davies@golfclubadvisor.co.uk"
  },
  "to": [
    {
      "email": "jeremy.davies@golfclubadvisor.co.uk"
    }
  ],
  "templateId": ${id},
  "params": {
"email": "${escapeStringForJson(email)}",
"name": "${escapeStringForJson(name)}",
"subject": "${escapeStringForJson(subject)}",
"description": "${escapeStringForJson(description)}"
   
  },
  "htmlContent": "<html><head></head><body><p>Hello,</p>This is my first transactional email sent from Brevo.</p></body></html>"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'supportMail',
      apiUrl: 'https://api.brevo.com/v3/smtp/email',
      callType: ApiCallType.POST,
      headers: {
        'api-key': '${apiKey}',
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateSubAdminCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? password = '',
    String? firstName = '',
    String? lastName = '',
    String? key,
  }) async {
    key ??= FFDevEnvironmentValues().supabaseToken;

    final ffApiRequestBody = '''
{
    "email": "${escapeStringForJson(email)}",
    "password": "${escapeStringForJson(password)}",
    "first_name": "${escapeStringForJson(firstName)}",
    "last_name": "${escapeStringForJson(lastName)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createSubAdmin',
      apiUrl:
          'https://pxzryjbzwioeuajlerze.supabase.co/functions/v1/createSubAdmin',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${key}',
        'apiKey': 'sb_publishable_Vt-gCmOJr9e8GCiXxJPY2Q_YwpV3yDG',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdatePasswordCall {
  static Future<ApiCallResponse> call({
    String? currentPass = '',
    String? newPass = '',
    String? accessToken = '',
    String? key,
  }) async {
    key ??= FFDevEnvironmentValues().supabaseKey;

    final ffApiRequestBody = '''
{ "currentPassword": "${escapeStringForJson(currentPass)}", "newPassword": "${escapeStringForJson(newPass)}" }''';
    return ApiManager.instance.makeApiCall(
      callName: 'updatePassword',
      apiUrl:
          'https://pxzryjbzwioeuajlerze.supabase.co/functions/v1/update-password',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${key}',
        'apikey': 'sb_publishable_Vt-gCmOJr9e8GCiXxJPY2Q_YwpV3yDG',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? error(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.error''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}

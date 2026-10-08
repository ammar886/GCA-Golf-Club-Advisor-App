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
      "email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'}
    }
  ],
  "templateId": ${id},
  "params": {
"email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'},
    "password": ${password == null ? 'null' : '"${escapeStringForJson(password)}"'}

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
"email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'},
"name": ${name == null ? 'null' : '"${escapeStringForJson(name)}"'},
"subject": ${subject == null ? 'null' : '"${escapeStringForJson(subject)}"'},
"description": ${description == null ? 'null' : '"${escapeStringForJson(description)}"'}
   
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
    "email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'},
    "password": ${password == null ? 'null' : '"${escapeStringForJson(password)}"'},
    "first_name": ${firstName == null ? 'null' : '"${escapeStringForJson(firstName)}"'},
    "last_name": ${lastName == null ? 'null' : '"${escapeStringForJson(lastName)}"'}
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
{ "currentPassword": ${currentPass == null ? 'null' : '"${escapeStringForJson(currentPass)}"'}, "newPassword": ${newPass == null ? 'null' : '"${escapeStringForJson(newPass)}"'} }''';
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

class FetchGolfNewsCall {
  static Future<ApiCallResponse> call({
    String? key,
  }) async {
    key ??= FFDevEnvironmentValues().supabaseKey;

    return ApiManager.instance.makeApiCall(
      callName: 'fetchGolfNews',
      apiUrl:
          'https://pxzryjbzwioeuajlerze.supabase.co/functions/v1/fetch-rss-feed',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${key}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic articles(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  static List<String>? articleId(dynamic response) => (getJsonField(
        response,
        r'''$.articles[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? articleTitle(dynamic response) => (getJsonField(
        response,
        r'''$.articles[:].title''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? articleDescription(dynamic response) => (getJsonField(
        response,
        r'''$.articles[:].description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? articleUrl(dynamic response) => (getJsonField(
        response,
        r'''$.articles[:].url''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? articlePublishedAt(dynamic response) => (getJsonField(
        response,
        r'''$.articles[:].publishedAt''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? articleImage(dynamic response) => (getJsonField(
        response,
        r'''$.articles[:].imageUrl''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
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
  final encoded = jsonEncode(input);
  return encoded.substring(1, encoded.length - 1);
}

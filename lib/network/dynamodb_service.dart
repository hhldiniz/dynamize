import 'dart:convert';

import 'package:dynamize/config.dart';
import 'package:http/http.dart';

import '../model/attribute_definition.dart';

class DynamoDBService {
  Future<String> describeTableRequest(String tableName) async {
    var headers = {
      'X-Amz-Target': 'DynamoDB_20120810.DescribeTable',
      'Content-Type': 'application/x-amz-json-1.0'
    };
    var request = Request('POST',
        Uri.parse('${Configuration.awsEndpoint}/?Action=DescribeTable'));
    request.body = '''{\n   "TableName": "$tableName"\n}''';
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase ?? "Unknown reason";
    }
  }

  Future createTableRequest(
      String name, List<AttributeDefinition> attributeDefinitions) async {
    var headers = {
      'X-Amz-Target': 'DynamoDB_20120810.CreateTable',
      'Content-Type': 'application/x-amz-json-1.0'
    };
    var request = Request(
        'POST', Uri.parse('${Configuration.awsEndpoint}/?Action=CreateTable'));
    var params = {"AttributeDefinitions": []};
    for (var element in attributeDefinitions) {
      params["AttributeDefinitions"]?.add({
        "AttributeName": element.attributeName,
        "AttributeType": element.attributeType
      });
    }
    request.body = jsonEncode(params);
    request.body =
        '''{\n    "AttributeDefinitions": [\n        {\n            "AttributeName": "ForumName",\n            "AttributeType": "S"\n        },\n        {\n            "AttributeName": "Subject",\n            "AttributeType": "S"\n        },\n        {\n            "AttributeName": "LastPostDateTime",\n            "AttributeType": "S"\n        }\n    ],\n    "TableName": "Thread",\n    "KeySchema": [\n        {\n            "AttributeName": "ForumName",\n            "KeyType": "HASH"\n        },\n        {\n            "AttributeName": "Subject",\n            "KeyType": "RANGE"\n        }\n    ],\n    "LocalSecondaryIndexes": [\n        {\n            "IndexName": "LastPostIndex",\n            "KeySchema": [\n                {\n                    "AttributeName": "ForumName",\n                    "KeyType": "HASH"\n                },\n                {\n                    "AttributeName": "LastPostDateTime",\n                    "KeyType": "RANGE"\n                }\n            ],\n            "Projection": {\n                "ProjectionType": "KEYS_ONLY"\n            }\n        }\n    ],\n    "ProvisionedThroughput": {\n        "ReadCapacityUnits": 5,\n        "WriteCapacityUnits": 5\n    },\n    "Tags": [ \n      { \n         "Key": "Owner",\n         "Value": "BlueTeam"\n      }\n   ]\n}''';
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }
}

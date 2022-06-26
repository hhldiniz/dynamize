import 'dart:convert';

import 'package:dynamize/config.dart';
import 'package:dynamize/model/global_secondary_index.dart';
import 'package:dynamize/model/tag.dart';
import 'package:http/http.dart';

import '../model/attribute_definition.dart';
import '../model/key_schema.dart';
import '../model/provisioned_throughput.dart';

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
      String name,
      List<AttributeDefinition> attributeDefinitions,
      List<KeySchema> keySchema,
      ProvisionedThroughput provisionedThroughput,
      {List<GlobalSecondaryIndex>? globalSecondaryIndexes,
      List<Tag>? tags}) async {
    var headers = {
      'X-Amz-Target': 'DynamoDB_20120810.CreateTable',
      'Content-Type': 'application/x-amz-json-1.0'
    };
    var request = Request(
        'POST', Uri.parse('${Configuration.awsEndpoint}/?Action=CreateTable'));
    var params = {
      "TableName": name,
      "AttributeDefinitions": [],
      "KeySchema": [],
      "ProvisionedThroughput": {}
    };

    for (var element in attributeDefinitions) {
      (params["AttributeDefinitions"] as List<Object>).add({
        "AttributeName": element.attributeName,
        "AttributeType": element.attributeType
      });
    }

    for (var element in keySchema) {
      (params["KeySchema"] as List<Object>).add(
          {"AttributeName": element.attributeName, "KeyType": element.keyType});
    }

    (params["ProvisionedThroughput"] as Map<String, int>)["ReadCapacityUnits"] =
        provisionedThroughput.readCapacityUnits;

    (params["ProvisionedThroughput"]
            as Map<String, int>)["WriteCapacityUnits"] =
        provisionedThroughput.writeCapacityUnits;

    if (provisionedThroughput.numberOfDecreasesToday != null) {
      (params["ProvisionedThroughput"]
              as Map<String, int>)["NumberOfDecreasesToday"] =
          provisionedThroughput.numberOfDecreasesToday ?? 0;
    }

    if (globalSecondaryIndexes != null) {
      params["GlobalSecondaryIndex"] =
          globalSecondaryIndexes.map((GlobalSecondaryIndex gsi) => {
                "IndexName": gsi.indexName,
                "KeySchema": gsi.keySchema.map((key) => {
                      "AttributeName": key.attributeName,
                      "KeyType": key.keyType
                    }),
                "ProjectionType": gsi.projection.projectionType
              });
    }

    if (tags != null) {
      params["Tags"] = tags.map((tag) => {"Key": tag.key, "Value": tag.value});
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

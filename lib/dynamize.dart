library dynamize;

import 'dart:convert';

import 'package:dynamize/model/attribute_definition.dart';
import 'package:dynamize/model/key_schema.dart';
import 'package:dynamize/model/provisioned_throughput.dart';
import 'package:dynamize/model/table_description.dart';
import 'package:dynamize/network/dynamodb_service.dart';

/// A class that represents a DynamoDB table and it's operations.
class Table {
  String name;

  final DynamoDBService _dynamoDbService = DynamoDBService();

  Table(this.name);

  // Future create() {
  //
  // }

  Future<TableDescription> describe() async {
    var jsonResponse =
        jsonDecode(await _dynamoDbService.describeTableRequest(name));

    return TableDescription(
        jsonResponse["AttributeDefinitions"].map((attributeDefinition) =>
            AttributeDefinition(attributeDefinition["AttributeName"],
                attributeDefinition["AttributeType"])).toList(),
        ProvisionedThroughput(
            jsonResponse["ProvisionedThroughput"]["NumberOfDecreasesToday"],
            jsonResponse["ProvisionedThroughput"]["WriteCapacityUnits"],
            jsonResponse["ProvisionedThroughput"]["ReadCapacityUnits"]),
        jsonResponse["TableSizeBytes"],
        jsonResponse["TableName"],
        jsonResponse["TableStatus"],
        jsonResponse["KeySchema"].map((keySchema) =>
            KeySchema(keySchema["KeyType"], keySchema["AttributeName"])).toList(),
        jsonResponse["ItemCount"],
        jsonResponse["CreationDateTime"]);
  }
}

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

  Future create() async {
    var jsonResponse =
        jsonDecode(await _dynamoDbService.createTableRequest(name));
  }

  Future<TableDescription> describe() async {
    var jsonResponse =
        jsonDecode(await _dynamoDbService.describeTableRequest(name));

    List<AttributeDefinition> attributeDefinitions = [];
    List<KeySchema> keySchemas = [];

    jsonResponse["Table"]["AttributeDefinitions"].forEach((val) {
      attributeDefinitions
          .add(AttributeDefinition(val["AttributeName"], val["AttributeType"]));
    });

    jsonResponse["Table"]["KeySchema"].forEach((val) =>
        keySchemas.add(KeySchema(val["KeyType"], val["AttributeName"])));

    return TableDescription(
        attributeDefinitions,
        ProvisionedThroughput(
            jsonResponse["Table"]["ProvisionedThroughput"]
                ["NumberOfDecreasesToday"],
            jsonResponse["Table"]["ProvisionedThroughput"]
                ["WriteCapacityUnits"],
            jsonResponse["Table"]["ProvisionedThroughput"]
                ["ReadCapacityUnits"]),
        jsonResponse["Table"]["TableSizeBytes"],
        jsonResponse["Table"]["TableName"],
        jsonResponse["Table"]["TableStatus"],
        keySchemas,
        jsonResponse["Table"]["ItemCount"],
        jsonResponse["Table"]["CreationDateTime"]);
  }
}

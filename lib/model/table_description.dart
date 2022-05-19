import 'package:dynamize/model/provisioned_throughput.dart';

import 'attribute_definition.dart';
import 'key_schema.dart';

class TableDescription {
  List<AttributeDefinition> attributeDefinitions;
  ProvisionedThroughput provisionedThroughput;
  int tableSizeBytes;
  String tableName;
  String tableStatus;
  List<KeySchema> keySchema;
  int itemCount;
  double creationDateTime;

  TableDescription(
      this.attributeDefinitions,
      this.provisionedThroughput,
      this.tableSizeBytes,
      this.tableName,
      this.tableStatus,
      this.keySchema,
      this.itemCount,
      this.creationDateTime);
}

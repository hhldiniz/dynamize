import 'package:dynamize/model/projection.dart';
import 'package:dynamize/model/provisioned_throughput.dart';

import 'key_schema.dart';

class GlobalSecondaryIndex {
  String indexName;
  List<KeySchema> keySchema;
  Projection projection;
  ProvisionedThroughput provisionedThroughput;

  GlobalSecondaryIndex(this.indexName, this.keySchema, this.projection,
      this.provisionedThroughput);
}

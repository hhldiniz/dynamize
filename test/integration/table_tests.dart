import 'package:flutter_test/flutter_test.dart';

import 'package:dynamize/dynamize.dart';

void main() {
  test('describe table', () async {
    var table = Table("test");
    var tableDescription = await table.describe();
    expect(tableDescription.tableName, "test");
  });
}

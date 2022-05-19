import 'package:dynamize/config.dart';
import 'package:http/http.dart';

class DynamoDBService {
  Future describeTableRequest(String tableName) async{
    var headers = {
      'X-Amz-Target': 'DynamoDB_20120810.DescribeLimits',
      'Content-Type': 'application/x-amz-json-1.0'
    };
    var request = Request(
        'POST', Uri.parse('${Configuration.awsEndpoint}/?Action=DescribeTable'));
    request.body = '''{\n   "TableName": "$tableName"\n}''';
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }
}

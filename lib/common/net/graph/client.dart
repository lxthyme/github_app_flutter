import 'package:graphql/client.dart';
import 'package:gsy_app/common/net/graph/repositories.dart';
import 'package:gsy_app/common/net/graph/users.dart';
import 'package:gsy_app/common/utils/common_utils.dart';

Future<GraphQLClient> _client(token) async {
  final HttpLink _httpLink = HttpLink('https://api.github.com/graphql');

  final AuthLink _authLink = AuthLink(
    getToken: () => '$token',
  );

  final Link _link = _authLink.concat(_httpLink);
  var path = await CommonUtils.getApplicationDocumentsPath();
  final store = await HiveStore.open(path: path);
  return GraphQLClient(
    link: _link,
    cache: GraphQLCache(store: store),
  );
}

GraphQLClient? _innerClient;

initClient(token) async {
  _innerClient ??= await _client(token);
}

releaseClient() {
  _innerClient = null;
}

Future<QueryResult>? getRepository(String owner, String? name) async {
  final QueryOptions _options = QueryOptions(
    document: gql(readRepository),
    variables: <String, dynamic>{
      'owner': owner,
      'name': name,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  return await _innerClient!.query(_options);
}

Future<QueryResult>? getTrendUser(String location, {String? cursor}) async {
  var variable = cursor == null
      ? <String, dynamic>{
          'location': 'location:$location sort:followers',
        }
      : <String, dynamic>{
          'location': 'location:$location sort:followers',
          'after': cursor,
        };
  final QueryOptions _options = QueryOptions(
    document: gql(cursor == null ? readTrendUser : readTrendUserByCursor),
    variables: variable,
    fetchPolicy: FetchPolicy.noCache,
  );
  return await _innerClient!.query(_options);
}

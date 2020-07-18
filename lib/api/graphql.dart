import 'dart:developer';

import 'package:graphql/client.dart';

import '../config.dart';

class GraphQLUtility {
  String _idToken;
  final httpLink = HttpLink(uri: "${CONFIG.URI}/graphql");

  GraphQLClient client;

  Link _createLink(String idToken) {
    final authLink = AuthLink(getToken: () => "Bearer $idToken");
    return authLink.concat(httpLink);
  }

  // updates the id token and generates a new client
  updateIdToken (String idToken) {
    _idToken = idToken;

    client = GraphQLClient(
      cache: InMemoryCache(),
      link: _createLink(_idToken),
    );
  }

  /// makes a request for a full page
  Future<T> makePageRequest<T> (
    String document,
    T Function(Map<String, dynamic> json) fromJson
  ) async {
    final node = gql(document);
    final options = QueryOptions(documentNode: node);

    final result = await client.query(options);
    if (result.hasException) {
      log("error ${result.exception}");
      return null;
    }

    return fromJson(result.data);
  }
}

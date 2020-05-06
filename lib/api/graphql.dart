import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import '../auth_manager.dart';
import '../config.dart';

class GraphQLUtility {
  String graphQLEndpoint;
  AuthManager authManager;

  HttpLink httpLink;
  GraphQLClient client;

  GraphQLUtility({
    @required this.authManager
  }) {
    httpLink = HttpLink(uri: "${CONFIG.URI}/graphql");

    // subscribe to changes to current user and update client
    authManager.currentAccount.listen((account) {
      client = GraphQLClient(
        cache: InMemoryCache(),
        link: _createLink(account.credentials.idToken.toString()),
      );
    });
  }

  Link _createLink(String idToken) {
    final authLink = AuthLink(getToken: () => "Bearer $idToken");
    return authLink.concat(httpLink);
  }

  /// creates a temporary graphql client for creating a new user account because the actual client
  /// isn't initialized until the account is ready
  GraphQLClient temporaryClient(String idToken) {
    return GraphQLClient(
      cache: InMemoryCache(),
      link: _createLink(idToken),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../auth_manager.dart';
import '../config.dart';

class GraphQLUtility {
  String graphQLEndpoint;
  AuthManager authManager;

  HttpLink httpLink;
  AuthLink authLink;
  Link link;

  GraphQLClient client;

  GraphQLUtility({
    @required this.authManager
  }) {
    httpLink = HttpLink(uri: "${CONFIG.URI}/graphql");

    // subscribe to changes to current user and update client
    authManager.currentAccount.listen((account) {
      authLink = AuthLink(getToken: () async => account.credentials.idToken.toString());
      link = authLink.concat(httpLink);
      client = GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink,
      );
    });

  }
}
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../auth_manager.dart';

class GraphQLUtility {
  AuthManager authManager;

  HttpLink httpLink = HttpLink(uri: "stronk.com");
  AuthLink authLink;
  Link link;

  GraphQLClient client;

  GraphQLUtility({
    @required this.authManager
  }) {
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
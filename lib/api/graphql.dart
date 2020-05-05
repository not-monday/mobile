import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLUtility {
  //  AuthManager =
//  final authLink = AuthLink(getToken: () async => )


//  GraphQLUtility({
//    @required this.authManager
//  });

  final httpLink = HttpLink(uri: "stronk.com");
  GraphQLClient client;

  GraphQLUtility() {
    client = GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
  }


}
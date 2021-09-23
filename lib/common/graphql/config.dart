import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

mixin Config {
  static ValueNotifier<GraphQLClient> initializeClient(String _token) {
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: HttpLink('https://just-run-f.herokuapp.com/v1/graphql',
            defaultHeaders: {
              'Authorization': 'Bearer $_token',
            }),
      ),
    );
    return client;
  }
}

import 'package:flutter/material.dart';
import 'package:news_app/src/screens/news_details.dart';
import 'blocs/comments_provider.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: "News!",
          //home: NewsList(),
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = StoriesProvider.of(context);
          bloc.fetchTopIds();
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = CommentsProvider.of(context);
          final id = int.parse(settings.name.replaceFirst("/", ""));
          bloc.fetchitemsWithComments(id);
          return NewsDetails(
            itemId: id,
          );
        },
      );
    }
  }
}

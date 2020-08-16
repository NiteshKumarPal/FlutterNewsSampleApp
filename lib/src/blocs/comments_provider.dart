import 'package:flutter/material.dart';
import 'package:news_app/src/blocs/comments_bloc.dart';

class CommentsProvider extends InheritedWidget {
  final CommentsBloc bloc;

  CommentsProvider({Key key, Widget child})
      : bloc = CommentsBloc(),
        super(key: key, child: child);

  static CommentsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommentsProvider>().bloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:news_app/src/blocs/stories_provider.dart';
import 'package:news_app/src/widgets/news_list_tile.dart';
import 'package:news_app/src/widgets/refresh.dart';

import '../blocs/stories_bloc.dart';
import '../blocs/stories_provider.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    // bloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(title: Text('News!')),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Refresh(
          child: ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, int index) {
                bloc.fetchItem(snapshot.data[index]);

                return NewsListTile(
                  itemId: snapshot.data[index],
                );
              }),
        );
      },
    );
  }
}

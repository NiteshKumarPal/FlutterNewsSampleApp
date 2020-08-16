import 'package:flutter/material.dart';
import 'package:news_app/src/blocs/comments_bloc.dart';
import 'package:news_app/src/blocs/comments_provider.dart';
import 'package:news_app/src/models/ItemModel.dart';
import 'package:news_app/src/widgets/comment.dart';

class NewsDetails extends StatelessWidget {
  final int itemId;

  NewsDetails({@required this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Story detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemsWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading');
        }

        final itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapShot) {
            if (!itemSnapShot.hasData) {
              return Text('Loading');
            }

            return buildList(itemSnapShot.data,
                snapshot.data); //buildTitle(itemSnapShot.data);
          },
        );
      },
    );
  }

  Widget buildTitle(ItemModel data) {
    return Container(
      margin: EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      child: Text(
        data?.title ?? "no data",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> snapshot) {
    final children = <Widget>[];
    children.add(buildTitle(item));

    final commentList = item.kids?.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: snapshot,
        depth: 1,
      );
    })?.toList();

    if (commentList != null) {
      children.addAll(commentList);
    }

    return ListView(
      children: children,
    );
  }
}

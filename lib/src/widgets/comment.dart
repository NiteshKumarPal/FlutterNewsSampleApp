import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_app/src/models/ItemModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loading_container.dart';


class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment(
      {@required this.itemId, @required this.itemMap, @required this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final item = snapshot.data;
        var children = <Widget>[
          ListTile(
            title: Html(
              data: item.text,
              onLinkTap: _launchURL,
            ),
            subtitle: item.by.isEmpty ? Text('Deleted') : Text(item.by),
            contentPadding: EdgeInsets.only(
              right: 16,
              left: depth * 16.0,
            ),
          ),
          Divider(),
        ];

        item.kids.forEach((kidId) {
          children.add(
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );
        });

        return Column(
          children: children,
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

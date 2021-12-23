import 'package:feshta/providers/artist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistsFavoriteWidget extends StatelessWidget {
  const ArtistsFavoriteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final artists = Provider.of<ArtistProvider>(context, listen: false)
        .artists
        .where((element) => element.isFavorite == true)
        .toList();
    return artists.isEmpty
        ? const Center(
            child: Text('No Favorite Artists'),
          )
        : Consumer<ArtistProvider>(
            builder: (context, artistProvider, _) => ListView.builder(
              shrinkWrap: true,
              itemCount: artists.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(artists[index].image))),
                  ),
                  title: Text(artists[index].name),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite,
                          size: 25, color: Colors.red)),
                );
              },
            ),
          );
  }
}

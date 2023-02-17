import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tv_app/helpers/networking.dart';
import 'package:tv_app/pages/show_page.dart';

class FilteredMovies extends StatelessWidget {
  const FilteredMovies({required this.results, super.key});
  final List<dynamic> results;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppbar(count: results.length),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) => MovieCard(
                data: results[index],
                key: ValueKey(results[index]['show']['id']),
              ),
              itemCount: results.length,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              // controller: ScrollController(initialScrollOffset: -200),
            ))
          ],
        ),
      ),
    );
  }
}

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    required this.count,
    Key? key,
  }) : super(key: key);
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(
              'Results',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '$count Found',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  final dynamic data;
  const MovieCard({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () async {
        var futures = <Future>[];
        List<dynamic> response;
        try {
          futures.add(NetworkHelper().getData1(
              url: data["show"]["_links"]["previousepisode"]["href"]));
          futures.add(NetworkHelper().getData1(
              url:
                  "${data["show"]["_links"]["self"]["href"]}?embed[]=crew&embed[]=cast&embed[]=episodes"));
          response = await Future.wait(futures);
        } on Exception catch (e) {
          return;
        }
        List<dynamic> result = [];
        result.add(jsonDecode(response[0].body));
        result.add(jsonDecode(response[1].body));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowPage(data: result),
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: data['show']["image"]['original'] as String,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    SizedBox(
                  height: 220,
                  width: 150,
                  child: Center(
                    child: LoadingAnimationWidget.flickr(
                        leftDotColor: Colors.white,
                        rightDotColor: Colors.amber,
                        size: 40),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return SizedBox(
                    height: 220,
                    width: 150,
                  );
                },
                height: 220,
                width: 150,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['show']['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    formatGenres(data['show']['genres'] as List<dynamic>),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      DisplayChip(
                          child: Text(
                        data['show']['premiered'] == null
                            ? "-"
                            : (data['show']['premiered'])
                                .toString()
                                .substring(0, 4),
                        style: Theme.of(context).textTheme.titleSmall,
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      DisplayChip(
                          child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            data['show']['rating']['average'] == null
                                ? "-"
                                : (data['show']['rating']['average'])
                                    .toString(),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      DisplayChip(
                          child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_sharp,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            data['show']['averageRuntime'] == null
                                ? "- minutes"
                                : "${data['show']['averageRuntime']} minutes",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DisplayChip extends StatelessWidget {
  final Widget child;
  const DisplayChip({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(23)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: child,
      ),
    );
  }
}

String formatGenres(List<dynamic> genres) {
  String ans = '';
  if (genres.isEmpty) return ans;
  for (String tag in genres) {
    ans += " $tag ⋅ ";
  }
  ans = ans.substring(0, ans.length - 2);
  return ans;
}

String formatDuration(String duration) {
  String ans = '';
  ans += "${duration[1]}h ${duration.substring(3, 5)}m";
  return ans;
}

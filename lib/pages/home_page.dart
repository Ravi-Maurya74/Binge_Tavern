import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tv_app/helpers/networking.dart';
import 'package:tv_app/pages/show_page.dart';
import 'package:tv_app/providers.dart/loading.dart';
import 'package:tv_app/widgets/custom_text_field.dart';
import 'package:tv_app/widgets/faded_image.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Loader>(context, listen: false).data;
    final centerData = data[0];
    final rowShows = data[1];
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // IconButton(
                  //     onPressed: () {
                  //       _scaffoldKey.currentState!.openDrawer();
                  //     },
                  //     icon: const Icon(Icons.menu)),
                  // // SizedBox(
                  // //   width: 20,
                  // // ),
                  Expanded(
                      child: CustomTextField(
                    label: 'Search',
                  )),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  // Icon(Icons.video_camera_back_sharp)
                ],
              ),
            ),
            CenterImage(data: centerData),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: RowMovieWidget(
                data: rowShows,
                title: "This week's affair",
              ),
              // child: Column(
              //   children: [
              //     SelectorChips(genres: genres!),
              //     const SizedBox(
              //       height: 20,
              //     ),
              //     RowMovieWidget(data: mostUpvoted!, title: 'Most Upvoted'),
              //     RowMovieWidget(title: 'Top Rated', data: topRated)
              //   ],
              // ),
            ),
          ],
        ),
      )),
    );
  }
}

class RowMovieWidget extends StatelessWidget {
  final List<dynamic> data;
  final String title;
  const RowMovieWidget({required this.title, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => SingleRowMovie(
              e: data[index],
              key: ValueKey(data[index]['id']),
            ),
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            prototypeItem: SingleRowMovie(e: data[0]),
            cacheExtent: 2000,
          ),
        ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   physics: const BouncingScrollPhysics(),
        //   child: Row(
        //     children: data.map((e) => SingleRowMovie(e: e,)).toList(),
        //   ),
        // ),
      ],
    );
  }
}

class SingleRowMovie extends StatelessWidget {
  const SingleRowMovie({
    required this.e,
    Key? key,
  }) : super(key: key);
  final dynamic e;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: null,
      // onTap: () async {
      //   Response movieData = await NetworkHelper().postData(
      //       url: 'movieDetails/',
      //       jsonMap: {
      //         "movie_id": e['id'],
      //         "user_id": Provider.of<User>(context, listen: false).id
      //       });
      //   Navigator.pushNamed(context, MoviePage.routeName,
      //       arguments: jsonDecode(utf8.decode(movieData.bodyBytes)));
      // },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            // margin: const EdgeInsets.symmetric(
            //     horizontal: 10, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: e['_embedded']['show']["image"]['original'] as String,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: SizedBox(
                  height: 300,
                  width: 200,
                  child: LoadingAnimationWidget.flickr(
                      leftDotColor: Colors.white,
                      rightDotColor: Colors.amber,
                      size: 60),
                ),
              ),
              errorWidget: (context, url, error) {
                return const SizedBox(
                  height: 300,
                  width: 200,
                );
              },
              height: 300,
              width: 200,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

class CenterImage extends StatefulWidget {
  const CenterImage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<dynamic> data;

  @override
  State<CenterImage> createState() => _CenterImageState();
}

class _CenterImageState extends State<CenterImage> {
  late Timer _timer;
  int index = 0;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        setState(() {
          index = (index + 1) % widget.data.length;
        });
        // int nextIndex = (index + 1) % widget.data.length;
        // Image image = Image(
        //   image: CachedNetworkImageProvider(
        //       widget.data[nextIndex]['imageUrl'] as String),
        //   fit: BoxFit.cover,
        // );
        // precacheImage(image.image, context);
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = 1; i < widget.data.length; i++) {
      Image image = Image(
        image: CachedNetworkImageProvider(
            widget.data[i]['image']['original'] as String),
        fit: BoxFit.cover,
      );
      precacheImage(image.image, context);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Response movieData =
        //     await NetworkHelper().postData(url: 'movieDetails/', jsonMap: {
        //   "movie_id": widget.data[index]['id'],
        //   "user_id": Provider.of<User>(context, listen: false).id
        // });
        Response prevEpisode = await NetworkHelper().getData1(
            url: (widget.data[index]['_links']["previousepisode"]['href'])
                .toString());
        List<dynamic> result = [];
        result.add(jsonDecode(prevEpisode.body));
        result.add(widget.data[index]);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowPage(data: result),
            ));
      },
      child: Stack(
        children: [
          FadedImage2(
            height: 600,
            url: widget.data[index]['image']['original'] as String,
            fadeHeight: 200,
          ),
          SizedBox(
            height: 600,
            child: Column(children: [
              const Spacer(),
              Container(
                child: Center(
                  child: Text(
                    formatGenres(
                      widget.data[index]['genres'],
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          )
        ],
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

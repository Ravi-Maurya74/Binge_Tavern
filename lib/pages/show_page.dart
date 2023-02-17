import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tv_app/widgets/expand_widget.dart';
import 'package:tv_app/widgets/faded_image.dart';
import 'package:tv_app/widgets/fade_on_scroll.dart';
import 'package:html/parser.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';

class ShowPage extends StatelessWidget {
  ShowPage({required this.data, super.key});
  final ScrollController scrollController = ScrollController();
  final List<dynamic> data;
  void scrollToBottom() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                FadedImage(
                  url: data[0]['image'] == null
                      ? 'https://i.postimg.cc/8PnfPjpy/Untitled-design.png'
                      : data[0]['image']['original'] as String,
                  height: 300,
                  fadeHeight: 100,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: FadeOnScroll(
                    scrollController: scrollController,
                    child: Container(
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 5,
                            offset: Offset(5, 5)),
                        // BoxShadow(
                        //     color: Colors.black38,
                        //     blurRadius: 5,
                        //     offset: Offset(5, -5)),
                      ]),
                      child: Text(
                        data[1]['name'] as String,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            (data[1]['rating']['average'] == null
                                ? '-'
                                : (data[1]['rating']['average']).toString()),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   '  |  ${(data['number_of_reviews'] as int).toString()}',
                          //   style: Theme.of(context).textTheme.bodySmall,
                          // ),
                          // const Spacer(),
                          // const LikeBookmarkWidget(),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Hero(
                        tag: data[1]['id'],
                        child: Text(
                          data[1]['name'] as String,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${data[1]['averageRuntime']} minutes | ${formatGenres((data[1]['genres']) as List<dynamic>)} | ${(data[1]['premiered'] as String).substring(0, 4)} | ${(data[1]['status'] as String)}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        data[1]['summary'] == null
                            ? "We're still updating this. Stay tuned."
                            : parseHtmlString(data[1]['summary'] as String),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      // Text(
                      //   'Top Cast',
                      //   style: Theme.of(context).textTheme.titleMedium,
                      // ),
                      // const SizedBox(
                      //   height: 12,
                      // ),
                      ActorsListRow(
                        cast: data[1]['_embedded']['cast'],
                        label: "Top Cast",
                        isCast: true,
                      ),
                      ActorsListRow(
                          cast: data[1]['_embedded']['crew'],
                          label: "Crew",
                          isCast: false),
                      // const SizedBox(
                      //   height: 12,
                      // ),
                      // Text(
                      //   'Director',
                      //   style: Theme.of(context).textTheme.titleMedium,
                      // ),
                      // const SizedBox(
                      //   height: 12,
                      // ),
                      // ActorsListRow(
                      //   isDirector: true,
                      //   movieId: data['id'],
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //         child: Padding(
                      //       padding: const EdgeInsets.all(8),
                      //       child: ElevatedButton(
                      //         child: const Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 15),
                      //           child: Text('Trailer'),
                      //         ),
                      //         onPressed: () {
                      //           launchUrl(
                      //               Uri.parse(data["trailer_url"] as String),
                      //               mode: LaunchMode
                      //                   .externalNonBrowserApplication);
                      //         },
                      //       ),
                      //     )),
                      //     Expanded(
                      //         child: Padding(
                      //       padding: const EdgeInsets.all(8),
                      //       child: ElevatedButton(
                      //         child: const Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 15),
                      //           child: Text('Reviews'),
                      //         ),
                      //         onPressed: () async {
                      //           var reviewData = await NetworkHelper()
                      //               .postData(url: 'movieReviews/', jsonMap: {
                      //             "movie_id": data['id'],
                      //             "user_id":
                      //                 Provider.of<User>(context, listen: false)
                      //                     .id
                      //           });
                      //           // print(jsonDecode(review_data.body));
                      //           Provider.of<User>(context, listen: false)
                      //               .currentMovieid = data['id'];
                      //           Navigator.pushNamed(
                      //               context, ReviewPage.routeName,
                      //               arguments: jsonDecode(
                      //                   utf8.decode(reviewData.bodyBytes)));
                      //         },
                      //       ),
                      //     )),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      ExpandWidget(
                        first: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(147, 58, 241, 1),
                                  Color.fromRGBO(193, 81, 166, 1),
                                  Color.fromRGBO(247, 109, 78, 1),
                                  // Theme.of(context).colorScheme.primary
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Show Episodes",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        second: SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              dynamic currentEp =
                                  data[1]['_embedded']['episodes'][index];
                              return ListTile(
                                title: Text(
                                  "${currentEp['name']}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Text(
                                  style: Theme.of(context).textTheme.bodySmall,
                                  "Season: ${currentEp['season']} | Aired: ${currentEp['airdate']}",
                                ),
                              );
                            },
                            itemCount: (data[1]['_embedded']['episodes']
                                    as List<dynamic>)
                                .length,
                          ),
                        ),
                        scrollController: scrollController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: ExtendedOffsetFAB(
      //   scrollController: scrollController,
      //   label: 'Comments',
      //   iconData: Icons.message,
      //   changeOffset: 50,
      //   onTap: () {},
      // ),
    );
  }
}

class ActorsListRow extends StatelessWidget {
  const ActorsListRow(
      {Key? key, required this.cast, required this.label, required this.isCast})
      : super(key: key);

  final List<dynamic> cast;
  final String label;
  final bool isCast;

  @override
  Widget build(BuildContext context) {
    return cast.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...(cast)
                        .map(
                          (e) => isCast
                              ? SingleCast(
                                  e: e,
                                )
                              : SingleCrew(e: e),
                        )
                        .toList(),
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundColor: Colors.black12,
                    //   child: IconButton(
                    //     onPressed: () async {
                    //       var data =
                    //           await Navigator.pushNamed(context, AddCast.routeName);
                    //       if (data == null) return;
                    //       if (isDirector) {
                    //         movie.addDirector(data);
                    //       } else {
                    //         movie.addActor(data);
                    //       }
                    //     },
                    //     icon: const Icon(Icons.add),
                    //     splashRadius: 50,
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          );
  }
}

class SingleCast extends StatelessWidget {
  const SingleCast({
    required this.e,
    Key? key,
  }) : super(key: key);
  final dynamic e;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: e['person']['image'] == null
                    ? 'https://www.shutterstock.com/image-illustration/leather-background-jpeg-version-260nw-101031550.jpg'
                    : e['person']['image']['medium'],
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    LoadingAnimationWidget.beat(color: Colors.amber, size: 20),
                errorWidget: (context, url, error) {
                  return Image.asset('default.jpg');
                },
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 105,
            child: Text(
              e['person']['name'],
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class SingleCrew extends StatelessWidget {
  const SingleCrew({
    required this.e,
    Key? key,
  }) : super(key: key);
  final dynamic e;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: e['person']['image'] == null
                    ? 'https://www.shutterstock.com/image-illustration/leather-background-jpeg-version-260nw-101031550.jpg'
                    : e['person']['image']['medium'],
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    LoadingAnimationWidget.beat(color: Colors.amber, size: 20),
                errorWidget: (context, url, error) {
                  return Image.asset('default.jpg');
                },
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 105,
            child: Text(
              e['person']['name'],
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 105,
            child: Text(
              e['type'],
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: const Color.fromRGBO(144, 238, 144, 1)),
              textAlign: TextAlign.center,
            ),
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
    ans += "$tag, ";
  }
  ans = ans.substring(0, ans.length - 2);
  return ans;
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}

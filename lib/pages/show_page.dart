import 'package:flutter/material.dart';
import 'package:tv_app/widgets/faded_image.dart';
import 'package:tv_app/widgets/fade_on_scroll.dart';
import 'package:html/parser.dart';

class ShowPage extends StatelessWidget {
  ShowPage({required this.data, super.key});
  final ScrollController scrollController = ScrollController();
  final List<dynamic> data;

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
                        data[0]['name'] as String,
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
                              "${data[1]['averageRuntime']} | ${formatGenres((data[1]['genres']) as List<dynamic>)} | ${(data[1]['premiered'] as String).substring(0, 4)}",
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
                      Text(
                        'Top Cast',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      // ActorsListRow(
                      //   isDirector: false,
                      //   movieId: data['id'],
                      // ),
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

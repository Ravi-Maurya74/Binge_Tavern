import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tv_app/helpers/networking.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tv_app/pages/show_page.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController textEditingController = TextEditingController();
  CustomTextField({
    required this.label,
    this.hint = '',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(37, 42, 52, 1),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                padding: EdgeInsets.zero,
                enableFeedback: true,
                alignment: Alignment.centerLeft,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: null,
                // onPressed: () async {
                //   if (textEditingController.text.length > 2) {
                //     var results = await NetworkHelper().postData(
                //         url: 'searchMovies/',
                //         jsonMap: {"title": textEditingController.text});
                //     // print(textEditingController.value);
                //     Navigator.pushNamed(context, FilteredMovies.routeName,
                //         arguments: jsonDecode(results.body));
                //   }
                // },
              )),
          Expanded(
              child: TypeAheadField(
            hideOnLoading: true,
            minCharsForSuggestions: 2,
            getImmediateSuggestions: false,
            noItemsFoundBuilder: (context) => const ListTile(
              title: Text('No Movie found'),
            ),
            textFieldConfiguration: TextFieldConfiguration(
                controller: textEditingController,
                autofocus: false,
                decoration: const InputDecoration(border: InputBorder.none)),
            suggestionsCallback: (pattern) async {
              var results =
                  await NetworkHelper().getData(url: 'search/shows?q=$pattern');
              // print(jsonDecode(results.body));
              var ans = jsonDecode(results.body) as List<dynamic>;
              debugPrint(ans.length.toString());
              return ans.sublist(0, min(ans.length, 5));
            },
            itemBuilder: (context, itemData) {
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: itemData['show']['image']['medium'],
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: LoadingAnimationWidget.flickr(
                        leftDotColor: Colors.white,
                        rightDotColor: Colors.amber,
                        size: 20),
                  ),
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.person);
                  },
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  itemData['show']['name'] as String,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Row(
                  children: [
                    Text(
                      (itemData['show']['premiered'])
                          .toString()
                          .substring(0, 4),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 10,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      itemData['show']['rating']['average'] == null
                          ? "-"
                          : itemData['show']['rating']['average'].toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            },
            onSuggestionSelected: (suggestion) async {
              var futures = <Future>[];
              List<dynamic> response;
              try {
                futures.add(NetworkHelper().getData1(
                    url: suggestion["show"]["_links"]["previousepisode"]
                        ["href"]));
                futures.add(NetworkHelper().getData1(
                    url: "${suggestion["show"]["_links"]["self"]["href"]}?embed[]=crew&embed[]=cast&embed[]=episodes"));
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

              // Response movieData = await NetworkHelper()
              //     .postData(url: 'movieDetails/', jsonMap: {
              //   "movie_id": suggestion['id'],
              //   "user_id": Provider.of<User>(context, listen: false).id
              // });
              // Navigator.pushNamed(context, MoviePage.routeName,
              //     arguments: jsonDecode(utf8.decode(movieData.bodyBytes)));
            },
          )

              // TextField(
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     // label: Text(label),
              //     hintText: hint,
              //     // labelStyle: TextStyle(color: Colors.white),
              //   ),
              //   controller: textEditingController,
              //   autofillHints: gethints(label),
              // ),
              ),
        ],
      ),
    );
  }
}

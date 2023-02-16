import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:tv_app/helpers/networking.dart';

class Loader {
  late Completer<int> ch;
  List<dynamic> data = [];
  Loader() {
    debugPrint('started');
    ch = Completer();
    start();
  }
  Future<int> get choice {
    return ch.future;
  }

  void start() async {
    List<int> ids = randomNumber();
    List<dynamic> data1 = [];
    List<dynamic> data2 = [];
    var futures = <Future>[];
    for (var element in ids) {
      futures.add(NetworkHelper().getData(url: 'shows/$element'));
    }
    DateTime now = new DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 2));
    futures.add(NetworkHelper().getData(
        url: 'schedule/web?date=${date.year}-0${date.month}-${date.day}}'
            .substring(0, 28)));
    var mid = await Future.wait(futures);
    for (int i = 0; i < mid.length - 1; i++) {
      if (jsonDecode(mid[i].body)['image'] != null) {
        data1.add(jsonDecode(mid[i].body));
      }
    }
    Map<int, int> check = Map();
    List<dynamic> temp = jsonDecode(mid[mid.length - 1].body);
    temp.forEach((element) {
      if (element['_embedded']['show']["image"] != null &&
          !check.containsKey(element['_embedded']['show']['id'])) {
        data2.add(element);
        check.putIfAbsent(element['_embedded']['show']['id'], () => 1);
      }
    });

    data.add(data1);
    data.add(data2.sublist(0, min(data2.length, 50)));
    ch.complete(1);
  }
}

Future<void> loadImage(ImageProvider provider) {
  final config = ImageConfiguration(
    bundle: rootBundle,
    devicePixelRatio: window.devicePixelRatio,
    platform: defaultTargetPlatform,
  );
  final Completer<void> completer = Completer();
  final ImageStream stream = provider.resolve(config);

  late final ImageStreamListener listener;

  listener = ImageStreamListener((ImageInfo image, bool sync) {
    debugPrint("Image ${image.debugLabel} finished loading");
    completer.complete();
    stream.removeListener(listener);
  }, onError: (dynamic exception, StackTrace? stackTrace) {
    completer.complete();
    stream.removeListener(listener);
    FlutterError.reportError(FlutterErrorDetails(
      context: ErrorDescription('image failed to load'),
      library: 'image resource service',
      exception: exception,
      stack: stackTrace,
      silent: true,
    ));
  });

  stream.addListener(listener);
  return completer.future;
}

List<int> randomNumber() {
  var rng = Random();
  var l = new List.generate(20, (_) => rng.nextInt(67000));
  return l;
}

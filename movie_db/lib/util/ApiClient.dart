import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:movie_db/model/cast.dart';
import 'package:movie_db/model/movie.dart';

class ApiClient {
  static final _client = new ApiClient._internal();
  final _http = new HttpClient();

  ApiClient._internal();

  final _key = "1552e13158bab01da565a4b5140858a7";
  final String baseUrl = "api.themoviedb.org";

  static ApiClient get() {
    return _client;
  }

  Future<dynamic> _getJson(Uri uri) async {
    return _http
        .getUrl(uri)
        .then((request) => request.close())
        .then((response) => response.transform(utf8.decoder).join())
        .then((responseBody) => json.decode(responseBody));
  }

  Future<List<Movie>> pollMovies(
      {int page: 1, String category: "popular"}) async {
    var url = new Uri.https(baseUrl, '3/movie/$category',
        {'api_key': _key, 'page': page.toString()});

    return _getJson(url).then((json) => json['results']).then(
        (data) => data.map<Movie>((item) => new Movie.fromJson(item)).toList());
  }

  Future<List<CastMember>> getMovieCredits(int movieId) async {
    var url =
        new Uri.https(baseUrl, '3/movie/$movieId/credits', {'api_key': _key});

    return _getJson(url).then((json) =>
        json['cast'].map<CastMember>((item) => new CastMember.fromJson(item)).toList());
  }
}

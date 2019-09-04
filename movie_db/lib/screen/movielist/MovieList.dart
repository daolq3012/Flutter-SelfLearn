
import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/model/movie.dart';
import 'package:movie_db/screen/detail/MovieDetail.dart';
import 'package:movie_db/util/ApiClient.dart';

class MovieList extends StatefulWidget {
  MovieList({Key key, this.title, this.category}) : super(key: key);

  final String title;
  final String category;

  @override
  State<StatefulWidget> createState() {
    return _MovieState();
  }
}

class _MovieState extends State<MovieList> {
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();

  List<Movie> _movies;
  int _pageNumber = 1;

  _loadNextPage() async {
    _pageNumber++;
    try {
      var nextMovies = await ApiClient.get().pollMovies(page: _pageNumber);
      _movies.addAll(nextMovies);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async =>
      await ApiClient.get().pollMovies(category: this.widget.category),
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) =>
      new Text('Sorry, there was an error loading your movie'),
      renderSuccess: ({data}) {
        _movies = data;
        return new ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index > _movies.length * 0.7) {
                _loadNextPage();
              }
              return new MovieItemWidget(_movies[index]);
            });
      },
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: _asyncLoader,
      ),
    );
  }
}

class MovieItemWidget extends StatelessWidget {
  final Movie movie;

  MovieItemWidget(this.movie);

  Widget _getTitleSection() {
    var ratingColor =
    Color.lerp(Colors.red, Colors.green, movie.voteAverage / 10.0);

    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    child: new Text(movie.title,
                        style: new TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: new Text(
                      movie.releaseDate,
                      style: new TextStyle(color: Colors.grey[50]),
                    ),
                  )
                ],
              )),
          new Container(
            padding: const EdgeInsets.all(4.0),
            child: new Icon(
              Icons.star,
              color: ratingColor,
            ),
          ),
          new Text(movie.voteAverage.toString())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          new PageRouteBuilder(
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
              new FadeTransition(opacity: animation, child: child),
              pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return new MovieDetailWidget(movie);
              }),
        );
      },
      child: new Card(
        child: new Column(
          children: <Widget>[
            new Hero(
                tag: "Movie-Tag-${movie.id}",
                child: new FadeInImage.assetNetwork(
                  placeholder: "assets/placeholder.jpg",
                  image: movie.getBackDropUrl(),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                  fadeInDuration: new Duration(milliseconds: 50),
                )),
            _getTitleSection()
          ],
        ),
      ),
    );
  }
}

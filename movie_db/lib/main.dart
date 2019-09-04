import 'package:flutter/material.dart';
import 'package:movie_db/screen/movielist/MovieList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primarySwatch: Colors.lightGreen),
      routes: <String, WidgetBuilder>{'/': (context) => new HomePage()},
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () => {},
        child: new Icon(Icons.update),
      ),
      body: new PageView(
        children: <Widget>[
          new MovieList(title: 'Popular', category: 'popular'),
          new MovieList(title: 'Upcoming', category: 'upcoming'),
          new MovieList(title: 'Top Rated', category: 'top_rated')
        ],
        pageSnapping: true,
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _page = index;
          });
        },
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.thumb_up), title: new Text('Popular')),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.update), title: new Text('Upcoming')),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.star), title: new Text('Top Rated'))
        ],
        onTap: _navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  void _navigationTapped(int page) {
//    _pageController.animateToPage(page,
//        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    _pageController.jumpToPage(page);
  }
}

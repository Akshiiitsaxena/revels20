import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:revels20/models/CategoryModel.dart';
import 'package:revels20/models/DelegateCardModel.dart';
import 'package:revels20/models/EventModel.dart';
import 'package:revels20/models/MapModel.dart';
import 'package:revels20/models/ResultModel.dart';
import 'package:revels20/models/ScheduleModel.dart';
import 'package:revels20/models/UserModel.dart';
import 'package:revels20/pages/Categories.dart';
import 'package:revels20/pages/Favorites.dart';
import 'package:revels20/pages/Home.dart';
import 'package:revels20/pages/Login.dart';
import 'package:revels20/pages/Maps.dart';
import 'package:revels20/pages/Schedule.dart';
import 'package:revels20/pages/Results.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

List<String> favoriteEvents = [];

TextStyle headingStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400);
SharedPreferences preferences;
List<ScheduleData> allSchedule = [];
List<CategoryData> allCategories = [];
List<EventData> allEvents = [];
List<ResultData> allResults = [];
List<DelegateCardModel> allCards = [];

_startUserCache() async {
  try {
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    print(isLoggedIn);

    dio.options.baseUrl = "https://register.techtatva.in";
    dio.options.connectTimeout = 500000000; //5s
    dio.options.receiveTimeout = 300000000;

    if (isLoggedIn) {
      try {
        var resp = await dio.get("/registeredEvents");

        if (resp.statusCode == 200) {
          print(resp.data);
        }
      } catch (e) {}
    }

    if (isLoggedIn) {
      try {
        user = UserData(
            id: int.parse(preferences.getString('userId')),
            name: preferences.getString('userName'),
            regNo: preferences.getString('userReg'),
            mobilNumber: preferences.getString('userMob'),
            emailId: preferences.getString('userEmail'),
            qrCode: preferences.getString('userQR'),
            collegeName: preferences.getString('userCollege'));
      } catch (e) {
        print(e);
      }
    }
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Revels',
      theme: ThemeData(
        canvasColor: Colors.black,
        brightness: Brightness.dark,
        fontFamily: 'Product-Sans',
      ),
      home: MyHomePage(),
    );
  }
}

bool isLoggedIn;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  int _page = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double navWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startupCache();
    loadCategories();
    loadSchedule();
    loadEvents();
    loadResults();
    loadDelCards();
  }

  _startupCache() async {
    _startUserCache();
    _cacheSchedule();
    _cacheCategories();
    _cacheEvents();
    _cacheResults();
    _cacheDelCards();
  }

  void _cacheDelCards() async {
    try {
      final response = await http
          .get(Uri.encodeFull("https://api.mitrevels.in/delegate_cards"));

      if (response == null) return;

      if (response.statusCode == 200)
        preferences.setString('DelegateCards', json.encode(response.body));
    } catch (e) {
      print("problem with del cards");
      print(e);
    }
  }

  void _cacheSchedule() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/schedule"));
      if (response == null) return;
      if (response.statusCode == 200)
        preferences.setString('Schedule', json.encode(response.body));
    } catch (e) {
      print("schedulBT$e");
    }
  }

  void _cacheCategories() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/categories"));
      if (response == null) return;
      if (response.statusCode == 200)
        preferences.setString('Categories', json.encode(response.body));
    } catch (e) {
      print(e);
    }
  }

  void _cacheEvents() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/events"));
      if (response.statusCode == 200)
        preferences.setString('Events', json.encode(response.body));
      if (response == null) return;
    } catch (e) {
      print(e);
      print("error in fetching events");
    }
  }

  void _cacheResults() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/results"));
      if (response.statusCode == 200)
        preferences.setString('Results', json.encode(response.body));
      if (response == null) return;
    } catch (e) {
      print(e);
      print("Error in fetching results");
    }
  }

  @override
  Widget build(BuildContext context) {
    _pageController = new PageController();

    navWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        key: _scaffoldKey,
        child: Scaffold(
            floatingActionButton: Transform.scale(
              scale: 1,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return MyMap();
                  }));
                },
                backgroundColor: Color.fromRGBO(247, 176, 124, 1),
                child: Icon(
                  Icons.map,
                  size: 32,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.horizontal,
              children: <Widget>[Home(), Schedule(), Results(), LoginPage()],
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white.withOpacity(0.07),
              shape: CircularNotchedRectangle(),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildTabIcon(0, "Home", Icons.home),
                    buildTabIcon(1, "Schedule", Icons.schedule),
                    buildTabIcon(2, "Results", Icons.assessment),
                    buildTabIcon(3, "User", Icons.person),
                  ],
                ),
              ),
            )));
  }

  Padding buildTabIcon(int page, String name, IconData icon) {
    bool isCurrPage = page == _page;
    EdgeInsets padding;

    if (page == 0) {
      padding = EdgeInsets.only(left: 12);
    } else if (page == 1) {
      padding = EdgeInsets.only(right: 24);
    } else if (page == 3) {
      padding = EdgeInsets.only(right: 12);
    } else
      padding = EdgeInsets.only(left: 24);

    return Padding(
      padding: padding,
      child: InkWell(
        splashColor: Colors.transparent,
        child: Container(
          width: navWidth * 0.18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  icon,
                  color: isCurrPage ? Colors.blueAccent : Colors.white30,
                  size: 24.0,
                ),
              ),
              isCurrPage
                  ? Text(
                      name,
                      style: TextStyle(
                          color:
                              isCurrPage ? Colors.blueAccent : Colors.white30),
                    )
                  : Container()
            ],
          ),
        ),
        onTap: () {
          setState(() {
            _page = page;
            navigationTapped(_page);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 1), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  getPage(_pageController) {
    return _pageController.position;
  }

  _fetchEvents() async {
    List<EventData> events = [];

    preferences = await SharedPreferences.getInstance();

    var jsonData;

    var isCon;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isCon = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isCon = false;
    }

    try {
      String data = preferences.getString('Events') ?? null;

      if (data != null && !isCon) {
        jsonData = jsonDecode(jsonDecode(data));
      } else {
        final response =
            await http.get(Uri.encodeFull("https://api.mitrevels.in/events"));

        if (response.statusCode == 200) jsonData = json.decode(response.body);
      }

      for (var json in jsonData['data']) {
        try {
          var id = json['id'];
          var categoryId = json['category'];
          var name = json['name'];
          var free = json['free'];
          var short_description = json['shortDesc'];
          var long_description = json['longDesc'];
          var minTeamSize = json['minTeamSize'];
          var maxTeamSize = json['maxTeamSize'];
          var delCardType = json['delCardType'];
          var visible = json['visible'];
          var canReg = json['can_register'];

          EventData temp = EventData(
            id: id,
            categoryId: categoryId,
            name: name,
            free: free,
            shortDescription: short_description,
            longDescription: long_description,
            minTeamSize: minTeamSize,
            maxTeamSize: maxTeamSize,
            delCardType: delCardType,
            visible: visible,
            canRegister: canReg,
          );

          events.add(temp);
        } catch (e) {
          print(e);
          print("Error in parsing and fetching events");
        }
      }
    } catch (e) {
      print(e);
    }
    return events;
  }

  Future<String> loadEvents() async {
    allEvents = await _fetchEvents();
    //print(allEvents.length);
    return "success";
  }

  Future<String> loadDelCards() async {
    allCards = await _fetchCards();
    print("got card");
    return "success";
  }

  _fetchCards() async {
    List<DelegateCardModel> cards = [];

    preferences = await SharedPreferences.getInstance();

    var jsonData;
    var isCon;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isCon = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isCon = false;
    }

    try {
      String data = preferences.getString('DelegateCards') ?? "";
      if (data == "" && isCon) {
        final response = await http
            .get(Uri.encodeFull("https://api.mitrevels.in/delegate_cards"));

        if (response.statusCode == 200) {
          jsonData = json.decode(response.body);
        }
      } else {
        print(data);
        print(jsonDecode(jsonDecode(data)));
        jsonData = jsonDecode(jsonDecode(data));
      }

      for (var json in jsonData['data']) {
        try {
          var id = json['id'];
          var name = json['name'];
          var desc = json['description'];
          var mahePrice = json['MAHE_price'];
          var nonPrice = json['non_price'];
          var forSale = json['forSale'];
          var payMode = json['payment_mode'];
          var type = json['type'];

          DelegateCardModel temp = DelegateCardModel(
              id: id,
              name: name,
              desc: desc,
              mahePrice: mahePrice,
              nonMahePrice: nonPrice,
              forSale: forSale,
              paymentMode: payMode,
              type: type);

          cards.add(temp);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
    return cards;
  }

  Future<String> loadResults() async {
    allResults = await _fetchResults();
    return "success";
  }

  _fetchResults() async {
    List<ResultData> results = [];

    preferences = await SharedPreferences.getInstance();

    var jsonData;

    var isCon;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isCon = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isCon = false;
    }

    try {
      String data = preferences.getString('Results') ?? null;

      if (data != null && !isCon) {
        print("here res");
        jsonData = jsonDecode(jsonDecode(data));
      } else {
        final response =
            await http.get(Uri.encodeFull("https://api.mitrevels.in/results"));

        if (response.statusCode == 200) jsonData = json.decode(response.body);
      }

      for (var json in jsonData['data']) {
        try {
          var eventId = json['event'];
          var teamId = json['teamid'];
          var position = json['position'];
          var round = json['round'];

          ResultData temp = ResultData(
            eventId: eventId,
            teamId: teamId,
            position: position,
            round: round,
          );

          results.add(temp);
        } catch (e) {
          print(e);
          print("error in parsing results");
        }
      }
    } catch (e) {
      print(e);
    }
    return results;
  }

  _fetchCategories() async {
    List<CategoryData> category = [];

    preferences = await SharedPreferences.getInstance();

    var jsonData;

    var isCon;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isCon = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isCon = false;
    }

    String data = preferences.getString('Categories') ?? "";

    try {
      print(preferences.getString('Categories') ?? "");

      if (data == "" && isCon) {
        final response = await http
            .get(Uri.encodeFull("https://api.mitrevels.in/categories"));

        if (response.statusCode == 200) jsonData = json.decode(response.body);
      } else {
        jsonData = jsonDecode(jsonDecode(data));
      }

      //  print("\n\n\n$jsonData['data']\n\n\n");

      for (var json in jsonData['data']) {
        try {
          var id = json['id'];
          var name = json['name'];
          var short_description = json['vol_desc'];
          var long_description = json['description'];
          var type = json['type'];
          var cc1Name = json['cc1Name'];
          var cc1Contact = json['cc1Contact'];
          var cc2Name = json['cc2Name'];
          var cc2Contact = json['cc2Contact'];

          // add more with changes to API

          CategoryData temp = CategoryData(
              id: id,
              name: name,
              shortDescription: short_description,
              longDescription: long_description,
              type: type,
              cc1Contact: cc1Contact,
              cc1Name: cc1Name,
              cc2Contact: cc2Contact,
              cc2Name: cc2Name);

          category.add(temp);
        } catch (e) {
          print("error categories");
        }
      }
    } catch (e) {
      print(e);
    }
    return category;
  }

  Future<String> loadCategories() async {
    List<CategoryData> temp = await _fetchCategories();
    allCategories.clear();
    try {
      for (var item in temp) {
        if (item.type == "CULTURAL") {
          allCategories.add(item);
        }
      }
      allCategories.sort((a, b) {
        return a.name.compareTo(b.name);
      });
    } catch (e) {
      print(e);
      return "success";
    }
    //print('${allCategories.length}');
    return "success";
  }

  _fetchSchedule() async {
    List<ScheduleData> schedule = [];

    preferences = await SharedPreferences.getInstance();

    var jsonData;

    var isCon;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isCon = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isCon = false;
    }

    try {
      String data = preferences.getString('Schedule') ?? "";
      if (data == "" && isCon) {
        final response =
            await http.get(Uri.encodeFull("https://api.mitrevels.in/schedule"));

        if (response.statusCode == 200) {
          jsonData = json.decode(response.body);
        }
      } else {
        print(data);
        print(jsonDecode(jsonDecode(data)));
        jsonData = jsonDecode(jsonDecode(data));
      }

      for (var json in jsonData['data']) {
        try {
          var id = json['id'];
          var eventId = json['eventId'];
          var round = json['round'] ?? 3;
          var name = json['eventName'];
          var categoryId = json['categoryId'];
          var location = json['location'];
          var startTime = DateTime.parse(json['start']);
          var endTime = DateTime.parse(json['end']);

          ScheduleData temp = ScheduleData(
            id: id,
            eventId: eventId,
            round: round,
            name: name,
            categoryId: categoryId,
            startTime: startTime,
            endTime: endTime,
            location: location,
          );

          schedule.add(temp);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
    return schedule;
  }

  Future<String> loadSchedule() async {
    allSchedule = await _fetchSchedule();

    print("Here at least");

    Schedule rem = getInvisibleEvent();

    allSchedule.remove(rem);

    allSchedule.sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });
    return "success";
  }

  getInvisibleEvent() {
    int id;
    for (var event in allEvents) {
      print(event.visible);
      if (event.visible == 0) {
        print(event.name);
        id = event.id;
      }
    }

    for (var sched in allSchedule) {
      if (sched.eventId == id) return sched;
    }
  }
  // _buildBottomNavBarItem(String title, Icon icon) {
  //   return BottomNavigationBarItem(
  //       backgroundColor: Colors.black,
  //       activeIcon: icon,
  //       title: Text(title),
  //       icon: icon);
  // }
}

List<ScheduleData> scheduleForDay(List<ScheduleData> allSchedule, String day) {
  List<ScheduleData> temp = [];

  switch (day) {
    case 'Wednesday':
      for (var i in allSchedule) {
        if (i.startTime.day == 4) temp.add(i);
      }
      break;

    case 'Thursday':
      for (var i in allSchedule) {
        if (i.startTime.day == 5) temp.add(i);
      }
      break;

    case 'Friday':
      for (var i in allSchedule) {
        if (i.startTime.day == 6) temp.add(i);
      }
      break;

    case 'Saturday':
      for (var i in allSchedule) {
        if (i.startTime.day == 7) temp.add(i);
      }
      break;

    default:
      print("ERROR IN DAY WISE PARSINGG");
      break;
  }

  return temp;
}

String getTime(ScheduleData schedule) {
  return '${schedule.startTime.hour.toString()}:${schedule.startTime.minute.toString() == '0' ? '00' : schedule.startTime.minute.toString()} - ${schedule.endTime.hour.toString()}:${schedule.endTime.minute.toString() == '0' ? '00' : schedule.endTime.minute.toString()}';
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }

  static buildSliverAppBar(String name, String image, BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(name,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
        // background: Image.asset(image,
        //     color: Colors.black.withOpacity(0.55),
        //     colorBlendMode: BlendMode.darken,
        //     fit: BoxFit.cover),
        background: Stack(
          children: <Widget>[
            Container(
              height: 250,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.transparent.withOpacity(0.1),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(1)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.75, 1.0],
                    tileMode: TileMode.clamp),
              ),
            )
          ],
        ),
        collapseMode: CollapseMode.parallax,
      ),
      actions: <Widget>[
        (name == "Schedule")
            ? Container(
                padding: EdgeInsets.all(12.0),
                child: IconButton(
                  icon: Icon(Icons.favorite),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Favorites()),
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }
}

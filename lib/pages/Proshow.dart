import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stretchy_header/stretchy_header.dart';

class Proshow extends StatefulWidget {
  @override
  _ProshowState createState() => _ProshowState();
}

class _ProshowState extends State<Proshow> {
  Future<Map> futureArtists;
  Map artistInMap = {};
  List artistList = [];
  Future<Map> fetchProshowArtist() async {
    final response =
        await http.get('https://appdev.mitrevels.in/proshow/android');

    if (response.statusCode == 200) {
      return (json.decode(response.body));
    } else {
      throw Exception('Failed to load ProshowArtist');
    }
  }

  bool booltag;
  @override
  void initState() {
    super.initState();
    futureArtists = fetchProshowArtist();
    booltag = true;
  }

  var currentPage = imagesArtist.length - 1.0;
  @override
  Widget build(BuildContext context) {
    PageController controller =
        PageController(initialPage: imagesArtist.length, keepPage: false);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
            //  Colors.grey.withOpacity(0.1),
            Colors.black,
            Colors.black,
            Colors.black,
            Colors.black,
            //  Colors.grey.withOpacity(0.1),
          ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Proshow',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 10.0,
        ),
        body: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                  Stack(
                    children: <Widget>[
                      CardScrollWidget(
                          currentPage, imagesArtist, futureArtists),
                      Positioned.fill(
                        child: PageView.builder(
                          itemCount: 6,
                          controller: controller,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  _newTaskModalBottomSheet(
                                      context, index, futureArtists);
                                },
                                child: Container(color: Colors.transparent));
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: SliderButton(
                backgroundColor: Colors.black,
                //buttonColor: Color.fromRGBO(44, 183, 233, 1),
                buttonColor: Colors.green,
                radius: 10.0,
                buttonSize: 80.0,
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                alignLabel: Alignment.centerRight,
                dismissible: false,
                action: () {
                  print('Tapped'); //TODO Proshow payment
                  setState(() {
                    booltag = !booltag;
                  });
                },
                label: Text("Swipe Right to Pay",
                    style: TextStyle(color: Colors.red.withOpacity(1))),
                icon: Text('Buy Now\t➤',
                    style: TextStyle(color: Colors.white, fontSize: 18)))),
      ),
    );
  }

  void _newTaskModalBottomSheet(context, artistIndex, futureArtists) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        elevation: 30.0,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return FutureBuilder(
              future: futureArtists,
              builder: (context, snapshot) {
                var artistI = fixIndex(artistIndex);
                Map content = snapshot.data;
                if (snapshot.hasData) {
                  return Scaffold(
                    backgroundColor: Colors.black,
                    body: StretchyHeader.listView(
                      headerData: HeaderData(
                        blurContent: false,
                        headerHeight: 250,
                        header: Image.network(
                          content['data']["${artistI + 1}"]['artist_image_url'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'Description',
                            style: TextStyle(
                                fontFamily: 'Cabin',
                                color: Color.fromRGBO(247, 176, 124, 1),
                                fontSize: 30.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10.0, right: 10.0),
                          child: Text(
                              content['data']["${artistI + 1}"]['description'],
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                          // )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 20.0),
                              height:
                                  MediaQuery.of(context).size.height * 0.35 -
                                      150.0,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    "${getDate(artistIndex + 1)}",
                                    style: TextStyle(color: Color.fromRGBO(247, 176, 124, 1),fontSize: 20.0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                    ),
                                  ),
                                  Text(
                                    content['data']["${artistIndex + 1}"]
                                        ['time'],
                                    style: TextStyle(color: Color.fromRGBO(247, 176, 124, 1),fontSize: 20.0),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.35 -
                                        170.0,
                                width: MediaQuery.of(context).size.width * 0.50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromRGBO(44, 183, 233, 1),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      height:
                                          (MediaQuery.of(context).size.height *
                                                      0.35 -
                                                  150.0) /
                                              3,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(44, 183, 233, 1),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(44, 183, 233, 1),
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0)),
                                      ),
                                      child: Center(
                                          child: Text('Venue',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white))),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                          content['data']["${artistI + 1}"]
                                              ['venue'],
                                          style: headStyle(17.0)),
                                    )
                                  ],
                                )),
                          ],
                        ),
                        Container(
                            height: 2.0,
                            width: MediaQuery.of(context).size.width,
                            color: Color.fromRGBO(44, 183, 233, 0.5)),
                        Container(
                            // height: 600.0,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Rules and Regulations',
                                    style: TextStyle(
                                        fontFamily: 'Cabin',
                                        color: Color.fromRGBO(247, 176, 124, 1),
                                        fontSize: 30.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 10.0, right: 10.0),
                                  child: Text(content['rules1'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17.0)),
                                )
                              ],
                            ))
                      ],
                    ),
                  );
                }
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              });
        });
  }

  TextStyle headStyle(double fs) {
    return TextStyle(
      color: Colors.white,
      fontSize: fs,
    );
  }

  String getDate(int i) {
    String date = "";
    if (i == 1) {
      date = "4th March";
    } else if (i == 2) {
      date = "5th March";
    } else if (i <= 4) {
      date = "6th March";
    } else {
      date = "7th March";
    }
    return date;
  }
}

var cardAspectRatio = 12.0 / 20.0;
var widgetAspectRatio = cardAspectRatio * 1.25;

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;
  Future<Map> futureArtists;

  List<String> images;

  CardScrollWidget(this.currentPage, this.images, this.futureArtists);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureArtists,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;

            return new AspectRatio(
              aspectRatio: widgetAspectRatio,
              child: LayoutBuilder(builder: (context, contraints) {
                var primaryCardLeft = 50.0;
                var horizontalInset = primaryCardLeft;

                List<Widget> cardList = new List();
                for (var i = 0; i < 6; i++) {
                  var delta = i - currentPage;
                  bool isOnRight = delta > 0;
                  var j = fixIndex(i);
                  var start = padding +
                      math.max(
                          primaryCardLeft -
                              horizontalInset * -delta * (isOnRight ? 20 : 1),
                          0.0);

                  var cardItem = Positioned.directional(
                    top: padding + verticalInset * math.max(-delta, 0.0),
                    bottom: padding + verticalInset * math.max(-delta, 0.0),
                    start: start,
                    textDirection: TextDirection.rtl,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
                          border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                              style: BorderStyle.solid),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                offset: Offset(3.0, 6.0),
                                blurRadius: 10.0)
                          ]),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        child: AspectRatio(
                          aspectRatio: cardAspectRatio,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0)),
                                  child: Image.network(
                                    content['data']["${j + 1}"]
                                        ['vertical_image_url'],
                                    fit: BoxFit.cover,
                                  )),
                              // Align(
                              //   alignment: Alignment.bottomLeft,
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: <Widget>[
                              //       Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: 16.0, vertical: 8.0),
                              //       ),
                              //       SizedBox(
                              //         height: 10.0,
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.only(
                              //             left: 12.0, bottom: 12.0),
                              //         child: Container(
                              //           padding: EdgeInsets.symmetric(
                              //               horizontal: 22.0, vertical: 6.0),
                              //           decoration: BoxDecoration(
                              //               color:
                              //                   Color.fromRGBO(14, 17, 17, 0.5),
                              //               borderRadius:
                              //                   BorderRadius.circular(20.0)),
                              //           child: Text("Day " + "${getDay(j)}",
                              //               style: TextStyle(
                              //                   color: Colors.white,
                              //                   fontSize: 14.0)),
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // )
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        Colors.transparent,
                                        Colors.black,
                                      ],
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          tileMode: TileMode.clamp)),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Text("Day " + "${getDay(j)}",
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.75),
                                              fontSize: 32.0,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  cardList.add(cardItem);
                }
                return Stack(
                  children: cardList,
                );
              }),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

int getDay(int i) {
  int day = 1;
  if (i == 0)
    return day;
  else if (i == 1)
    return day + 1;
  else if (i <= 3)
    return day + 2;
  else
    return day + 3;
}

int fixIndex(int i) {
  int j;
  switch (i) {
    case 0:
      j = 5;
      break;
    case 1:
      j = 4;
      break;
    case 2:
      j = 3;
      break;
    case 3:
      j = 2;
      break;
    case 4:
      j = 1;
      break;
    case 5:
      j = 0;
      break;
  }
  return j;
}

Widget ruleItem(String rule, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 10.0, left: 20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10.0, top: 10.0),
          height: 5.0,
          width: 5.0,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(
                width: 2.0,
                color: Colors.white,
              )),
        ),
        Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            rule,
            style: headStyle(18.0),
            softWrap: true,
          ),
        )
      ],
    ),
  );
}

List<String> imagesArtist = [
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
];

TextStyle headStyle(double fs) {
  return TextStyle(
    color: Colors.white,
    fontSize: fs,
  );
}

class SliderButton extends StatefulWidget {
  final double radius;
  final double height;
  final double width;
  final double buttonSize;
  final Color backgroundColor;
  final Color baseColor;
  final Color highlightedColor;
  final Color buttonColor;
  final Text label;
  final Alignment alignLabel;
  final BoxShadow boxShadow;
  final Widget icon;
  final Function action;
  final bool shimmer;
  final bool dismissible;
  final LinearGradient linearGradient;
  final Alignment alignButton;
  SliderButton({
    @required this.action,
    this.linearGradient = const LinearGradient(colors: [
      Colors.white,
      Colors.white,
    ]),
    this.radius = 0,
    this.boxShadow = const BoxShadow(
      color: Colors.black,
      blurRadius: 4,
    ),
    this.shimmer = true,
    this.height = 70,
    this.buttonSize = 60,
    this.width = 250,
    this.alignLabel = const Alignment(0.4, 0),
    this.backgroundColor = const Color(0xffe0e0e0),
    this.baseColor = Colors.teal,
    this.buttonColor = Colors.white,
    this.highlightedColor = Colors.black,
    this.label = const Text(
      "Slide to cancel !",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
    ),
    this.icon = const Icon(
      Icons.power_settings_new,
      color: Colors.red,
      size: 30.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
    this.alignButton = Alignment.centerLeft,
    this.dismissible = true,
  });

  @override
  _SliderButtonState createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton> {
  bool flag;

  @override
  void initState() {
    super.initState();
    flag = true;
  }

  @override
  Widget build(BuildContext context) {
    return flag == true
        ? _control()
        : widget.dismissible == true
            ? Container()
            : Container(
                child: _control(),
              );
  }

  Widget _control() => Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          gradient: widget.linearGradient,
          color: widget.backgroundColor,
        ),
        alignment: Alignment.centerLeft,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 30.0),
              alignment: widget.alignLabel,
              child: widget.shimmer
                  ? Shimmer.fromColors(
                      baseColor: widget.baseColor,
                      highlightColor: widget.highlightedColor,
                      child: widget.label,
                    )
                  : widget.label,
            ),
            Dismissible(
              key: Key("cancel"),
              direction: DismissDirection.startToEnd,
              onDismissed: (dir) async {
                setState(() {
                  if (widget.dismissible) {
                    flag = false;
                  } else {
                    flag = !flag;
                  }
                });
                widget.action();
              },
              child: Container(
                width: widget.width - 60,
                height: widget.height,
                alignment: widget.alignButton,
                child: Container(
                  height: widget.height,
                  width: widget.buttonSize * 2,
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    color: widget.buttonColor,
                  ),
                  child: Center(child: widget.icon),
                ),
              ),
            ),
          ],
        ),
      );
}

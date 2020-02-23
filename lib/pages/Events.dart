import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import '../main.dart';

List tags = <String>[];
List rendertags = <String>[];
Map eventlist = {};
List renderevents = [];
MediaQueryData deviceinfo;

List filterchips = <Widget>[
  filterChipWidget(IsSelected: false,chipName: 'Music',),
  filterChipWidget(IsSelected: false,chipName: 'English',),
  filterChipWidget(IsSelected: false,chipName: 'Solo',),
  filterChipWidget(IsSelected: false,chipName: 'Hindi',),
  filterChipWidget(IsSelected: false,chipName: 'Other',),
  filterChipWidget(IsSelected: false,chipName: 'Painting',),
  filterChipWidget(IsSelected: false,chipName: 'Anime',),
  filterChipWidget(IsSelected: false,chipName: 'Public Speaking',),
  filterChipWidget(IsSelected: false,chipName: 'Gaming',),
  filterChipWidget(IsSelected: false,chipName: 'Comedy',),
  filterChipWidget(IsSelected: false,chipName: 'Bands',),
  filterChipWidget(IsSelected: false,chipName: 'Adventure',),
  filterChipWidget(IsSelected: false,chipName: 'Music',),
  filterChipWidget(IsSelected: false,chipName: 'Drama',),
  filterChipWidget(IsSelected: false,chipName: 'Photography',),
  filterChipWidget(IsSelected: false,chipName: 'Fashion',),
  filterChipWidget(IsSelected: false,chipName: 'Sports',),
];

void getrenderevents() {
  rendertags = [];
  renderevents = [];
  for (int i = 0; i < filterchips.length; i++) {
    if (filterchips[i].IsSelected) rendertags.add(filterchips[i].chipName);
  }
  if (eventlist != null) {
    if (rendertags.length == 0)
      for (int i = 0; i < eventlist['data'].length; i++)
        renderevents.add(eventlist['data'][i]);
    else
      for (int i = 0; i < eventlist['data'].length; i++) {
        for (int j = 0; j < rendertags.length; j++)
          if (eventlist['data'][i]['tags'].contains(rendertags[j])) {
            renderevents.add(eventlist['data'][i]);
          }
      }
    renderevents = renderevents.toSet().toList();
  }
}

String getcategoryname(int catid){
  for(int i = 0; i <allCategories.length;i++)
    {
      if(allCategories[i].id==catid) {
        return allCategories[i].name;
      }
    }
  return 'Revels';
}

String getdelegatecard(int delid){
  for(int i = 0; i <allCards.length;i++)
  {
    if(allCards[i].id==delid) {
      return allCards[i].name;
    }
  }
  return 'Delegate Card';
}


class Sample2 extends StatefulWidget {
  @override
  _Sample2State createState() => _Sample2State();
}

class _Sample2State extends State<Sample2> {
  ScrollController sc = new ScrollController();
  bool done = false;


  Future<Map> fetchEvents() async {
    http.Response response =
        await http.get('https://api.mitrevels.in/events');
    
    return json.decode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    deviceinfo = MediaQuery.of(context);
    return Scaffold(
      appBar: TopBar(title: 'Events', child: null, onPressed: null),
        body: FutureBuilder(
                          future: fetchEvents(),
                          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                            Map content = snapshot.data;
                            eventlist = content;
                            getrenderevents();
                            return (eventlist!=null)
                                ? Center(
                                child: Container(
                                    width: deviceinfo.size.width,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                    child: ListView.builder(
                                        controller: sc,
                                        itemCount: renderevents.length,
                                        addRepaintBoundaries: true,
                                        //primary: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                              onTap: () {
                                                _newTaskModalBottomSheet(context, renderevents[index]);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(43, 42, 42, 0.8),
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    boxShadow: [
                                                      BoxShadow(color: Colors.black, blurRadius: 5.0,
                                                      ),
                                                    ]),
                                                width: deviceinfo.size.width,
                                                height: 100.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(renderevents[index]['name'],
                                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.fade,
                                                            softWrap: false,
                                                          ),
                                                          padding: EdgeInsets.only(left: 5, right: 5),
                                                          width: deviceinfo.size.width * 0.65,
                                                          alignment: Alignment.center,
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(top: 5, bottom: 5),
                                                          height: 2,
                                                          color: Color.fromARGB(255, 22, 159, 196),
                                                          width: MediaQuery.of(context).size.width * 0.5,
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                                                            width: deviceinfo.size.width * 0.65,
                                                            alignment: Alignment.center,
                                                            child: Text(getcategoryname(renderevents[index]['category']),
                                                              style: TextStyle(color: Colors.white,fontSize: 16,), overflow: TextOverflow.fade,
                                                            ))
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                      EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 20.0),
                                                      child: Icon(Icons.info_outline, color: Color.fromARGB(255, 22, 159, 196),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        })))
                                : Container(
                                decoration: BoxDecoration(color: Colors.black),
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Shimmer.fromColors(
                                        highlightColor:
                                        Color.fromARGB(255, 22, 159, 196),
                                        baseColor: Colors.black,
                                        child: ImageIcon(
                                          AssetImage('assets/Revels20_logo.png'),
                                          size: 300.0,
                                        ))));
                          }
    ));
  }
}

class filterChipWidget extends StatefulWidget {
  final String chipName;
  var IsSelected = false;
  filterChipWidget({Key key, this.chipName, this.IsSelected}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
        child: FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
      selected: widget.IsSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.grey[900],
      onSelected: (isSelected) {
        setState(() {
          getrenderevents();
          widget.IsSelected = isSelected;
        });
        getrenderevents();
      },
      selectedColor: Color.fromARGB(255, 22, 159, 196),
    ));
  }
}

void _newTaskModalBottomSheet(context, event) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          color: Color.fromARGB(255, 20, 20, 20),
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              Container(
                  color: Color.fromARGB(255, 20, 20, 20),
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Text(event['name'],
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Divider(
                          color: Color.fromARGB(255, 22, 159, 196),
                          thickness: 3.0,
                        ),
                      ),
                      Container(
                        height: 20,
                        child: Text(getcategoryname(event['category']),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white)),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: getDetails(context, event),
              ),
            ],
          ),
        );
      });
}

Widget getDetails(context, event) {
  return Container(
    width: MediaQuery.of(context).size.width,
    color: Color.fromARGB(255, 20, 20, 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text('Delegate Card : '+
            getdelegatecard(event['delCardType']),
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: Container(
            width: 260,
            height: 50,
            child: Container(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  color: Color.fromARGB(255, 22, 159, 196),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {},
                )),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Text(
                'Description:',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              height: 200,
              width: MediaQuery.of(context).size.width / 1.2,
              child: ListView(
                children: <Widget>[
                  Text(event['longDesc'].length==0?event['shortDesc']:event['longDesc'],
                      style: TextStyle(color: Colors.white70, fontSize: 16.0),
                      textAlign: TextAlign.center)
                ],
              ),
            )
          ],
        ),
        Container(
            margin: const EdgeInsets.only(top: 10.0),
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child:
                            Text('Team Size: ', style: TextStyle(fontSize: 20,color: Colors.white)),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 30.0* event['minTeamSize'] / event['minTeamSize'],
                              width: 30.0* event['minTeamSize'] / event['minTeamSize'],
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 22, 159, 196),
                                ),
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 22, 159, 196),
                              )),
                          Container(
                              height: 30.0* event['minTeamSize'] / event['minTeamSize'],
                              width: 30.0* event['minTeamSize'] / event['minTeamSize'],
                              child: Center(
                                child: Text(event['minTeamSize'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                      Container(
                        width: 30.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          shape: BoxShape.rectangle,
                          color: Color.fromARGB(255, 22, 159, 196),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 30.0 + (5 * event['maxTeamSize'] / event['minTeamSize']),
                              width: 30.0 + (5 * event['maxTeamSize'] / event['minTeamSize']),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 22, 159, 196),
                                ),
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 22, 159, 196),
                              )),
                          Container(
                              height: 30.0 + (5 * event['maxTeamSize'] / event['minTeamSize']),
                              width: 30.0 + (5 * event['maxTeamSize'] / event['minTeamSize']),
                              child: Center(
                                child: Text(event['maxTeamSize'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    ),
  );
}

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  TopBar({@required this.title, @required this.child, @required this.onPressed, this.onTitleTapped})
      : preferredSize = Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context){
  return SafeArea(
    child: Container(
      color: Colors.black,
      padding: EdgeInsets.only(left: 10,right: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filterchips,
      ),
    ),
  );
  }
}
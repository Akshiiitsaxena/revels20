import 'package:flutter/material.dart';
import 'package:revels20/main.dart';
import 'package:revels20/models/DelegateCardModel.dart';

class DelegateCard extends StatefulWidget {
  @override
  _DelegateCardState createState() => _DelegateCardState();
}

class _DelegateCardState extends State<DelegateCard> {
  @override
  Widget build(BuildContext context) {
    print(allCards.length);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Delegate Cards"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          buildCardRow(context, "General"),
          buildCardRow(context, "Featured"),
          buildCardRow(context, "Gaming"),
          buildCardRow(context, "Workshop"),
          buildCardRow(context, "Sports")
        ],
      ),
    );
  }

  Column buildCardRow(BuildContext context, String type) {
    List<DelegateCardModel> filteredCards = [];

    for (var i in allCards) {
      if (i.type == type.toUpperCase()) {
        filteredCards.add(i);
      }
    }

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(38, 6, 12, 6),
          alignment: Alignment.centerLeft,
          child: Text(
            type,
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Container(
          // color: Colors.red.withOpacity(0.2),
          height: MediaQuery.of(context).size.height * 0.35,
          //width: MediaQuery.of(context),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredCards.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white10,
                ),
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          filteredCards[index].name,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(left: 8.0),
                      //   height: 0.5,
                      //   width: 200.0,
                      //   color: Colors.blueAccent,
                      // ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          filteredCards[index].desc,
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.white70),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Mahe Price: ${allCards[index].mahePrice}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              "Non-Mahe Price: ${allCards[index].nonMahePrice}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      (allCards[index].name.contains("e") ||
                              allCards[index].name == "Foodathon")
                          ? Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green.withOpacity(0.5),
                                    ),
                                    Container(
                                      width: 8.0,
                                      height: 10,
                                    ),
                                    Text(
                                      "Already Purchased",
                                      style: TextStyle(
                                        color: Colors.green.withOpacity(0.5),
                                      ),
                                    )
                                  ]),
                            )
                          : Container(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [0.1, 0.3, 0.7, 0.9],
                                      colors: [
                                        Colors.blueAccent.withOpacity(0.9),
                                        Colors.blueAccent.withOpacity(0.7),
                                        Colors.blue.shade800.withOpacity(0.8),
                                        Colors.blue.shade800.withOpacity(0.6),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30.0)),
                                height:
                                    MediaQuery.of(context).size.height * 0.055,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  onPressed: () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Buy Now",
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.transparent,
          height: 0.5,
          width: 300,
          margin: EdgeInsets.fromLTRB(0, 8, 0, 12.0),
        )
      ],
    );
  }
}

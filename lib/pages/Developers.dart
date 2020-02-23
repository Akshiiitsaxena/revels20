import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Developers extends StatefulWidget {
  @override
  _DevelopersState createState() => _DevelopersState();
}

class _DevelopersState extends State<Developers> {
  addDev() {
    developers.add(DeveloperModel(
        name: 'Akshit Saxena',
        image:
            "https://res.cloudinary.com/nxmxnjxxn/image/upload/v1569992353/akshit.jpg",
        platform: "Android",
        year: "Category Head"));
    developers.add(DeveloperModel(
        name: 'Naman Jain',
        image:
            "https://res.cloudinary.com/nxmxnjxxn/image/upload/v1569992353/naman.jpg",
        platform: "iOS",
        year: "Category Head"));
    developers.add(DeveloperModel(
        name: "Vaishnavi Janardhan",
        image:
            "https://res.cloudinary.com/nxmxnjxxn/image/upload/v1569992349/vaishnavi.jpg",
        platform: "Android",
        year: "Category Head"));
    developers.add(DeveloperModel(
        name: "Vedant Jain",
        image:
            "https://res.cloudinary.com/nxmxnjxxn/image/upload/v1569992353/vedant.jpg",
        platform: "iOS",
        year: "Category Head"));
    developers.add(DeveloperModel(
        name: "Chakshu Saraswat",
        image:
            "https://res.cloudinary.com/nxmxnjxxn/image/upload/v1569992353/chakshu.jpg",
        platform: "Android",
        year: "Organiser"));
    developers.add(DeveloperModel(
        name: "Anant Verma",
        image:
            "https://res.cloudinary.com/nxmxnjxxn/image/upload/v1569992353/anant.jpg",
        platform: "Android",
        year: "Organiser"));
    developers.add(DeveloperModel(
        name: "Prachotan Reddy",
        image:
            "https://res.cloudinary.com/nxmxnjxxn/image/upload/v1569992353/prachotan.jpg",
        platform: "Android",
        year: "Organiser"));
  }

  List<DeveloperModel> developers = [];

  @override
  void initState() {
    addDev();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("App Dev Team"),
          backgroundColor: Colors.black,
        ),
        body: Container(
          padding: EdgeInsets.all(12.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(developers.length, (index) {
              return _buildDevCard(context, index);
            }),
          ),
        ));
  }

  _buildDevCard(context, index) {
    return Container(
      padding: EdgeInsets.only(left: 3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: Container(
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 2.0,
                      height: 0.5,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.45),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(55.0),
                              child: CircleAvatar(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: developers[index].image,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                ),
                                radius: 48.0,
                              ),
                            ),
                          ),
                          Container(
                            //color: Colors.red,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              developers[index].name,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              '${developers[index].year} ${developers[index].platform}',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(2.0),
                          //   child: Text(developers[index].platform),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4.0),
                      color: Colors.greenAccent,
                      height: 0.5,
                      width: 75.0,
                    )
                  ],
                ),
                Container(
                  //margin: EdgeInsets.only(left: 2.0),
                  color: (index % 2 != 1)
                      ? Colors.greenAccent
                      : Colors.transparent,
                  height: 75.0,
                  width: 0.5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeveloperModel {
  String name;
  String image;
  String platform;
  String year;

  DeveloperModel({this.name, this.image, this.platform, this.year});
}

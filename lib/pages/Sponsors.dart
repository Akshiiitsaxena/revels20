import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorModel {
  final String name;
  final String link;
  final String image;
  final String desc;

  SponsorModel({this.name, this.link, this.image, this.desc});
}

class Sponsors extends StatefulWidget {
  @override
  _SponsorsState createState() => _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  List<SponsorModel> sponsors = [];

  @override
  void initState() {
    //getSponsors();
    // TODO: implement initState
    super.initState();
  }

  // getSponsors() {
  //   SponsorModel memg = SponsorModel(
  //       name: "MEMG",
  //       link: "https://www.manipalgroup.com/memg.html",
  //       image: "assets/memg.jpeg",
  //       desc:
  //           "MEMG operates three Universities in India, recognised by the University Grants Commission. Separately, the businesses and other initiatives of the Group were restructured, where the activities of similar nature were clubbed under four key verticals of Education, Healthcare, Research and Foundation");

  //   SponsorModel decathlon = SponsorModel(
  //       name: "Decathlon",
  //       link: "https://www.decathlon.in/",
  //       image: "assets/decathlon.jpeg",
  //       desc:
  //           "Decathlon is your one stop shop for buying sports goods online in India. They are B2C now, open for all to buy sports products at an extremely affordable price.Their end goal is to sustainably make the pleasure and benefits of sport accessible to the many.");

  //   SponsorModel digitalOcean = SponsorModel(
  //       name: "Digital Ocean",
  //       link: "https://www.digitalocean.com/",
  //       image: "assets/do.jpeg",
  //       desc:
  //           "DigitalOcean makes it simple to launch in the cloud and scale up as you grow—with an intuitive control panel, predictable pricing, team accounts and more. Their optimized configuration process saves your team time when running and scaling distributed applications, AI & machine learning workloads, hosted services, client websites, or CI/CD environments. They believe in building more and spending less time managing your infrastructure with our easy-to-use control panel and API.");

  //   SponsorModel reliableSpaces = SponsorModel(
  //       name: "Reliable Spaces",
  //       link: "http://www.reliablespaces.com/index/public/index/",
  //       image: "assets/rs.jpg",
  //       desc:
  //           "Today Reliable Plaza, Reliable Tech Space, Reliable Tech Park and Liberty Tower stand testimony to the company’s vision with their impressive architecture, remarkable amenities and top notch safety and security systems. Currently under construction is the soon to be completed Empire Tower whopping 2 million sq. ft. project.");

  //   sponsors.add(memg);
  //   sponsors.add(decathlon);
  //   sponsors.add(digitalOcean);
  //   sponsors.add(reliableSpaces);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Our Sponsors"),
        centerTitle: true,
      ),
    //   body: Container(
    //     padding: EdgeInsets.all(12.0),
    //     child: ListView.builder(
    //       itemCount: sponsors.length,
    //       itemBuilder: (context, index) {
    //         return InkWell(
    //           onTap: () {
    //             _launchURL(sponsors[index].link);
    //           },
    //           child: Container(
    //             child: Column(
    //               children: <Widget>[
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 12.0),
    //                   child: ClipRRect(
    //                     borderRadius: BorderRadius.circular(12.0),
    //                     child: Container(
    //                       padding: EdgeInsets.all(24.0),
    //                       color: Colors.white,
    //                       height: 100.0,
    //                       width: 300.0,
    //                       child: Image.asset(
    //                         sponsors[index].image,
    //                         fit: BoxFit.fitHeight,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   alignment: Alignment.center,
    //                   child: Text(
    //                     sponsors[index].name,
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(color: Colors.white, fontSize: 32.0),
    //                   ),
    //                   //   color: Colors.blue,
    //                   padding: EdgeInsets.all(4.0),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.all(7.0),
    //                   alignment: Alignment.center,
    //                   child: Text(
    //                     sponsors[index].desc,
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(color: Colors.white70, fontSize: 18.0),
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.all(3.0),
    //                   alignment: Alignment.center,
    //                   child: Text(
    //                     "tap for more",
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(color: Colors.white54),
    //                   ),
    //                 ),
    //                 Container(
    //                   margin: EdgeInsets.all(12.0),
    //                   color: Colors.greenAccent,
    //                   height: 0.5,
    //                   width: 250.0,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

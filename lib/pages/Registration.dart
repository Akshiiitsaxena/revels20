//import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:revels20/pages/Login.dart';
import './AutoComplete.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:url_launcher/url_launcher.dart';

String collname, initialLink;
bool inpassword = false;

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool selected = true;
  double width1 = 265.0;

  Widget login() {
    return Text(
      'Register',
      style: TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }

  String name, email, mobile, id;
  bool _autovalidate = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  _launchURL() async {
    const url = 'tel:+918076740513';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return /*(initialLink==null)?*/ Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: <Widget>[
          Container(
            width: 200,
            height: 200,
            child: Image.asset('assets/Revels20_logo.png'),
            alignment: Alignment.topCenter,
          ),
          Form(
            key: _key,
            autovalidate: _autovalidate,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        validator: validatename,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          icon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 247, 176, 124),
                          ),
                          hintText: 'Name',
                        ),
                        onChanged: (String val) {
                          name = val;
                        },
                      )),
                  Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        validator: validateemail,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          icon: Icon(
                            Icons.mail_outline,
                            color: Color.fromARGB(255, 247, 176, 124),
                          ),
                          hintText: 'Email ID',
                        ),
                        onChanged: (String val) {
                          email = val;
                        },
                      )),
                  Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        validator: validatephone,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          icon: Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 247, 176, 124),
                          ),
                          hintText: 'Phone',
                        ),
                        onChanged: (String val) {
                          mobile = val;
                        },
                      )),
                  FlatButton(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.school,
                            color: Color.fromARGB(255, 247, 176, 124),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Text(
                                      collname == null
                                          ? 'Search for your college'
                                          : collname,
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16),
                                      maxLines: 3,
                                      overflow: TextOverflow.fade,
                                    )))),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.info_outline),
                            color: Color.fromARGB(255, 247, 176, 124),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: new Text(
                                          "Please search for your college. \nIf college not present, please contact Outstation Management at om.revels20@gmail.com or Call"),
                                      actions: <Widget>[
                                        new FlatButton(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Icon(
                                                  Icons.call,
                                                  color: Color.fromARGB(
                                                      255, 247, 176, 124),
                                                  size: 18,
                                                ),
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                              ),
                                              Text(
                                                "Call",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 247, 176, 124)),
                                              )
                                            ],
                                          ),
                                          onPressed: () {
                                            _launchURL();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        new FlatButton(
                                          child: new Text(
                                            "Back",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 247, 176, 124)),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      collname = null;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AutoComplete()),
                      ).then((_) {
                        print(collname);
                      });
                    },
                  ),
                  Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        validator: validateid,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          icon: Icon(
                            Icons.confirmation_number,
                            color: Color.fromARGB(255, 247, 176, 124),
                          ),
                          hintText: 'Reg. No./Faculty ID',
                        ),
                        onChanged: (String val) {
                          id = val;
                        },
                      )),
                  Center(
                    child: AnimatedContainer(
                      padding: EdgeInsets.only(top: 12.0),
                      duration: Duration(milliseconds: 500),
                      width: width1,
                      height: 45,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.1, 0.9],
                                colors: [
                                  Colors.blueAccent.withOpacity(0.8),
                                  Colors.lightBlueAccent.withOpacity(1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: login(),
                            onPressed: () {
                              _sendToServer();
                              setState(() {});
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ); /*:Password();*/
  }

  String validatename(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validatephone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if (value.length != 10) {
      return "Mobile number must 10 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  String validateemail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validateid(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "ID is required is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validatecollegename(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "College Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      selected = false;
      print(collname);
      if (selected)
        width1 = 265;
      else {
        String token = "kr4Ju4ImZ7aPJoQLhepb";
        String type = "invisible";
        var response =
            await dio.post("https://register.mitrevels.in/signup/", data: {
          "name": name,
          "email": email,
          "regno": id,
          "collname": collname,
          "mobile": mobile,
          'g-recaptcha-response': token,
          'type': type
        });
        if (response.data['success'] == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Success!"),
                content: new Text(
                    "User Registered Successully.\nPlease Check your email and click on the link!"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (response.data['success'] == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.grey[900],
                title: new Text("Invalid email or password"),
                content: new Text(
                    "Please check the email or password you have entered"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Try Again"),
                    onPressed: () {
                      //initUniLinks();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        print(response.statusCode);
      }
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  /*Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      print("hello:");
      print(initialLink);
      if(!inpassword)
      setState(() {

      });
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }


  bool _autovalidate1=false;
  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  @override
  bool _passwordVisible = true;
  bool _passwordVisible1 = true;
  String initialLink,password,password2;
  Dio dio=new Dio();

  String validatepassword(String value) {
    if (password.length == 0) {
      return "Password is Required";
    } else if(password.length < 8){
      return "Minimum length is 8";
    }
    else if(password!=password2)
      return "Passwords do not match";

    return null;
  }

  String validatepassword2(String value) {
    if (password2.length==0) {
      return "Password is Required";
    } else if(password2.length<8){
      return "Minimum length is 8";
    }
    else if(password!=password2)
      return "Passwords do not match";

    return null;
  }


  ScrollController sc = new ScrollController();

  Widget Password() {
    inpassword=true;
    print('inside password');
      return Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          controller: sc,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 200,
              child: Image.asset('assets/RevelsLogo.png',alignment: Alignment.topCenter,),
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),
                height: 400,
                child: ListView(
                    controller: sc,
                    children:<Widget>[
                      Form(
                        key: _key1,
                        autovalidate: _autovalidate1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[850],
                          ),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(20),
                                child: TextFormField(
                                    validator: validatepassword,
                                    obscureText: _passwordVisible,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: Colors.white70,
                                        ),
                                        hintText: 'Password',
                                        suffixIcon: IconButton(icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility, color: _passwordVisible ? Colors.white70 : Color.fromARGB(255,247,176,124)),
                                          onPressed: (){
                                            setState(() {
                                              _passwordVisible ^= true;
                                            });
                                          },
                                        )
                                    ),
                                    onChanged: (String val){
                                      password=val;}
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: TextFormField(
                                    validator: validatepassword2,
                                    obscureText: _passwordVisible1,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: Colors.white70,
                                        ),
                                        hintText: 'Retype Password',
                                        suffixIcon: IconButton(icon: Icon(_passwordVisible1 ? Icons.visibility_off : Icons.visibility, color: _passwordVisible1 ? Colors.white70 : Color.fromARGB(255,247,176,124),),
                                          onPressed: (){
                                            setState(() {
                                              _passwordVisible1 ^= true;
                                            });
                                          },
                                        )
                                    ),
                                    onChanged: (String val){
                                      password2=val;}
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Text('Minimum length 8 characters',style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12
                                ),),
                              ),
                              Container(
                                child: FlatButton(
                                  splashColor: Color.fromARGB(255, 22, 159, 196),
                                  padding: EdgeInsets.only(left: 20,right:20,top:10,bottom:10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 22, 159, 196),
                                      width: 2.5,
                                    ),
                                  ),
                                  child: Text('Submit Password',style: TextStyle(color: Colors.white,fontSize: 16),),
                                  onPressed: () async {
                                    _autovalidate1=true;
                                    setState(() {
                                    });
                                    if(_key1.currentState.validate()){
                                      _key1.currentState.save();
                                      initUniLinks();
                                      var a=initialLink.split('=');
                                      print(a[1]);
                                      String token=a[1];
                                      print(token);
                                      var response = await dio.post("https://register.mitrevels.in/setPassword/", data: {
                                        "token":token,
                                        "password": password,
                                        "password2":password2,
                                      });
                                      print(response.data['success']);
                                      if(response.data['success'] == true) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.grey[900],
                                              title: new Text("Success!",style: TextStyle(color: Colors.white)),
                                              content: new Text(
                                                  "Password set successfully",style: TextStyle(color: Colors.white)),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text("OK",style: TextStyle(color: Color.fromARGB(255,247,176,124))),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }

                                      else if(response.data['success'] == false)
                                      {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.grey[900],
                                              title: new Text("Invalid input",style: TextStyle(color: Colors.white),),
                                              content: new Text(
                                                  "Please check the password you have entered",style: TextStyle(color: Colors.white)),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text("Try Again",style: TextStyle(color: Color.fromARGB(255,247,176,124))),
                                                  onPressed: () {
                                                    //initUniLinks();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                )
            )
          ],
        ),
      );
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PasswordScreen()));
  }*/
}

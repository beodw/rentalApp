import 'dart:ui';
import 'package:best_flutter_ui_templates/hotel_booking/hotel_list_view.dart';
import 'package:best_flutter_ui_templates/hotel_booking/model/hotel_list_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'hotel_app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_home_screen.dart';
import 'package:best_flutter_ui_templates/hotel_booking/MessagesPage.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:best_flutter_ui_templates/hotel_booking/model/User.dart';
import 'package:best_flutter_ui_templates/hotel_booking/model/Listing.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

Future<List<Post>> search(String search) async {
  await Future.delayed(Duration(seconds: 2));
  return List.generate(search.length, (int index) {
    return Post(
      "Title : $search $index",
      "Description :$search $index",
    );
  });
}

class HotelHomeScreen extends StatefulWidget {
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen> with TickerProviderStateMixin {
  double startOfSwipe = 0.0;
  double endOfSwipe = 0.0;
  List<User> users = [
    User(name: 'Beod', online: false, isLandLord: true),
    for (int i = 0; i < 25; i++) User(name: 'Danielle', online: true, isLandLord: false),
  ];
  AnimationController? animationController;
  List<HotelListData> hotelList = HotelListData.hotelList;
  List listOfListings = [
    for (int i = 0; i < 20; i++) i
  ];
  List<List<String>> listing_types = [
    [
      'Entire House',
      'entire_house.jpg'
    ],
    [
      'Apartment',
      'apartment.jpg',
    ],
    [
      'Out Door Space',
      'outdoorHouse.jpg',
    ],
    [
      'Misc',
      'hotel_4.png',
    ],
  ];
  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  static const List<List<String>> places = [
    [
      'Lumley',
      'LY'
    ],
    [
      'Aberdeen',
      'AB'
    ],
    [
      'Juba',
      'JA'
    ]
  ];
  List<Widget> places_near_me = [
    Container(
      child: GestureDetector(
        onTap: () {
          print('Navigate to places near you page.');
        },
        child: ListTile(
          // leading: null,
          leading: CircleAvatar(
            child: Icon(Icons.map, color: Colors.black87),
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
          ),
          trailing: null, // Icon(Icons.place, color: Colors.black87),
          title: Padding(
            padding: EdgeInsets.only(
              left: 15,
            ),
            child: Text('Places Near You'),
          ),
        ),
      ),
    ),
    for (List val in places)
      Container(
        child: GestureDetector(
          onTap: () {
            print('Navigate to places near you page.');
          },
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${val[1]}'),
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
            ),
            trailing: Icon(Icons.place, color: Colors.black87),
            title: Text('${val[0]}'),
            subtitle: Text('Western Area Urban'),
          ),
        ),
      ),
  ];
  List<Widget> search_pageResults = [];

  @override
  void initState() {
    search_pageResults = [];
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    search_pageResults = [];
    animationController?.dispose();
    super.dispose();
  }

  int selectedSection = 0; //selected section in bottom bar.

  void onSectionSelected(int index) {
    setState(() {
      selectedSection = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget search_results({List listings = const []}) {
      return Container(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ListView.builder(
                itemCount: hotelList.length,
                padding: const EdgeInsets.only(top: 60),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  final int count = hotelList.length > 10 ? 10 : hotelList.length;
                  final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController!, curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)));
                  animationController?.forward();
                  return HotelListView(
                    callback: () {},
                    hotelData: hotelList[index],
                    animation: animation,
                    animationController: animationController!,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget buildFloatingSearchBar(String hintText, Icon rightAlignedIcon) {
      final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

      return FloatingSearchBar(
        borderRadius: BorderRadius.circular(30.0),
        hint: '$hintText',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : 0.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          // Call your model, bloc, controller here.
          //after sucessfull result from backend.
          //clear placeholder if any.
          bool found = false;
          found = query == '' ? false : true;
          //conect to backend and update false if any records found.
          if (found) {
            for (int i = 0; i < 10; i++) {
              //loop through list returned from backend.
              //and add all elements to search_pageResults list.
              Widget elem = Container(
                color: Color.fromRGBO(255, 255, 255, 0.2),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => search_results()),
                    );
                    print('Navigate to results page.');
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${query.substring(0, 2).toUpperCase()}'),
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
                    ),
                    trailing: Icon(Icons.place, color: Colors.black87),
                    title: Text('$query'),
                    subtitle: Text('Western Area Urban'),
                  ),
                ),
              );
              setState(() {
                search_pageResults.add(elem);
              });
            }
          } else {
            setState(() {
              search_pageResults = [];
            });
          }
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: SlideFadeFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: rightAlignedIcon,
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: search_pageResults.isEmpty ? places_near_me : search_pageResults,
              ),
            ),
          );
        },
      );
    }

    Widget profile_page_elements = Container(
      child: Center(
        child: Text(
          'Not Yet Implemeted.',
        ),
      ),
    );

    Widget search_page_elements = Container(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: AnimatedContainer(
              duration: Duration(
                milliseconds: 100,
              ),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: ListView.builder(
                  itemCount: listOfListings.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Container(
                        color: Colors.transparent,
                        child: index == 0
                            ? Column(children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 5.0,
                                        ),
                                        child: Text(
                                          'Categories',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0, bottom: 0),
                                  child: Container(
                                    height: 120,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: listing_types.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5),
                                            child: Container(
                                              child: Column(children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () {
                                                        //make call to back end using category string
                                                        //return list of listings
                                                        print(listing_types.elementAt(index)[0]);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => Scaffold(body: search_results())),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 100,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(30),
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage('assets/hotel/${listing_types.elementAt(index)[1]}'),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5),
                                                              spreadRadius: 1,
                                                              blurRadius: 2,
                                                              offset: Offset(0.0, 1.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '${listing_types.elementAt(index)[0]}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(
                                //     top: 15,
                                //     bottom: 0,
                                //   ),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: <Widget>[
                                //       Text(
                                //         'See more',
                                //         style: TextStyle(color: Colors.blue),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ])
                            : Padding(
                                padding: MediaQuery.of(context).orientation == Orientation.portrait ? EdgeInsets.only(left: 30, right: 30, bottom: listOfListings.length - 1 == index ? 20 : 5, top: 0) : EdgeInsets.only(left: 30, right: 30, bottom: 20),
                                child: Column(
                                  children: <Widget>[
                                    if (index == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Near You',
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: 250,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 2,
                                                offset: Offset(0.0, 1.0),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(20.0),
                                            // image: DecorationImage(
                                            //   image: index % 2 == 0 ? AssetImage('assets/hotel/hotel_2.png') : AssetImage('assets/hotel/hotel_3.png'),
                                            //   fit: BoxFit.cover,
                                            // ),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Center(
                                                child: Stack(
                                                  children: <Widget>[
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      child: Container(
                                                        height: 250.0,
                                                        width: MediaQuery.of(context).size.width,
                                                        child: ListView.builder(
                                                          itemCount: 5,
                                                          scrollDirection: Axis.horizontal,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: index % 2 == 0 ? AssetImage('assets/hotel/hotel_2.png') : AssetImage('assets/hotel/hotel_3.png'),
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                              width: MediaQuery.of(context).size.width - 60.0,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.only(bottom: 10.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              for (int i = 0; i < 4; i++)
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal: 3.0,
                                                                  ),
                                                                  child: ClipOval(
                                                                    child: Container(
                                                                      color: Colors.grey.withOpacity(0.3),
                                                                      height: 10.0,
                                                                      width: 10.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 20, right: 20),
                                                child: Align(
                                                    alignment: Alignment.topRight,
                                                    child: ClipOval(
                                                      child: Material(
                                                        color: Colors.transparent, // Button color
                                                        child: InkWell(
                                                          splashColor: Colors.white.withOpacity(0.7), // Splash color
                                                          onTap: () {
                                                            print('Liked');
                                                          },
                                                          child: SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child: Stack(
                                                              children: <Widget>[
                                                                Icon(
                                                                  Icons.favorite_border,
                                                                  color: Color.fromRGBO(154, 242, 245, 0.5),
                                                                  size: 30.0,
                                                                ),
                                                                Icon(
                                                                  Icons.favorite,
                                                                  color: Colors.blueAccent.withOpacity(0.1),
                                                                  size: 30.0,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      Icons.star,
                                                      size: 15.0,
                                                      color: Color(0XFF9AF2F5),
                                                    ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 5.0,
                                                    ),
                                                    child: Text(
                                                      '4 stars',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Hedazi Villa',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Bar Junction, Levuma',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    );
                  }),
            ),
          ),
          Positioned(
            child: buildFloatingSearchBar('Search a location...', Icon(Icons.place)),
          ),
        ],
      ),
    );
    Widget inbox_page_elements = Container(
        child: Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> listOfContacts = [
                      'Beod',
                      'Wilson',
                      'Danielle',
                      'Rose',
                      'Russell'
                    ];
                    List<String> states = [
                      'Online',
                      'Offline'
                    ];
                    String title = listOfContacts[index % 5];
                    String subTitle = states[index % 2];
                    User user = users[index];

                    return GestureDetector(
                      onLongPress: () {},
                      onHorizontalDragStart: (DragStartDetails details) {
                        setState(() {
                          this.startOfSwipe = details.globalPosition.dx.floorToDouble();
                        });
                      },
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        setState(() {
                          this.endOfSwipe = details.globalPosition.dx.floorToDouble();
                        });
                        if (this.startOfSwipe - this.endOfSwipe > HotelAppTheme.swipeEffort) {
                          //if left swipe
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MessagesPage(conversationUrl: 'onSwipe')),
                          );
                        }
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MessagesPage(conversationUrl: 'onTap')),
                        );
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 20, right: 20),
                        leading: CircleAvatar(
                          backgroundColor: Color(0XFF9AF2F5),
                          child: Text('${user.name.substring(0, 2).toUpperCase()}'),
                        ),
                        title: Text('${user.name}'),
                        subtitle: Text('${user.online ? "Online" : "Offline"}'),
                        selectedTileColor: Color(0xFFF20707),
                        trailing: GestureDetector(
                          onTap: () {
                            final snackBar = SnackBar(content: Text('Tap from icon'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: Icon(Icons.photo_camera_outlined),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ));
    Widget favorites_page_elements = Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Center(
              child: Text('Not Yet implemented'),
            ),
          ),
        ],
      ),
    );
    final List<Widget> sections = [
      search_page_elements,
      favorites_page_elements,
      inbox_page_elements,
      profile_page_elements,
    ];

    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(children: <Widget>[
            Positioned(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2 - 50,
                    // width: MediaQuery.of(context).size.width,
                    color: Colors.brown.withOpacity(0.2),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    // width: MediaQuery.of(context).size.width,
                    color: Colors.blueAccent.withOpacity(0.2),
                  ),
                ],
              ),
            ),
            sections.elementAt(selectedSection),
          ]),
          bottomNavigationBar: CurvedNavigationBar(
            onTap: onSectionSelected,
            backgroundColor: Colors.blueAccent.withOpacity(0.2), //Color(0XFF9AF2F5),
            color: Colors.white,
            index: selectedSection,
            height: 50.0,
            buttonBackgroundColor: Colors.white,
            animationCurve: Curves.easeOutQuint,
            animationDuration: Duration(milliseconds: 300),
            items: [
              Icon(Icons.search_outlined),
              Icon(Icons.favorite_border_outlined),
              Icon(Icons.inbox_outlined),
              Icon(Icons.account_circle_outlined),
            ],
          ),
        ),
      ),
    );
  }
}

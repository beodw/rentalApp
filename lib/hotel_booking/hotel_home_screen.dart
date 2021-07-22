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

  List<String> appBarTitles = [
    'Explore',
    'WishList',
    'Notifications',
    'Profile'
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
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Container(
                        color: Colors.transparent,
                        child: index == 0
                            ? Column(children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 5.0,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Top Listings',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5.0),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    splashColor: Colors.grey.withOpacity(0.5),
                                                    onTap: () {
                                                      print('View All Top Listings');
                                                    },
                                                    child: Container(
                                                      height: 37,
                                                      width: 60,
                                                      child: Center(
                                                        child: Text(
                                                          'View All',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0, bottom: 0),
                                  child: Container(
                                    height: 260,
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

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => Scaffold(body: search_results())),
                                                        );
                                                      },
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Align(
                                                              alignment: Alignment.topRight,
                                                              child: Container(
                                                                width: 50,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(0.0),
                                                                    topRight: Radius.circular(15.0),
                                                                    bottomLeft: Radius.circular(0.0),
                                                                    bottomRight: Radius.circular(0.0),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets.only(right: 3.0),
                                                                      child: Icon(
                                                                        Icons.star,
                                                                        size: 10.0,
                                                                        color: Colors.orange,
                                                                      ),
                                                                    ),
                                                                    Text('4.0'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment.bottomCenter,
                                                              child: Container(
                                                                height: 100.0,
                                                                width: 250,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                    bottomRight: Radius.circular(
                                                                      15.0,
                                                                    ),
                                                                  ),
                                                                  color: Colors.white,
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(top: 5.0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                          horizontal: 5.0,
                                                                        ),
                                                                        child: Column(
                                                                          children: <Widget>[
                                                                            Text(
                                                                              'Hedazi Villa',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20.0,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              'John Drive, Lumley',
                                                                              style: TextStyle(
                                                                                fontSize: 12.0,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                          right: 10.0,
                                                                        ),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Container(
                                                                              height: 50,
                                                                              width: 100,
                                                                              child: Text(
                                                                                'Le 700 M / yr',
                                                                                style: TextStyle(
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        height: 250,
                                                        width: 250,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(15),
                                                            topRight: Radius.circular(15),
                                                            bottomRight: Radius.circular(15),
                                                            bottomLeft: Radius.circular(0),
                                                          ),
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
                                                // Row(
                                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //   children: <Widget>[
                                                //     Container(
                                                //       width: 70,
                                                //       child: Text(
                                                //         '${listing_types.elementAt(index)[0]}',
                                                //         style: TextStyle(
                                                //           fontWeight: FontWeight.bold,
                                                //         ),
                                                //       ),
                                                //     ),
                                                //     Text('Le 20,000,000 / yr'),
                                                //   ],
                                                // ),
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
                            :

                            // HotelListView(
                            //     callback: () {},
                            //     hotelData: hotelList[index],
                            //     animation: animation,
                            //     animationController: animationController!,
                            //   ),

                            Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.0, top: 5.0, left: 10.0, right: 2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        index == 1
                                            ? Text(
                                                'Near You',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
                                              )
                                            : Text(
                                                'Newly Vacant',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
                                              ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5.0),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor: Colors.grey.withOpacity(0.5),
                                              onTap: () {
                                                print(index == 1 ? 'View Near You' : 'View Newly Vacant');
                                              },
                                              child: Container(
                                                height: 37,
                                                width: 60,
                                                child: Center(
                                                  child: Text(
                                                    'View All',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 200.0,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 10,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 150.0,
                                                width: 200.0,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage('assets/hotel/apartment.jpg'),
                                                  ),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(15.0),
                                                    topRight: Radius.circular(15.0),
                                                    bottomRight: Radius.circular(15.0),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Container(
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            bottomRight: Radius.circular(15.0),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets.only(right: 5.0),
                                                              child: Icon(
                                                                Icons.star,
                                                                color: Colors.orange,
                                                                size: 10.0,
                                                              ),
                                                            ),
                                                            Text('4.0'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 180,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 35,
                                                      width: 50,
                                                      child: Text(
                                                        'Wilson Manor',
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 35,
                                                      width: 95,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Le 600 M / yr',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  }),
            ),
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
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              '${appBarTitles[selectedSection]}',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: sections.elementAt(selectedSection),
          bottomNavigationBar: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0.0, 1.0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 5.0,
                bottom: 10.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSection = 0;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.explore_sharp,
                            color: selectedSection == 0 ? Colors.red : Colors.black87,
                          ),
                          Text('Explore'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSection = 1;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.favorite_sharp,
                            color: selectedSection == 1 ? Colors.red : Colors.black87,
                          ),
                          Text('WishList'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSection = 2;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.notifications_sharp,
                            color: selectedSection == 2 ? Colors.red : Colors.black87,
                          ),
                          Text('Notifications'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSection = 3;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.person_sharp,
                            color: selectedSection == 3 ? Colors.red : Colors.black87,
                          ),
                          Text('Profile'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

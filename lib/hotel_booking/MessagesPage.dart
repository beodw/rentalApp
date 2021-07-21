import 'hotel_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:best_flutter_ui_templates/hotel_booking/model/message.dart';

class MessagesPage extends StatefulWidget {
  final String conversationUrl;
  const MessagesPage({Key? key, required this.conversationUrl}) : super(key: key);
  @override
  _MessagesPageScreenState createState() => _MessagesPageScreenState(conversationUrl: this.conversationUrl);
}

class _MessagesPageScreenState extends State<MessagesPage> {
  String conversationUrl;
  _MessagesPageScreenState({Key? key, required this.conversationUrl}) : super();
  //1. impl func to fetch arbitrary number of messages, initially 25, using index value to send to back end.
  //    0 is first message, 1 is the second and so on.
  //2. fill messages list with message objects using information from backend. Flutter will do the rendering automatically as the list grows.
  //3. add scroll listener in initState().
  //4. when at max scroll in pixels fetch more items, maybe another 25 and so on.
  //5. maybe if there are a lot of elements think about disposing messages when they are no longer on the screen.
  double startOfSwipe = 0.0;
  double endOfSwipe = 0.0;
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [
    for (int i = 0; i < 25; i++) Message(text: 'Hey', fromMe: false, received: false),
    Message(text: 'Sup Danielle', fromMe: true, received: false),
    Message(text: 'I\'m good', fromMe: false, received: false),
    Message(text: 'sd', fromMe: true, received: false),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SizedBox.expand(
        child: Column(children: <Widget>[
          getAppBarUI('Messages'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) {
                  setState(() {
                    this.startOfSwipe = details.globalPosition.dx.floorToDouble();
                  });
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    this.endOfSwipe = details.globalPosition.dx.floorToDouble();
                  });
                  if (this.startOfSwipe - this.endOfSwipe < -(HotelAppTheme.swipeEffort)) {
                    //if right swipe
                    Navigator.pop(context);
                  }
                },
                child: ListView.builder(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageBox(message: messages[index]);
                    }),
              ),
            ),
          ),
          ChatInputField(),
        ]),
      ),
    );
  }

  Widget getAppBarUI(String title) {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + HotelAppTheme.appBarPadding, left: 10, right: 10, bottom: HotelAppTheme.appBarPadding),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                      child: Icon(Icons.arrow_back_outlined),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$title',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Center(
                    child: Row(children: <Widget>[
                  InkWell(
                    child: Icon(Icons.more_vert),
                  ),
                ])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  Message message;
  MessageBox({required this.message});
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: message.fromMe ? MainAxisAlignment.end : MainAxisAlignment.start, children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(
          horizontal: 20 * 0.75,
          vertical: 20 / 2,
        ),
        decoration: BoxDecoration(
          color: HotelAppTheme.buildLightTheme().primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          '${message.text}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ]);
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 5),
        child: SafeArea(
          top: false,
          bottom: true,
          left: true,
          right: true,
          child: Row(
            children: [
              Icon(Icons.mic, color: Color(0xFF4E342E)),
              SizedBox(width: 20.0),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0 * 0.75,
                    vertical: 0.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF00BF6D).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.64),
                      ),
                      SizedBox(width: 20.0 / 4),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Type message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.attach_file,
                        color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.64),
                      ),
                      SizedBox(width: 20.0 / 4),
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.64),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

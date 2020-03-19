import 'package:Flutter_Push_Notification/env.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _initOneSignal();
    super.initState();
  }

  /// initialize setup oneSignal push notification
  void _initOneSignal() {
    OneSignal.shared.init(APP_ID_ONE_SIGNAL, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationReceivedHandler(_handleNotificationReceived);
  }

  /// handle retrieve notification
  void _handleNotificationReceived(OSNotification notification) {
    print('Notification Message = ${notification.payload.body}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Push Notification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () => _sendPushNotification(),
                child: Text(
                  'Send Push Notification',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Text(
                'Message : ',
                style: TextStyle(
                    color: Colors.black, fontSize: 20, letterSpacing: .50),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                _message,
                style: TextStyle(
                    fontSize: 18, color: Colors.black, letterSpacing: 0.3),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /// action push notification
  Future<void> _sendPushNotification() async {
    final status = await OneSignal.shared.getPermissionSubscriptionState();
    final playerId = status.subscriptionStatus.userId;
    final notification = OSCreateNotification(
        playerIds: [playerId],
        content: 'Flutter Push Notification',
        heading: "Notification");
    final response = await OneSignal.shared.postNotification(notification);
    setState(() => _message = "Status Response: $response");
  }
}

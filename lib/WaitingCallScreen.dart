import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newapp/VideoCallPage.dart';

class WaitingCallScreen extends StatefulWidget {
   // WaitingCallScreen({required this.connectingString});
   // String connectingString;

  @override
  State<WaitingCallScreen> createState() => _WaitingCallScreenState();
}

class _WaitingCallScreenState extends State<WaitingCallScreen> {
  bool _isActive = false;

  String? fetchedConnectingString;

  Future<void> getData() async {
    String url = 'https://jsonplaceholder.typicode.com/todos/1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String title = json['title'];
      fetchedConnectingString = title;
      print("fetchedConnectingString: $fetchedConnectingString" );
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception('Failed to fetch a connecting string. Make sure that your server URL is valid');
    }
  }

  Future<void> join() async {
    //await agoraEngine.startPreview(); // Uncomment if required
    channelName = fetchedConnectingString!; // Assuming fetchedConnectingString is not null here

    if (channelName.isEmpty) {
      print("Connecting string is empty.");
      return;
    } else {
      print("Fetching a token ...");
      await fetchToken(uid, channelName, tokenRole);
    }
  }

  void method() async
  {
    try {
      await getData();
      if (fetchedConnectingString != null && fetchedConnectingString!.isNotEmpty) {
        await join();
      } else {
        print("Connecting string not fetched or is empty.");
      }
    } on Exception catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    // super.initState();
    // try {
    //   await getData();
    //   if (fetchedConnectingString != null && fetchedConnectingString!.isNotEmpty) {
    //     await join();
    //   } else {
    //     print("Connecting string not fetched or is empty.");
    //   }
    // } on Exception catch (e) {
    //   print("Error fetching data: $e");
    // }
    method();
  }

  String token = '';
  String channelName = '';

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  String appId = 'aaff3a381e23485090d0ae05ddc8ada1';

  final _formKey = GlobalKey<FormState>();
  @override
  late final FocusNode _unfocusNode;

  String? _channelNameValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a channel name';
    } else if (value.length > 64) {
      return 'Channel name must be less than 64 characters';
    }
    return null;
  }

  bool _isCreatingChannel = false;


  bool _isMicEnabled = true;
  bool _isCameraEnabled = true;
  TextEditingController _channelNameController = TextEditingController();

  int uid = 0; // uid of the local user
  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  int tokenRole = 1; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience
  String serverUrl =
      "https://agora-token-service-production-01cc.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  int tokenExpireTime = 3600; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire
  final channelTextController =
  TextEditingController(text: ''); // To access the TextField

  //create an instance of the Agora engine
  Future<void> setupVideoSDKEngine() async {
    await [Permission.microphone, Permission.camera].request();
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: ''));
  }


  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}'; //?expiry=${tokenExpireTime.toString()}';

    // Send the request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      _isActive = true;
      setToken(newToken);
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }
  void setToken(String newToken) async {
    token = newToken;
    if (isTokenExpiring) {
      // Renew the token
      //agoraEngine.renewToken(token);
      isTokenExpiring = false;
      showMessage("Token renewed");
    } else {
      // Join a channel.
      showMessage("Token received, joining a channel...");
    }
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          surfaceTintColor: Colors.red,
          title: Text(
            'Random Video Call',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20,),
            Image.asset(
              'assets/images/videocallimage.png',
            ),
            Column(
              children: [
                LinearProgressIndicator(minHeight: 40,borderRadius: BorderRadius.circular(20),color: Colors.red,),
                SizedBox(height: 20,),
                Padding(
                  padding:  EdgeInsets.fromLTRB(0, 0, 0, 25),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoCallPage(token: token, channelName: channelName, isMicEnabled: true, isVideoEnabled: true),
                          ),
                        );
                      },
                      child: Text('Let\s go to Video Call Page'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String appId = "aaff3a381e23485090d0ae05ddc8ada1";

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String channelName = "";         //"VideoCalling";
  String token = "";         //"007eJxTYGg4dojXJY9L78X9tGgH7x/JhgkK39hTfRXmVOxev6+3c4MCQ2JiWppxorGFYaqRsYmFqYGlQYpBYqqBaUpKskViSqKhbp9xakMgI0Pf9GXMjAwQCOLzMIRlpqTmOyfm5GTmpTMwAAAcmyHx";
  int uid = 0; // uid of the local user
  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  int tokenRole = 1; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience
  String serverUrl = "https://agora-token-service-production-01cc.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  int tokenExpireTime = 45; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire
  final channelTextController = TextEditingController(text: '');// To access the TextField

  List<int> remoteUids = [];

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
        appId: appId
    ));

    await agoraEngine.enableVideo();
    await agoraEngine.muteLocalAudioStream(true);
    await agoraEngine.muteLocalVideoStream(false);
    //await agoraEngine.disableAudio();
    //await agoraEngine.enableAudio();

    // Register the event handler

    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(

        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },

        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
            remoteUids.add(remoteUid);
          });
        },


        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
            remoteUids.remove(remoteUid);
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          showMessage('Token expiring');
          isTokenExpiring = true;
          setState(() {
            // fetch a new token when the current token is about to expire
            fetchToken(uid, channelName, tokenRole);
          });
        },
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
  }

  // Release the resources when you leave
  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  void  join() async  {
    await agoraEngine.startPreview();
    channelName = channelTextController.text;

    if (channelName.isEmpty)
    {
      showMessage("Enter a channel name");
      return;
    }
    else
    {
      showMessage("Fetching a token ...");
    }

    await fetchToken(uid, channelName, tokenRole);
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url = '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}'; //?expiry=${tokenExpireTime.toString()}';

    // Send the request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200)
    {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      setToken(newToken);
    }
    else
    {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception('Failed to fetch a token. Make sure that your server URL is valid');
    }
  }
  void setToken(String newToken) async {
    token = newToken;
    if (isTokenExpiring) {
      // Renew the token
      agoraEngine.renewToken(token);
      isTokenExpiring = false;
      showMessage("Token renewed");
    } else {
      // Join a channel.
      showMessage("Token received, joining a channel...");
      // Set channel options including the client role and channel profile
      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );
      await agoraEngine.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: options,
      );
    }
  }

  Widget fourUserPreview()
  {
    return Container(
      width: double.infinity,
      height: 550,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 180,
                height: 250,
                color: Colors.red,
                child: AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: agoraEngine,
                    canvas: VideoCanvas(uid: remoteUids[0]),
                    connection: RtcConnection(channelId: channelName),
                  ),
                ),
              ),
              Container(
                width: 180,
                height: 250,
                color: Colors.red,
                child: AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: agoraEngine,
                    canvas: VideoCanvas(uid: remoteUids[1]),
                    connection: RtcConnection(channelId: channelName),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 180,
                height: 250,
                color: Colors.red,
                child: AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: agoraEngine,
                    canvas: VideoCanvas(uid: remoteUids[0]),
                    connection: RtcConnection(channelId: channelName),
                  ),
                ),
              ),
              Container(
                width: 180,
                height: 250,
                color: Colors.red,
                child: _localPreview(),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget threeUserPreview()
  {
    return   Container(
      width: double.infinity,
      height: 550,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 180,
                height: 290,
                color: Colors.red,
                child: AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: agoraEngine,
                    canvas: VideoCanvas(uid: remoteUids[0]),
                    connection: RtcConnection(channelId: channelName),
                  ),
                ),
              ),
              Container(
                width: 180,
                height: 290,
                color: Colors.red,
                child: AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: agoraEngine,
                    canvas: VideoCanvas(uid: remoteUids[1]),
                    connection: RtcConnection(channelId: channelName),
                  ),
                ),
              )

            ],
          ),
          Container(
            width: 250,
            height: 180,
            color: Colors.red,
            child: _localPreview(),
          )
        ],
      ),
    );
  }

  Widget twoUserPreview()
  {
    return Container(
      width: double.infinity,
      height: 550,
      color: Colors.black,
      child: Stack(
        children: [
          Container(
            color: Colors.green,
            child: AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: agoraEngine,
                canvas: VideoCanvas(uid: remoteUids[0]),
                connection: RtcConnection(channelId: channelName),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.yellow,
              width: 150,
              height: 180,
              child: _localPreview(),
            ),
          )
        ],
      ),
    );
  }



  // Display local user's video
  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }
  // Display remote user's video
  Widget _remoteVideo() {

    if (_remoteUid != null)
    {
      if(remoteUids.length == 1)
      {
        return twoUserPreview();
      }
      else if(remoteUids.length == 2)
      {
        return threeUserPreview();
      }
      else if(remoteUids.length == 3)
        {
          return fourUserPreview();
        }
    }
    else
    {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
      child: _localPreview(),
    );
  }


// Build UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //   title: const Text('Get started with Video Calling'),
            // ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // TextField(
                //   controller: channelTextController,
                //   decoration: const InputDecoration(
                //       hintText: 'Type the channel name here'),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Create Channel',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'enter the channel name which you want to join and then click on join button to join the channel.',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: true,
                    controller: channelTextController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Channel Name',
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: 'Enter your channel name...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF57636C),
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                    keyboardType: TextInputType.text,
                    //validator: _channelNameValidator,
                  ),
                ),
                _remoteVideo(),
                const SizedBox(height: 10),
                // Button Row
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isJoined ? null : () => {join()},
                        child: const Text("Join"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isJoined ? () => {leave()} : null,
                        child: const Text("Leave"),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}


//Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       height: 220,
//                       width: 150,
//                       decoration: BoxDecoration(border: Border.all()),
//                       child: Center(child: _localPreview()),
//                     ),
//                     Center(child: _remoteVideo(),
//                     ),
//                   ],
//                 )

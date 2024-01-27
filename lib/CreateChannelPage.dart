import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newapp/VideoCallPage.dart';


class createChannelPage extends StatefulWidget {
  const createChannelPage({super.key});

  @override
  State<createChannelPage> createState() => _createChannelPageState();
}


class _createChannelPageState extends State<createChannelPage> {
  String token ='';//= '007eJxTYDA7W/k9q2XnYcFl6UUz6vkO/NwreK7lyuo3tw0z+9SZwjwUGBIT09KME40tDFONjE0sTA0sDVIMElMNTFNSki0SUxINT1zakNoQyMjwxu88AyMUgvhcDEH5GZklwfl5mYYMDADB1CRW';
  String channelName = 'RohitSoni1';

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
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



  Future<void> _joinRoom() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).requestFocus(_unfocusNode);
    setState(() => _isCreatingChannel = true);
    final input = <String, dynamic>{
      'channelName': _channelNameController.text,
      'expiryTime': 3600, // 1 hour
    };

    try
    {
      //final response = await FirebaseFunctions.instance
         // .httpsCallable('generateToken')
          //.call(input);
      //final token = response.data as String?;
      if (token != null) {
        if (context.mounted) {
          // _showSnackBar(
          //   context,
          //   'Token generated successfully!',
          // );
        }
        await Future.delayed(
          const Duration(seconds: 1),
        );
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => PreJoiningDialog(
              channelName: channelTextController.text,
              token: token,
            ),
          );
        }
      }
    } catch (e) {
      // _showSnackBar(
      //   context,
      //   'Error generating token: $e',
      // );
    } finally {
      setState(() => _isCreatingChannel = false);
    }
  }



  bool _isMicEnabled = true;
  bool _isCameraEnabled = true;
  TextEditingController _channelNameController = TextEditingController();


  //appId = 'aaff3a381e23485090d0ae05ddc8ada1';
  //String channelName = "";
  //String token = "";         //"007eJxTYGg4dojXJY9L78X9tGgH7x/JhgkK39hTfRXmVOxev6+3c4MCQ2JiWppxorGFYaqRsYmFqYGlQYpBYqqBaUpKskViSqKhbp9xakMgI0Pf9GXMjAwQCOLzMIRlpqTmOyfm5GTmpTMwAAAcmyHx";
  int uid = 0; // uid of the local user
  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine;// Agora engine instance


  int tokenRole = 1; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience
  String serverUrl = "https://agora-token-service-production-01cc.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  int tokenExpireTime = 3600; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire
  final channelTextController = TextEditingController(text: '');// To access the TextField

  // final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
  // showMessage(String message) {
  //   scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
  //     content: Text(message),
  //   ));
  // }


  //create an instance of the Agora engine
  Future<void> setupVideoSDKEngine() async {
    await [Permission.microphone, Permission.camera].request();
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
        appId: ''
    ));
  }

  void  join() async  {
    //await agoraEngine.startPreview();
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
      //agoraEngine.renewToken(token);
      isTokenExpiring = false;
      showMessage("Token renewed");
    } else {
      // Join a channel.
      showMessage("Token received, joining a channel...");
      // Set channel options including the client role and channel profile
      // ChannelMediaOptions options = const ChannelMediaOptions(
      //   clientRoleType: ClientRoleType.clientRoleBroadcaster,
      //   channelProfile: ChannelProfileType.channelProfileCommunication,
      // );
      // await agoraEngine.joinChannel(
      //   token: token,
      //   channelId: channelName,
      //   uid: uid,
      //   options: options,
      // );
    }
  }





  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenSize.width,
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding:
                const EdgeInsetsDirectional.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          0.0,
                          30.0,
                          0.0,
                          8.0,
                        ),
                        child: Text(
                          'Create Channel',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.only(bottom: 24.0),
                        child: Text(
                          'Enter a channel name to generate token. The token will be valid for 1 hour.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
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
                          validator: _channelNameValidator,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text(
                          'For generating token for the call, Click on the join button and wait for five seconds then click Join Room Button',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: (){
                          join();
                        } ,//_joinRoom,
                        child: const Text('Generate'),
                      ),
                      const SizedBox(height: 24.0),
                      _isCreatingChannel
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [CircularProgressIndicator()],
                      )
                          : SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VideoCallPage(token: token,channelName: channelTextController.text,isMicEnabled: true,isVideoEnabled: true,)
                              ),
                            );
                          }, //_joinRoom,
                          child: const Text('Join Room'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class PreJoiningDialog extends StatefulWidget {
  const PreJoiningDialog({
    super.key,
    required this.token,
    required this.channelName,
  });

  final String token;
  final String channelName;

  @override
  State<PreJoiningDialog> createState() => _PreJoiningDialogState();
}

class _PreJoiningDialogState extends State<PreJoiningDialog> {
  bool _isMicEnabled = false;
  bool _isCameraEnabled = false;
  bool _isJoining = false;

  // Future<void> _getMicPermissions() async {
  //   if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
  //     final micPermission = await Permission.microphone.request();
  //     if (micPermission == PermissionStatus.granted) {
  //       setState(() => _isMicEnabled = true);
  //     }
  //   } else {
  //     setState(() => _isMicEnabled = !_isMicEnabled);
  //   }
  // }
  //
  // Future<void> _getCameraPermissions() async {
  //   if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
  //     final cameraPermission = await Permission.camera.request();
  //     if (cameraPermission == PermissionStatus.granted) {
  //       setState(() => _isCameraEnabled = true);
  //     }
  //   } else {
  //     setState(() => _isCameraEnabled = !_isCameraEnabled);
  //   }
  // }

     // Future<void> _getPermissions() async {
     // await _getMicPermissions();
    // await _getCameraPermissions();
    // }

  Future<void> _joinCall() async {
    setState(() => _isJoining = true);
    // await dotenv.load(fileName: "functions/.env");
    // final appId = dotenv.env['APP_ID'];
    // if (appId == null) {
    //   throw Exception('Please add your APP_ID to .env file');
    // }
    setState(() => _isJoining = false);
    if (context.mounted) {
      Navigator.of(context).pop();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoCallPage(
            //appId: appId,
            token: widget.token,
            channelName: widget.channelName,
            isMicEnabled: _isMicEnabled,
            isVideoEnabled: _isCameraEnabled,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    //_getPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 350.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Joining Call',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'You are about to join a video call. Please set you mic and camera preferences.',
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () {
                          if (_isMicEnabled) {
                            setState(() => _isMicEnabled = false);
                          } else {
                            //_getMicPermissions();
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          radius: 32.0,
                          child: Icon(
                            _isMicEnabled
                                ? Icons.mic_rounded
                                : Icons.mic_off_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Mic: ${_isMicEnabled ? 'On' : 'Off'}'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () {
                          if (_isCameraEnabled) {
                            setState(() => _isCameraEnabled = false);
                          } else {
                            //_getCameraPermissions();
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          radius: 32.0,
                          child: Icon(
                            _isCameraEnabled
                                ? Icons.videocam_rounded
                                : Icons.videocam_off_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Camera: ${_isCameraEnabled ? 'On' : 'Off'}'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120.0,
                    child: _isJoining
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: (){},
                      child: const Text('Join'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

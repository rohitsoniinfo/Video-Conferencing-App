import 'dart:io';
import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newapp/utils/AgoraUser.dart';
import 'package:newapp/Component/CallActionUi.dart';
import 'package:newapp/VideoLayout.dart' as VL;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({
    super.key,
    appId,
    required this.token,
    required this.channelName,
    required this.isMicEnabled,
    required this.isVideoEnabled,
  });

  final String appId = "";
  final String token;
  final String channelName;
  final bool isMicEnabled;
  final bool isVideoEnabled;


  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}


class _VideoCallPageState extends State<VideoCallPage> {
  late final RtcEngine _agoraEngine;
  late final _users = <AgoraUser>{};
  late double _viewAspectRatio;

  int? _currentUid = 0 ;

  bool _isMicEnabled = true;

  bool _isVideoEnabled = true;

  bool _isLocalMicEnabled = true;

  bool _isLocalVideoEnabled = true;

  int? _remoteUid;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<
      ScaffoldMessengerState>(); // Global key to access the scaffold
  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
  

  //Initialize the Agora RTC Engine
  Future<void> _initAgoraRtcEngine() async {
    //_agoraEngine = await RtcEngine.create(widget.appId);
    await [Permission.microphone, Permission.camera].request();
    _agoraEngine = createAgoraRtcEngine();

    // VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    // configuration.orientationMode = VideoOutputOrientationMode.Adaptative;
    // await _agoraEngine.setVideoEncoderConfiguration(configuration);
    // await _agoraEngine.enableAudio();
    // await _agoraEngine.enableVideo();
    // await _agoraEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // await _agoraEngine.setClientRole(ClientRole.Broadcaster);
    // await _agoraEngine.muteLocalAudioStream(!widget.isMicEnabled);
    // await _agoraEngine.muteLocalVideoStream(!widget.isVideoEnabled);

    await _agoraEngine.initialize(const RtcEngineContext(
        appId: ''
    ));
    //await _agoraEngine.enableLocalVideo(true);
    await _agoraEngine.enableVideo();
    //await _agoraEngine.muteLocalAudioStream(false);
    await _agoraEngine.muteLocalVideoStream(false);
    //await agoraEngine.disableAudio();
    await _agoraEngine.enableAudio();
    await _agoraEngine.enableLocalVideo(true);
    await _agoraEngine.startPreview();
  }

//Call Initialization Function
  Future<void> _initialize() async {
    // Set aspect ratio for video according to platform
    if (kIsWeb) {
      _viewAspectRatio = 3 / 2;
    }
    else if (Platform.isAndroid || Platform.isIOS) {
      _viewAspectRatio = 2 / 3;
    }
    else {
      _viewAspectRatio = 3 / 2;
    }
    // Initialize microphone and camera
    setState(() {
      _isMicEnabled = widget.isMicEnabled;
      _isVideoEnabled = widget.isVideoEnabled;
    });
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // final options = ChannelMediaOptions(
    //   // publishLocalAudio: _isMicEnabled,
    //   // publishLocalVideo: _isVideoEnabled,
    // );
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    // Join the channel
    // await _agoraEngine.joinChannel(
    //   widget.token,
    //   widget.channelName,
    //   null, // optionalInfo (unused)
    //   0, // User ID
    //   options,
    // );
    await _agoraEngine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: 0,
      options: options,
    );
  }


  @override
  void initState()
  {
    print("did you recieve token : " );
    print(widget.token);
    _initialize();
    super.initState();
  }
  //dispose agoara
  @override
  void dispose() {
    _users.clear();
    _disposeAgora();
    super.dispose();
  }

  Future<void> _disposeAgora() async {
    await _agoraEngine.leaveChannel();
    //await _agoraEngine.destroy();
    await _agoraEngine.release(sync: true);
  }


  //Setup Agora Event Handlers
  // void _addAgoraEventHandlers() => _agoraEngine.setEventHandler(
  void _addAgoraEventHandlers() =>
      _agoraEngine.registerEventHandler(
        RtcEngineEventHandler(
          onError: (ErrorCodeType, code) {
            final info = 'LOG::onError: $code';
            debugPrint(info);
          },
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            showMessage(
                "Local user uid:${connection.localUid} joined the channel");
            setState(() {
              _currentUid = connection.localUid;
              print("connection.localUid : ");
              print(connection.localUid);
              _users.add(
                AgoraUser(
                  uid: 0,
                  isAudioEnabled: _isLocalMicEnabled,
                  isVideoEnabled: _isLocalVideoEnabled,
                  view: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _agoraEngine,
                      canvas: VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              );
            });
          },

          //     firstLocalAudioFrame: (elapsed) {
          //       final info = 'LOG::firstLocalAudio: $elapsed';
          //       debugPrint(info);
          //       for (AgoraUser user in _users) {
          //         if (user.uid == _currentUid) {
          //           setState(() => user.isAudioEnabled = _isMicEnabled);
          //         }
          //       }
          //     },


          //     firstLocalVideoFrame: (width, height, elapsed) {
          //       debugPrint('LOG::firstLocalVideo');
          //       for (AgoraUser user in _users) {
          //         if (user.uid == _currentUid) {
          //           setState(
          //                 () => user
          //               ..isVideoEnabled = _isVideoEnabled
          //               ..view = const rtc_local_view.SurfaceView(
          //                 renderMode: VideoRenderMode.Hidden,
          //               ),
          //           );
          //         }
          //       }
          //     },


          //     leaveChannel: (stats) {
          //       debugPrint('LOG::onLeaveChannel');
          //       setState(() => _users.clear());
          //     },

          //     userJoined: (uid, elapsed) {
          //       final info = 'LOG::userJoined: $uid';
          //       debugPrint(info);
          //       setState(
          //             () => _users.add(
          //           AgoraUser(
          //             uid: uid,
          //             view: rtc_remote_view.SurfaceView(
          //               channelId: widget.channelName,
          //               uid: uid,
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            showMessage("Remote user uid:$remoteUid joined the channel");
            setState(() {
              _currentUid = remoteUid;
              print("printing remote uid : ");
              print(remoteUid);
              _users.add(
                AgoraUser(
                  uid: _currentUid!,
                  isAudioEnabled: _isMicEnabled,
                  isVideoEnabled: _isVideoEnabled,
                  view: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _agoraEngine,
                      canvas: VideoCanvas(uid: remoteUid),
                      connection: RtcConnection(
                          channelId: connection.channelId),
                    ),
                  ),
                ),
              );
            });
          },

          //     userOffline: (uid, elapsed) {
          //       final info = 'LOG::userOffline: $uid';
          //       debugPrint(info);
          //       AgoraUser? userToRemove;
          //       for (AgoraUser user in _users) {
          //         if (user.uid == uid) {
          //           userToRemove = user;
          //         }
          //       }
          //       setState(() => _users.remove(userToRemove));
          //     },

          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            showMessage("Remote user uid:$remoteUid left the channel");
            setState(() {
              _remoteUid = remoteUid;
              print("length of _users before removing: ");
              print(_users.length);
              _users.removeWhere((element) => element.uid == remoteUid);
              print("length of _users after removing: ");
              print(_users.length);
            });
          },
          //     firstRemoteAudioFrame: (uid, elapsed) {
          //       final info = 'LOG::firstRemoteAudio: $uid';
          //       debugPrint(info);
          //       for (AgoraUser user in _users) {
          //         if (user.uid == uid) {
          //           setState(() => user.isAudioEnabled = true);
          //         }
          //       }
          //     },


          //     firstRemoteVideoFrame: (uid, width, height, elapsed) {
          //       final info = 'LOG::firstRemoteVideo: $uid ${width}x $height';
          //       debugPrint(info);
          //       for (AgoraUser user in _users) {
          //         if (user.uid == uid) {
          //           setState(
          //                 () => user
          //               ..isVideoEnabled = true
          //               ..view = rtc_remote_view.SurfaceView(
          //                 channelId: widget.channelName,
          //                 uid: uid,
          //               ),
          //           );
          //         }
          //       }
          //     },


          //     remoteVideoStateChanged: (uid, state, reason, elapsed) {
          //       final info = 'LOG::remoteVideoStateChanged: $uid $state $reason';
          //       debugPrint(info);
          //       for (AgoraUser user in _users) {
          //         if (user.uid == uid) {
          //           setState(() =>
          //           user.isVideoEnabled = state != VideoRemoteState.Stopped);
          //         }
          //       }
          //     },


          //     remoteAudioStateChanged: (uid, state, reason, elapsed) {
          //       final info = 'LOG::remoteAudioStateChanged: $uid $state $reason';
          //       debugPrint(info);
          //       for (AgoraUser user in _users) {
          //         if (user.uid == uid) {
          //           setState(() =>
          //           user.isAudioEnabled = state != AudioRemoteState.Stopped);
          //         }
          //       }
          //     },

        ),
      );


  Future<void> _onCallEnd(BuildContext context) async {
    await _agoraEngine.leaveChannel();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onToggleAudio() {
    setState(() {
      _isLocalMicEnabled = !_isLocalMicEnabled;
      for (AgoraUser user in _users) {
        if (user.uid == 0) { //_currentUid
          user.isAudioEnabled = _isLocalMicEnabled;
        }
      }
    });
    _agoraEngine.muteLocalAudioStream(!_isLocalMicEnabled);
  }

  void _onToggleCamera() {
    setState(() {
      _isLocalVideoEnabled = !_isLocalVideoEnabled;
      for (AgoraUser user in _users) {
        if (user.uid == 0) {//_currentUid
          print("user.uid : ");
          print(user.uid);
          print("_currentUid : ");
          print(_currentUid);
          setState(() => user.isVideoEnabled = _isLocalVideoEnabled);

        }
      }
    });
    _agoraEngine.muteLocalVideoStream(!_isVideoEnabled);
  }

  void _onSwitchCamera() => _agoraEngine.switchCamera();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.black,
            centerTitle: false,
            title: Row(
              children: [
                const Icon(
                  Icons.meeting_room_rounded,
                  color: Colors.white54,
                ),
                const SizedBox(width: 6.0),
                const Text(
                  'Channel name: ',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  widget.channelName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people_alt_rounded,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      _users.length.toString(),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OrientationBuilder(
                      builder: (context, orientation) {
                        final isPortrait = orientation == Orientation.portrait;
                        if (_users.isEmpty) {
                          return const SizedBox();
                        }
                        WidgetsBinding.instance.addPostFrameCallback(
                              (_) =>
                              setState(
                                      () =>
                                  _viewAspectRatio =
                                  isPortrait ? 2 / 3 : 3 / 2),
                        );
                        final layoutViews = _createLayout(_users.length);
                        return VL.AgoraVideoLayout(
                          users: _users,
                          views: layoutViews,
                          viewAspectRatio: _viewAspectRatio,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CallActionsRow(
                    isMicEnabled: _isLocalMicEnabled,
                    isVideoEnabled: _isLocalVideoEnabled,
                    onCallEnd: () => _onCallEnd(context),
                    onToggleAudio: _onToggleAudio,
                    onToggleCamera: _onToggleCamera,
                    onSwitchCamera: _onSwitchCamera,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  List<int> _createLayout(int n) {
    int rows = (sqrt(n).ceil());
    int columns = (n / rows).ceil();

    List<int> layout = List<int>.filled(rows, columns);
    int remainingScreens = rows * columns - n;

    for (int i = 0; i < remainingScreens; i++) {
      layout[layout.length - 1 - i] -= 1;
    }
    return layout;
  }
}

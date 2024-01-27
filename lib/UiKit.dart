import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

const appId = 'aaff3a381e23485090d0ae05ddc8ada1';
String channelName = "VideoCalling";
String token = "007eJxTYGg4dojXJY9L78X9tGgH7x/JhgkK39hTfRXmVOxev6+3c4MCQ2JiWppxorGFYaqRsYmFqYGlQYpBYqqBaUpKskViSqKhbp9xakMgI0Pf9GXMjAwQCOLzMIRlpqTmOyfm5GTmpTMwAAAcmyHx";
int uid = 0; // uid of the local user

void main() {
  runApp(UiKit());
}

class UiKit extends StatefulWidget {
  const UiKit({Key? key}) : super(key: key);

  @override
  State<UiKit> createState() => _UiKitState();
}

class _UiKitState extends State<UiKit> {

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: channelName,
      tempToken: token,
      uid: uid,
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

//Build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agora UI Kit'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
              ),
              AgoraVideoButtons(
                client: client,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

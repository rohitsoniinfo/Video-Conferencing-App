import 'package:flutter/material.dart';

class CallActionButton extends StatelessWidget {
  const CallActionButton({
    super.key,
    this.onTap,
    required this.icon,
    this.callEnd = false,
    this.isEnabled = true,
  });

  final Function()? onTap;
  final IconData icon;
  final bool callEnd;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: callEnd
            ? Colors.redAccent
            : isEnabled
            ? Colors.grey.shade800
            : Colors.white,
        radius: callEnd ? 28 : 24,
        child: Icon(
          icon,
          size: callEnd ? 26 : 22,
          color: callEnd
              ? Colors.white
              : isEnabled
              ? Colors.white
              : Colors.grey.shade600,
        ),
      ),
    );
  }
}
class CallActionsRow extends StatelessWidget {
  const CallActionsRow({
    super.key,
    required this.isMicEnabled,
    required this.isVideoEnabled,
    required this.onCallEnd,
    required this.onToggleAudio,
    required this.onToggleCamera,
    required this.onSwitchCamera,
  });

  final bool isMicEnabled;
  final bool isVideoEnabled;
  final Function()? onCallEnd;
  final Function()? onToggleAudio;
  final Function()? onToggleCamera;
  final Function()? onSwitchCamera;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CallActionButton(
            callEnd: true,
            icon: Icons.call_end,
            onTap: onCallEnd,
          ),
          CallActionButton(
            icon: isMicEnabled ? Icons.mic : Icons.mic_off,
            isEnabled: isMicEnabled,
            onTap: onToggleAudio,
          ),
          CallActionButton(
            icon: isVideoEnabled
                ? Icons.videocam_rounded
                : Icons.videocam_off_rounded,
            isEnabled: isVideoEnabled,
            onTap: onToggleCamera,
          ),
          CallActionButton(
            icon: Icons.cameraswitch_rounded,
            onTap: onSwitchCamera,
          ),
        ],
      ),
    );
  }
}

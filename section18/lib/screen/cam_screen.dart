import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine;

  // 나의 ID
  int? uid = 0;

  // 상대 ID
  int? otherUid;

  @override
  void dispose() async {

    if(engine != null){
      await engine!.leaveChannel(
        options: const LeaveChannelOptions(),
      );

      engine!.release();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIVE'),
      ),
      body: FutureBuilder<Object>(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      renderMainView(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          color: Colors.grey,
                          height: 160,
                          width: 120,
                          child: renderSubView(),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (engine != null) {
                        await engine!.leaveChannel();
                        engine = null;
                      }
                    },
                    child: const Text('채널 나가기'),
                  ),
                ),
              ],
            );
          }),
    );
  }

  renderMainView() {
    if (uid == null) {
      return const Center(
        child: Text(
          '채널에 참여해주세요.',
        ),
      );
    } else {
      // 채널에 참여하고 있을때
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine!,
          canvas: const VideoCanvas(
            uid: 0,
          ),
        ),
      );
    }
  }

  renderSubView() {
    if (otherUid == null) {
      return const Center(
        child: Text(
          '채널에 유저가 없습니다.',
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: engine!,
        canvas: VideoCanvas(
          uid: otherUid,
        ),
        connection: const RtcConnection(
          channelId: 'CHANNEL_ID',
        ),
      ),
    );
  }

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final microphonePermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        microphonePermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다.';
    }

    if (engine == null) {
      engine = createAgoraRtcEngine();

      await engine!.initialize(
        const RtcEngineContext(
          appId: 'APP_ID',
        ),
      );

      engine!.registerEventHandler(
        RtcEngineEventHandler(
          // onJoinChannelSuccess - 내가 채널에 입장했을 때
          // connection - 연결 정보
          // elapsed - 연결된 시간 (연결된지 얼마나 지났나)
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            setState(() {
              uid = connection.localUid;
            });
          },

          // onLeaveChannel - 내가 채널에서 나갔을 때
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            setState(() {
              uid = null;
            });
          },

          // onUserJoined - 상대방이 들어왔을 때
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            setState(() {
              otherUid = remoteUid;
            });
          },

          // onUserOffline - 상대방이 나갔을 때
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            setState(() {
              otherUid = null;
            });
          },
        ),
      );

      // 카메라 시작
      await engine!.enableVideo();

      // 핸드폰으로 송출 시작
      await engine!.startPreview();

      ChannelMediaOptions options = const ChannelMediaOptions();
      await engine!.joinChannel(
        token: 'TOKEN',
        channelId: 'CHANNEL_ID',
        uid: 0,
        options: options,
      );
    }

    return true;
  }
}

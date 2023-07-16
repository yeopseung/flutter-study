import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:section15/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: video == null ? renderEmpty(context) : renderVideo());
  }

  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
        video: video!,
        onNewVideoPressed: onNewVideoPressed,
      ),
    );
  }

  Widget renderEmpty(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(onNewVideoPressed),
          const SizedBox(
            // Image 와 Row 사이의 간격 표현
            // Padding 말고 SizedBox를 쓰는 경우도 많음
            height: 30.0,
          ),
          const _AppName(),
        ],
      ),
    );
  }

  void onNewVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }

  // 다음과 같이 위젯으로 만들 수 없는 것은 변수 or 함수로 만드는게 좋다
  BoxDecoration getBoxDecoration() {
    return const BoxDecoration(
      // 그라데이션 효과
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A3A7C),
            Color(0xFF000118),
          ]),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;

  const _Logo(this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'asset/image/logo.png',
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  final textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 30.0,
    fontWeight: FontWeight.w300,
  );

  const _AppName();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Video',
          style: textStyle,
        ),
        Text(
          'Player',
          style: textStyle.copyWith(
            // 기존 style에서 굵기만 덮어 씌우기
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

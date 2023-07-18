import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool attendanceDone = false;
  GoogleMapController? mapController;

  // latitude - 위도, longitude - 경도
  static final LatLng companyLatLng = const LatLng(
    37.5233273,
    126.921252,
  );

  static final double okDistance = 100;
  static final Circle withinDistanceCircle = Circle(
    // 원 ID
    circleId: CircleId('circle'),
    // 원 중앙 좌표
    center: companyLatLng,
    // 원 색
    fillColor: Colors.blue.withOpacity(0.5),
    // 원 반지름 (반경), meter 단위
    radius: okDistance,
    // 테두리 색
    strokeColor: Colors.blue,
    // 테두리 두께
    strokeWidth: 1,
  );

  static final Circle notWithinDistanceCircle = Circle(
    // 원 ID
    circleId: CircleId('circle'),
    // 원 중앙 좌표
    center: companyLatLng,
    // 원 색
    fillColor: Colors.red.withOpacity(0.5),
    // 원 반지름 (반경), meter 단위
    radius: okDistance,
    // 테두리 색
    strokeColor: Colors.red,
    // 테두리 두께
    strokeWidth: 1,
  );

  static final Circle checkDoneCircle = Circle(
    // 원 ID
    circleId: CircleId('circle'),
    // 원 중앙 좌표
    center: companyLatLng,
    // 원 색
    fillColor: Colors.green.withOpacity(0.5),
    // 원 반지름 (반경), meter 단위
    radius: okDistance,
    // 테두리 색
    strokeColor: Colors.green,
    // 테두리 두께
    strokeWidth: 1,
  );

  static final Marker marker = Marker(
    markerId: MarkerId('marker'),
    position: companyLatLng,
  );

  static final CameraPosition initialPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        // future - Future를 리턴해주는 어떤 함수든 넣을 수 있음
        future: checkPermission(),
        // builder - Future 함수의 상태가 변경 될 때 마다 builder를 다시 실행하여 화면을 업데이트
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // connectionState - future 함수에 따른 State
          // - none - future parameter를 안썼을 때
          // - waiting - future가 로딩중일 때
          // - done - future 함수가 실행이 끝났을 때
          // print(snapshot.connectionState);

          // data - future 함수 실행 결과물
          // print(snapshot.data);

          // waiting일 때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 허가되었을 때 - 구글맵 보여주기
          if (snapshot.data == '위치 권한이 허가되었습니다.') {
            return StreamBuilder<Position>(
                // 기능은 FutureBuilder와 거의 비슷
                // stream - Future를 리턴해주는 어떤 함수든 넣을 수 있음
                // getPositionStream() - 위치가 변경될 경우 Position 리턴
                stream: Geolocator.getPositionStream(),
                // builder - Future 함수의 상태가 변경 될 때 마다 builder를 다시 실행하여 화면을 업데이트
                builder: (context, snapshot) {
                  // connectionState - future 함수에 따른 State
                  // - none - future parameter를 안썼을 때
                  // - waiting - future가 로딩중일 때
                  // - done - future 함수가 실행이 끝났을 때
                  // print(snapshot.connectionState);

                  // data - future 함수 실행 결과물
                  // print(snapshot.data);

                  bool isWithinRange = false;

                  if (snapshot.hasData) {
                    // 현 위치
                    final start = snapshot.data!;
                    // 회사 위치
                    final end = companyLatLng;

                    // 두 거리의 차
                    final distance = Geolocator.distanceBetween(start.latitude,
                        start.longitude, end.latitude, end.longitude);

                    // 두 거리의 차이가 100m 안일 경우 - 반경 안에 존재
                    if (distance < okDistance) {
                      isWithinRange = true;
                    }
                  }

                  return Column(
                    children: [
                      _CustomGoogleMap(
                        initialPosition: initialPosition,
                        // Bad Code
                        circle: attendanceDone
                            ? checkDoneCircle
                            : isWithinRange
                                ? withinDistanceCircle
                                : notWithinDistanceCircle,
                        marker: marker,
                        onMapCreated: onMapCreated,
                      ),
                      _AttendanceButton(
                        isWithinRange: isWithinRange,
                        attendanceDone: attendanceDone,
                        onPressed: onAttendancePressed,
                      ),
                    ],
                  );
                });
          }

          // 그 외 - 에러 문구
          return Center(
            child: Text(snapshot.data),
          );
        },
      ),
    );
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  onAttendancePressed() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('출근하기'),
          content: Text('출근을 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('출근하기'),
            ),
          ],
        );
      },
    );

    if (result) {
      setState(() {
        attendanceDone = true;
      });
    }
  }

  // 권한 확인 메소드
  Future<String> checkPermission() async {
    // 디바이스 위치서비스 온/오프 여부
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요.';
    }

    // 현재 앱이 가지고 있는 위치서비스 권한을 LocationPermission 형태로 리턴
    LocationPermission checkedPermission = await Geolocator.checkPermission();

    // denied - 기본값(앱 처음 실행 상태), 거부 -> 요청 가능
    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가 해주세요.';
      }
    }

    // deniedForever - 항상 거부, 요청을 거부했을 때 -> 더이상 요청 불가, 사용자가 직접 설정해야함
    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 세팅에서 허가해주세요.';
    }

    // whileInUse - 앱을 사용할 때만 허용
    // always - 항상 허용
    return '위치 권한이 허가되었습니다.';
  }

  AppBar renderAppBar() {
    return AppBar(
      title: Text(
        '오늘도 출근',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            if (mapController == null) {
              return;
            }

            final location = await Geolocator.getCurrentPosition();

            mapController!.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  location.latitude,
                  location.longitude,
                ),
              ),
            );
          },
          color: Colors.blue,
          icon: Icon(Icons.my_location),
        ),
      ],
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final Circle circle;
  final Marker marker;
  final MapCreatedCallback onMapCreated;

  const _CustomGoogleMap(
      {super.key,
      required this.initialPosition,
      required this.circle,
      required this.marker,
      required this.onMapCreated});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: Set.from([circle]),
        markers: Set.from([marker]),
        onMapCreated: onMapCreated,
      ),
    );
  }
}

class _AttendanceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isWithinRange;
  final bool attendanceDone;

  const _AttendanceButton(
      {super.key,
      required this.isWithinRange,
      required this.onPressed,
      required this.attendanceDone});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timelapse_outlined,
            size: 50.0,
            // Bad Code
            color: attendanceDone
                ? Colors.green
                : isWithinRange
                    ? Colors.blue
                    : Colors.red,
          ),
          const SizedBox(
            height: 20.0,
          ),
          if (!attendanceDone && isWithinRange)
            TextButton(
              onPressed: onPressed,
              child: Text('출근하기'),
            ),
        ],
      ),
    );
  }
}

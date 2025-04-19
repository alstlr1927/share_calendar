import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/common/components/snack_bar/couple_noti.dart';
import 'package:couple_calendar/ui/my_schedule/model/schedule_model.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final ScheduleTheme theme;

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.theme,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late LatLng _location;
  void setLocation(LatLng latLng) => _location = latLng;

  GoogleMapController? _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> onClickMyLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      LatLng myLatLng = LatLng(position.latitude, position.longitude);

      _goToLocation(myLatLng);
    } else {
      CoupleNotification().notify(title: '위치 권한이 필용합니다.');
    }
  }

  void onClickScheduleLocation() {
    _goToLocation(_location);
  }

  Future<void> _goToLocation(LatLng latLng) async {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 14)));
  }

  @override
  void initState() {
    super.initState();
    _location = LatLng(widget.latitude, widget.longitude);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _location,
            zoom: 14.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId('destination'),
              position: _location,
            ),
          },
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer()),
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 10.toWidth, right: 10.toWidth),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _moveButton(title: '내 위치', onPressed: onClickMyLocation),
                SizedBox(width: 4.toWidth),
                _moveButton(title: '일정 위치', onPressed: onClickScheduleLocation),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _moveButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    return BaseButton(
      onPressed: onPressed,
      child: Container(
        width: 60.toWidth,
        height: 30.toWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: CoupleStyle.elevation_03dp(),
          color: widget.theme.backColor,
          // border: Border.all(width: .5, color: widget.theme.textColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: CoupleStyle.caption(color: widget.theme.textColor),
        ),
      ),
    );
  }
}

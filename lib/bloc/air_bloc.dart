import 'package:http/http.dart' as http;
import 'package:yes2day/models/airResult.dart';

import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:rxdart/rxdart.dart';

class AirBloc{

  final _airSubject = BehaviorSubject<airResult>();

  /// 생성자
  AirBloc(){
    fetch();
  }

  /// api에서 받아온 값
  final todayDate = formatDate(DateTime.now(), [yyyy, mm, dd]);
  final todayTime = formatDate(DateTime.now(), [HH]);
  final yesterdayDate = formatDate(DateTime.now().subtract(new Duration(days: 1)), [yyyy,mm,dd]);

  /// api 통신
  Future<airResult> fetchData() async {
    String time;
    String date;
    if (int.parse(todayTime) < 5) {
      date = yesterdayDate;
      time = '23';
    } else if (int.parse(todayTime) < 8) {
      date = todayDate;
      time = '05';
    } else if (int.parse(todayTime) < 11) {
      date = todayDate;
      time = '08';
    } else if (int.parse(todayTime) < 14) {
      date = todayDate;
      time = '11';
    } else if (int.parse(todayTime) < 17) {
      date = todayDate;
      time = '14';
    } else if (int.parse(todayTime) < 20) {
      date = todayDate;
      time = '17';
    } else if (int.parse(todayTime) < 23) {
      date = todayDate;
      time = '20';
    } else {
      date = todayDate;
      time = '23';
    }
    var res = await http.get(
        'http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?serviceKey=t8fSG6VMjHWbMqMp4FF1ADShu3zL%2BeGZAA5ZyySE1Cl%2BIjLNUkHpV2R3EG%2BuhWYtBmaotmiFfianggGhGTfTWQ%3D%3D&pageNo=1&numOfRows=10&dataType=JSON&base_date=${date}&base_time=${time}00&nx=1&ny=1');
    airResult result = airResult.fromJson(json.decode(res.body));
    print('현재 출력 데이터는 ${date}, ${time} 기준입니다.');
    return result;
  }

  void fetch() async {
    var AirResult = await fetchData();
    _airSubject.add(AirResult);
  }

  Stream<airResult> get result => _airSubject.stream;
}

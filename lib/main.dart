import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:date_format/date_format.dart';
import 'package:yes2day/bloc/air_bloc.dart';
import 'package:yes2day/models/airResult.dart';


void main() => runApp(MyApp());

final airBloc = AirBloc();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.blueAccent,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var position;

  void _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    this.position = position;
    setState(() {
      _position = position;
    });
  }

  Geolocator _geolocator;
  Position _position;

  /// ios Permission
  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }





  @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
//    checkPermission();
//    _getCurrentLocation();
//    fetchData().then((airResult) {
//      setState(() {
//        _result = airResult;
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    /// 현재시간
    final currentDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    final currentTime = formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.looks)),
              Tab(icon: Icon(Icons.directions_run)),
              Tab(icon: Icon(Icons.directions_bike))
            ],
          ),
        ),
        body: StreamBuilder<airResult>(
          stream: airBloc.result,
          builder: (context, _result) {
            return _result.data == null
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          '현재 날씨 및 미세먼지',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Text('현재시간 : ${currentDate} ${currentTime}'),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          child: Container(
                            color: _getColor(_result.data),
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      int.parse(_result.data.response.body
                                          .items.item[0].fcstValue) <=
                                          5 ? Icon(Icons.wb_sunny,size: 50,) : (int.parse(_result.data.response.body.items
                                          .item[0].fcstValue)>=61 ? Icon(Icons.cloud_queue):Icon(Icons.cloud)),
                                      Text(
                                          '강수확률 : ${_result.data.response.body.items
                                              .item[0].fcstValue}%'),
//                                        Icon(getWeather(_result)),
//                                  Icon(int.parse(_result.response.body
//                                      .items.item[0].fcstValue) <=
//                                      5
//                                      ? Icons.wb_sunny
//                                      : Icons.cloud),

//                                  _getWeather(_result),
                                      Text(
                                          '풍속 : ${_result.data.response.body.items
                                              .item[8].fcstValue}m/s'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                          '기온 : ${_result.data.response.body.items
                                              .item[4].fcstValue}℃'),
                                      Text(
                                          '습도 : ${_result.data.response.body.items
                                              .item[2].fcstValue}%'),
                                      Text('item6'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        child: Text('Alert Button'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('This is a new ssorry_choi app'),
                                  content: Text('오케이~'),
                                  actions: [
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('CANCEL'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                      RaisedButton(
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        child: Text('Im here'),
                        onPressed: () {
                          checkPermission();
                          _getCurrentLocation();
                          airBloc.fetch();
                        },
                      ),
                      Container(
                          child: Text(
                              'Latitude: ${_position != null ? _position.latitude
                                  .toString() : '0'},'
                                  ' Longitude: ${_position != null ? _position
                                  .longitude.toString() : '0'}'))
                    ],
                  ),
                ),
                Container(
                 decoration: BoxDecoration(
                   image: DecorationImage(
                     image: NetworkImage('https://cdn.pixabay.com/photo/2017/05/25/15/08/jogging-2343558_960_720.jpg'),
                     fit: BoxFit.cover
                   ),
                 ),
                  child: Center(child: Padding(
                    padding: const EdgeInsets.only(bottom: 130),
                    child: Text('Running',style: TextStyle(color: Colors.white,fontSize: 50,fontWeight: FontWeight.bold),),
                  ),),
                ),
                Center(child: Text('Bike')),
              ],
            );
          }
        ),
      ),
    );
  }

  Color _getColor(airResult result) {
    if(int.parse(result.response.body.items.item[0].fcstValue)<30){
      return Colors.lightBlueAccent;
    }else if((int.parse(result.response.body.items.item[0].fcstValue)<60)){
      return Colors.white30;
    }else {
      return Colors.black26;
    }
  }

}

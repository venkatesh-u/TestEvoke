import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'dart:developer' as developer;
part 'chargePoints.g.dart';



@JsonSerializable()
class Connector {
  Connector({
    this.available ,
    this.occupied  ,
    this.offline   ,
    this.price     

  });

  factory Connector.fromJson(Map<String, dynamic> json) => _$ConnectorFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectorToJson(this);

  final int    available ;
  final int    occupied  ;
  final int    offline   ;
  final double price     ;
}

@JsonSerializable()
class ChargePoint {
  ChargePoint({
    this.chargePointID ,
    this.description   ,
    this.lat           ,
    this.lon           ,
    this.connectors
  });

  factory ChargePoint.fromJson(Map<String, dynamic> json) => _$ChargePointFromJson(json);
  Map<String, dynamic> toJson() => _$ChargePointToJson(this);

  final String chargePointID ;
  final String description   ;
  final double lat           ;
  final double lon           ;
  final Map<String,Connector> connectors;
}


Future<List<ChargePoint>> getChargePoints() async {

  const cpSearchURL ='https://dev1-api.evokesystems.net:9443/api/v1/public/searchCPs?lat1=1000&lat2=-1000&lon1=1000&lon2=-1000';

  // Retrieve the locations of Google ChargePoints
  final response = await http.get(cpSearchURL,headers:{'Accept':'application/json'});
  print('datasss response: $response');
   developer.log('log me', name: 'my.app.category');
  if (response.statusCode == 200) {
    var stuff= response.body;
    var myThing =  (jsonDecode(stuff) as List).map((e) => new ChargePoint.fromJson(e)).toList();
    print('Response: ${myThing}');
    return myThing;
  } else {
    print("Response: Fail"+ response.statusCode.toString());
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(cpSearchURL));
  }
}

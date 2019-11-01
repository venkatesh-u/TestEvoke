// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chargePoints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connector _$ConnectorFromJson(Map<String, dynamic> json) {
  return Connector(
      available: json['available'] as int,
      occupied: json['occupied'] as int,
      offline: json['offline'] as int,
      price: (json['price'] as num)?.toDouble());
}

Map<String, dynamic> _$ConnectorToJson(Connector instance) => <String, dynamic>{
      'available': instance.available,
      'occupied': instance.occupied,
      'offline': instance.offline,
      'price': instance.price
    };

ChargePoint _$ChargePointFromJson(Map<String, dynamic> json) {
  return ChargePoint(
      chargePointID: json['chargePointID'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num)?.toDouble(),
      lon: (json['lon'] as num)?.toDouble(),
      connectors: (json['connectors'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k,
            e == null ? null : Connector.fromJson(e as Map<String, dynamic>)),
      ));
}

Map<String, dynamic> _$ChargePointToJson(ChargePoint instance) =>
    <String, dynamic>{
      'chargePointID': instance.chargePointID,
      'description': instance.description,
      'lat': instance.lat,
      'lon': instance.lon,
      'connectors': instance.connectors
    };

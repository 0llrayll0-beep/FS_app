part of 'example.dart';

class ListLicensePlateScansVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListLicensePlateScansVariablesBuilder(this._dataConnect, );
  Deserializer<ListLicensePlateScansData> dataDeserializer = (dynamic json)  => ListLicensePlateScansData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListLicensePlateScansData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListLicensePlateScansData, void> ref() {
    
    return _dataConnect.query("ListLicensePlateScans", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListLicensePlateScansLicensePlateScans {
  final String id;
  final String plateNumber;
  final Timestamp scanDate;
  ListLicensePlateScansLicensePlateScans.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  plateNumber = nativeFromJson<String>(json['plateNumber']),
  scanDate = Timestamp.fromJson(json['scanDate']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLicensePlateScansLicensePlateScans otherTyped = other as ListLicensePlateScansLicensePlateScans;
    return id == otherTyped.id && 
    plateNumber == otherTyped.plateNumber && 
    scanDate == otherTyped.scanDate;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, plateNumber.hashCode, scanDate.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['plateNumber'] = nativeToJson<String>(plateNumber);
    json['scanDate'] = scanDate.toJson();
    return json;
  }

  ListLicensePlateScansLicensePlateScans({
    required this.id,
    required this.plateNumber,
    required this.scanDate,
  });
}

@immutable
class ListLicensePlateScansData {
  final List<ListLicensePlateScansLicensePlateScans> licensePlateScans;
  ListLicensePlateScansData.fromJson(dynamic json):
  
  licensePlateScans = (json['licensePlateScans'] as List<dynamic>)
        .map((e) => ListLicensePlateScansLicensePlateScans.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLicensePlateScansData otherTyped = other as ListLicensePlateScansData;
    return licensePlateScans == otherTyped.licensePlateScans;
    
  }
  @override
  int get hashCode => licensePlateScans.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['licensePlateScans'] = licensePlateScans.map((e) => e.toJson()).toList();
    return json;
  }

  ListLicensePlateScansData({
    required this.licensePlateScans,
  });
}


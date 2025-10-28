part of 'example.dart';

class UpdateVehicleInfoVariablesBuilder {
  String id;
  Optional<String> _color = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateVehicleInfoVariablesBuilder color(String? t) {
   _color.value = t;
   return this;
  }

  UpdateVehicleInfoVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateVehicleInfoData> dataDeserializer = (dynamic json)  => UpdateVehicleInfoData.fromJson(jsonDecode(json));
  Serializer<UpdateVehicleInfoVariables> varsSerializer = (UpdateVehicleInfoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateVehicleInfoData, UpdateVehicleInfoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateVehicleInfoData, UpdateVehicleInfoVariables> ref() {
    UpdateVehicleInfoVariables vars= UpdateVehicleInfoVariables(id: id,color: _color,);
    return _dataConnect.mutation("UpdateVehicleInfo", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateVehicleInfoVehicleInfoUpdate {
  final String id;
  UpdateVehicleInfoVehicleInfoUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateVehicleInfoVehicleInfoUpdate otherTyped = other as UpdateVehicleInfoVehicleInfoUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateVehicleInfoVehicleInfoUpdate({
    required this.id,
  });
}

@immutable
class UpdateVehicleInfoData {
  final UpdateVehicleInfoVehicleInfoUpdate? vehicleInfo_update;
  UpdateVehicleInfoData.fromJson(dynamic json):
  
  vehicleInfo_update = json['vehicleInfo_update'] == null ? null : UpdateVehicleInfoVehicleInfoUpdate.fromJson(json['vehicleInfo_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateVehicleInfoData otherTyped = other as UpdateVehicleInfoData;
    return vehicleInfo_update == otherTyped.vehicleInfo_update;
    
  }
  @override
  int get hashCode => vehicleInfo_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (vehicleInfo_update != null) {
      json['vehicleInfo_update'] = vehicleInfo_update!.toJson();
    }
    return json;
  }

  UpdateVehicleInfoData({
    this.vehicleInfo_update,
  });
}

@immutable
class UpdateVehicleInfoVariables {
  final String id;
  late final Optional<String>color;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateVehicleInfoVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    color = Optional.optional(nativeFromJson, nativeToJson);
    color.value = json['color'] == null ? null : nativeFromJson<String>(json['color']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateVehicleInfoVariables otherTyped = other as UpdateVehicleInfoVariables;
    return id == otherTyped.id && 
    color == otherTyped.color;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, color.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(color.state == OptionalState.set) {
      json['color'] = color.toJson();
    }
    return json;
  }

  UpdateVehicleInfoVariables({
    required this.id,
    required this.color,
  });
}


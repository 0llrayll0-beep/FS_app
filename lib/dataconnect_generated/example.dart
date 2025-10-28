library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_user.dart';

part 'list_license_plate_scans.dart';

part 'update_vehicle_info.dart';

part 'get_user_note.dart';







class ExampleConnector {
  
  
  CreateUserVariablesBuilder createUser () {
    return CreateUserVariablesBuilder(dataConnect, );
  }
  
  
  ListLicensePlateScansVariablesBuilder listLicensePlateScans () {
    return ListLicensePlateScansVariablesBuilder(dataConnect, );
  }
  
  
  UpdateVehicleInfoVariablesBuilder updateVehicleInfo ({required String id, }) {
    return UpdateVehicleInfoVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetUserNoteVariablesBuilder getUserNote () {
    return GetUserNoteVariablesBuilder(dataConnect, );
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'example',
    'appfsnew',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}


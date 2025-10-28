part of 'example.dart';

class GetUserNoteVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetUserNoteVariablesBuilder(this._dataConnect, );
  Deserializer<GetUserNoteData> dataDeserializer = (dynamic json)  => GetUserNoteData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetUserNoteData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetUserNoteData, void> ref() {
    
    return _dataConnect.query("GetUserNote", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetUserNoteUserNotes {
  final String id;
  final String content;
  final Timestamp createdAt;
  final GetUserNoteUserNotesUser? user;
  GetUserNoteUserNotes.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  content = nativeFromJson<String>(json['content']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  user = json['user'] == null ? null : GetUserNoteUserNotesUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserNoteUserNotes otherTyped = other as GetUserNoteUserNotes;
    return id == otherTyped.id && 
    content == otherTyped.content && 
    createdAt == otherTyped.createdAt && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, content.hashCode, createdAt.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['content'] = nativeToJson<String>(content);
    json['createdAt'] = createdAt.toJson();
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  GetUserNoteUserNotes({
    required this.id,
    required this.content,
    required this.createdAt,
    this.user,
  });
}

@immutable
class GetUserNoteUserNotesUser {
  final String id;
  final String displayName;
  GetUserNoteUserNotesUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  displayName = nativeFromJson<String>(json['displayName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserNoteUserNotesUser otherTyped = other as GetUserNoteUserNotesUser;
    return id == otherTyped.id && 
    displayName == otherTyped.displayName;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, displayName.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['displayName'] = nativeToJson<String>(displayName);
    return json;
  }

  GetUserNoteUserNotesUser({
    required this.id,
    required this.displayName,
  });
}

@immutable
class GetUserNoteData {
  final List<GetUserNoteUserNotes> userNotes;
  GetUserNoteData.fromJson(dynamic json):
  
  userNotes = (json['userNotes'] as List<dynamic>)
        .map((e) => GetUserNoteUserNotes.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserNoteData otherTyped = other as GetUserNoteData;
    return userNotes == otherTyped.userNotes;
    
  }
  @override
  int get hashCode => userNotes.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userNotes'] = userNotes.map((e) => e.toJson()).toList();
    return json;
  }

  GetUserNoteData({
    required this.userNotes,
  });
}


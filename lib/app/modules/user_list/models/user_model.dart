class UserRes {
  UserRes({
     this.count,
     this.results,
  });
   int? count;
   List<User>? results;

  UserRes.fromJson(Map<String, dynamic> json){
    count = json['count'];
    results = List.from(json['results']).map((e)=>User.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['results'] = results?.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class User {
  User({
     this.id,
     this.name,
  });
   int? id;
   String? name;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}
class TypeComplaintModel {
  int _id;
  String _name;

  TypeComplaintModel({
    required int id,
    required String name
  }):
    _id = id,
    _name = name;
  
  int get getId => _id;
  String get getName => _name;

  set setId(int id) => _id = id;
  set setName(String name) => _name = name;

  factory TypeComplaintModel.toMap(Map<String, dynamic> json) => TypeComplaintModel(
    id: json['id'],
    name: json['name']
  );

  /* contructor empty */
  factory TypeComplaintModel.empty() => TypeComplaintModel(
    id: 0,
    name: ''
  );

  Map<String, dynamic> toJson() => {
    'id': _id,
    'name': _name
  };

  
}
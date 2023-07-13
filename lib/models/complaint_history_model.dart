import 'package:sprint_1/models/images_complait_model.dart';

class ComplaintHistoryModel {
  int  _id;
  String _title;
  String _descripcion;
  String _fecha;
  String _estado;
  List<ImagesComplaintModel> _foto;
  String _ubicacion;
  Map<String, dynamic>  _typeDenunciation;
  Map<String, dynamic> _neighbor;

  ComplaintHistoryModel({
    required int id,
    required String title,
    required String descripcion,
    required String fecha,
    required String estado,
    required List<ImagesComplaintModel> foto,
    required String ubicacion,
    required Map<String, dynamic> typeDenunciation,
    required Map<String, dynamic> neighbor

  }):
    _id = id,
    _title = title,
    _descripcion = descripcion,
    _fecha = fecha,
    _estado = estado,
    _foto = foto,
    _ubicacion = ubicacion,
    _neighbor = neighbor,
    _typeDenunciation = typeDenunciation;

  int get getId => _id;
  String get getTitle => _title;
  String get getDescripcion => _descripcion;
  String get getFecha => _fecha;
  String get getEstado => _estado;
  List<ImagesComplaintModel> get getFoto => _foto;
  String get getUbicacion => _ubicacion;
  Map<String, dynamic> get getTypeDenunciation => _typeDenunciation;
  Map<String, dynamic> get getNeighbor => _neighbor;

  set setId(int id) => _id = id;
  set setTitle(String title) => _title = title;
  set setDescripcion(String descripcion) => _descripcion = descripcion;
  set setFecha(String fecha) => _fecha = fecha;
  set setEstado(String estado) => _estado = estado;
  set setFoto(List<ImagesComplaintModel> foto) => _foto = foto;
  set setUbicacion(String ubicacion) => _ubicacion = ubicacion;
  set setTypeDenunciation(Map<String, dynamic> typeDenunciation) => _typeDenunciation = typeDenunciation;
  set setNeighbor(Map<String, dynamic> neighbor) => _neighbor = neighbor;

  factory ComplaintHistoryModel.toMap(Map<String, dynamic> json) => ComplaintHistoryModel(
    id: json['id'],
    title: json['title'],
    descripcion: json['description'],
    fecha: json['creation_date'],
    estado: json['status'],
    foto: json['images'].map<ImagesComplaintModel>((item) => ImagesComplaintModel.toMap(item)).toList(),
    ubicacion: json['location'],
    typeDenunciation: json['type_denunciation'],
    neighbor: json['neighbor']
  );

  /* contructor empty */
  factory ComplaintHistoryModel.empty() => ComplaintHistoryModel(
    id: 0,
    title: '',
    descripcion: '',
    fecha: '',
    estado: '',
    foto: [],
    ubicacion: '',
    typeDenunciation: {},
    neighbor: {}
  );

  Map<String, dynamic> toJson() => {
    'id': _id,
    'title': _title,
    'description': _descripcion,
    'creation_date': _fecha,
    'status': _estado,
    'images': _foto,
    'location': _ubicacion,
    'type_denunciation': _typeDenunciation,
    'neighbor_id': _neighbor
  };

  String convertFecha(String fecha){
    List<String> fechaSplit = fecha.split('T');
    List<String> fechaSplit2 = fechaSplit[0].split('-');
    return '${fechaSplit2[2]}/${fechaSplit2[1]}/${fechaSplit2[0]}';
  }

  factory ComplaintHistoryModel.register ({required String title,required Map<String, dynamic> typeDenunciation,required Map<String, dynamic> neighbor,required String  descripcion, required List<ImagesComplaintModel> fotos, required String ubicacion}) => ComplaintHistoryModel(
    id: 0,
    title: title,
    descripcion: descripcion,
    fecha: '',
    estado: '',
    foto: fotos,
    ubicacion: ubicacion,
    typeDenunciation: typeDenunciation,
    neighbor: neighbor
  );


}
class UsuarioModel {
  String _id;
  String _nombre;
  String _apellido;
  String _correo;
  String _contrasenia;
  String _foto;
  String _telefono;
  String _direccion;
  String _ci;

  UsuarioModel({
    required String id,
    required String nombre,
    required String apellido,
    required String correo,
    required String contrasenia,
    required String foto,
    required String telefono,
    required String direccion,
    required String ci
    }):
      _id = id,
      _nombre = nombre,
      _apellido = apellido,
      _correo = correo,
      _contrasenia = contrasenia,
      _foto = foto,
      _telefono = telefono,
      _direccion = direccion,
      _ci = ci;

  String get getId => _id;
  String get getNombre => _nombre;
  String get getApellido => _apellido;
  String get getCorreo => _correo;
  String get getContrasenia => _contrasenia;
  String get getFoto => _foto;
  String get getTelefono => _telefono;
  String get getDireccion => _direccion;
  String get getCi => _ci;

  set setId(String id) => _id = id;
  set setNombre(String nombre) => _nombre = nombre;
  set setApellido(String apellido) => _apellido = apellido;
  set setCorreo(String correo) => _correo = correo;
  set setContrasenia(String contrasenia) => _contrasenia = contrasenia;
  set setFoto(String foto) => _foto = foto;
  set setTelefono(String telefono) => _telefono = telefono;
  set setDireccion(String direccion) => _direccion = direccion;
  set setCi(String ci) => _ci = ci;

  factory UsuarioModel.toMap(Map<String, dynamic> json) => UsuarioModel(
    id: json['id'],
    nombre: json['nombre'],
    apellido: json['apellido'],
    correo: json['correo'],
    contrasenia: json['contrasenia'],
    foto: json['foto'],
    telefono: json['telefono'],
    direccion: json['direccion'],
    ci: json['ci']
  );
  /* contructor empty */
  factory UsuarioModel.empty() => UsuarioModel(
    id: '',
    nombre: '',
    apellido: '',
    correo: '',
    contrasenia: '',
    foto: '',
    telefono: '',
    direccion: '',
    ci: ''
  );
  factory UsuarioModel.withEmailAndPassword({required String email, required String password}) => UsuarioModel(
    id: '',
    nombre: '',
    apellido: '',
    correo: email,
    contrasenia: password,
    foto: '',
    telefono: '',
    direccion: '',
    ci: ''
  );

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'nombre': _nombre,
    'apellido': _apellido,
    'correo': _correo,
    'contrasenia': _contrasenia,
    'foto': _foto,
    'telefono': _telefono,
    'direccion': _direccion,
    'ci': _ci
  };

}


class UsuarioModel {
  String _id;
  String _nombre;
  String _apellido;
  String _correo;
  String _contrasenia;
  String _foto;
  String _telefono;
  String _direccion;
  bool _active;
  String _ci;
  String _activationToken;
  String _token;

  UsuarioModel({
    required String id,
    required String nombre,
    required String apellido,
    required String correo,
    required String contrasenia,
    required String foto,
    required String telefono,
    required String direccion,
    required String ci,
    required bool active,
    required String activationToken,
    required String token

    }):
      _id = id,
      _nombre = nombre,
      _apellido = apellido,
      _correo = correo,
      _contrasenia = contrasenia,
      _foto = foto,
      _telefono = telefono,
      _direccion = direccion,
      _ci = ci,
      _activationToken = activationToken,
      _token = token,
      _active = active;

  String get getId => _id;
  String get getNombre => _nombre;
  String get getApellido => _apellido;
  String get getCorreo => _correo;
  String get getContrasenia => _contrasenia;
  String get getFoto => _foto;
  String get getTelefono => _telefono;
  String get getDireccion => _direccion;
  String get getCi => _ci;
  bool get getActive => _active;
  String get getActivationToken => _activationToken;
  String get getToken => _token;

  set setId(String id) => _id = id;
  set setNombre(String nombre) => _nombre = nombre;
  set setApellido(String apellido) => _apellido = apellido;
  set setCorreo(String correo) => _correo = correo;
  set setContrasenia(String contrasenia) => _contrasenia = contrasenia;
  set setFoto(String foto) => _foto = foto;
  set setTelefono(String telefono) => _telefono = telefono;
  set setDireccion(String direccion) => _direccion = direccion;
  set setCi(String ci) => _ci = ci;
  set setActive(bool active) => _active = active;
  set setActivationToken(String activationToken) => _activationToken = activationToken;
  set setToken(String token) => _token = token;

  factory UsuarioModel.toMap(Map<String, dynamic> json) => UsuarioModel(
    id: json['id'],
    nombre: json['nombre'],
    apellido: json['apellido'],
    correo: json['correo'],
    contrasenia: json['contrasenia'],
    foto: json['foto'],
    telefono: json['telefono'],
    direccion: json['direccion'],
    ci: json['ci'],
    active: json['active'],
    activationToken: json['activationToken'] ?? '',
    token: json['token']
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
    ci: '',
    active: false,
    activationToken: '',
    token: ''
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
    ci: '',
    active: false,
    activationToken: '',
    token: ''
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
    'ci': _ci,
    'active': _active,
    'activationToken': _activationToken,
    'token': _token

  };

}
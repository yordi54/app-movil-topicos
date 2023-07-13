import 'dart:convert';
import 'dart:io';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint_1/models/usuario_model.dart';
import 'package:sprint_1/providers/auth_provider.dart';
import 'package:sprint_1/widgets/stteper_controller.dart';

import '../providers/biometric_provider.dart';
import '../screens/camera_screen.dart';
import '../screens/login_screen.dart';
import '../services/rappid_api_service.dart';

class StepperWidget extends StatefulWidget {
  final BuildContext context;

  const StepperWidget({Key? key, required this.context}) : super(key: key);

  @override
  StepperWidgetState createState() => StepperWidgetState();
}

class StepperWidgetState extends State<StepperWidget>{
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  late StepperController stepperController;
  late GlobalKey<FormState> formCI;
  late BiometricProvider biometricProvider;
  late AuthProvider authProvider;
  bool isloading = false;
  final registerForm = FormGroup( {
    'verificar-ci': FormGroup({
      'ci': FormControl<String>(validators: [Validators.required, Validators.minLength(7), Validators.maxLength(8), Validators.pattern(r'^[0-9]*$', validationMessage: 'El carnet de identidad solo debe contener números.')]),
    }),
    'datos-personales': FormGroup({
      'nombre': FormControl<String>(validators: []),
      'apellido': FormControl<String>(validators: []),
      'ci': FormControl<String>(validators: []),
      'direccion': FormControl<String>(validators: [Validators.required, Validators.minLength(10), Validators.maxLength(50)]),
      'telefono': FormControl<String>(validators: [Validators.required, Validators.minLength(7), Validators.maxLength(8)]),
      'correo': FormControl<String>(validators: [Validators.required, Validators.email]),
      'contrasenia': FormControl<String>(validators: [Validators.required, Validators.minLength(8), Validators.pattern( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$', validationMessage: 'Debe tener al menos, una mayúscula, una minúscula y un número.')]),
    })
  });
  @override
  void initState(){
    super.initState();
    for (int i = 0; i < 4; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
    stepperController = StepperController();
    formCI = GlobalKey<FormState>();
    biometricProvider = Provider.of<BiometricProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void dispose(){
    stepperController.dispose();
    for (int i = 0; i < 4; i++) {
      controllers[i].dispose();
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

      return Stepper(
        steps: getSteps(),
        type: StepperType.horizontal,
        currentStep: stepperController.currentStep,
        onStepContinue: (){
          setState(() {
            if(stepperController.currentStep < getSteps().length - 1){
              stepperController.next();
            } else {
              stepperController.dispose();
            }
          });
        },
        onStepCancel: (){
          setState(() {
            if(stepperController.currentStep > 0){
              stepperController.previous();
            } else {
              stepperController.dispose();
            }
          });
        },
        controlsBuilder: (context, details){
          return Container();
        }
      );
  }


  /* Funciones Auxiliares */
  List<Step> getSteps(){
/*     UsuarioProvider userProvider = Provider.of<UsuarioProvider>(context);
 */    return [
      Step(
        state: stepperController.currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: stepperController.currentStep >= 0,
        title: const Text(''), 
        content: ReactiveForm(
          formGroup: registerForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Verificar Identidad',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
               ReactiveTextField(
                key: const ValueKey('ci_register'),
                formControlName: 'verificar-ci.ci',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Carnet de Identidad',
                  prefixIcon: const Icon(Icons.card_membership),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  )
                ),
                validationMessages: {
                  'required': (error) => 'El campo es obligatorio',
                  'minLength': (error) => 'El carnet de identidad debe tener al menos 7 caracteres',
                  'maxLength': (error) => 'El carnet de identidad debe tener como máximo 8 caracteres',
                },
              ),

              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return ElevatedButton(
                          onPressed: () async{
                            if(registerForm.control('verificar-ci.ci').valid){
                              await verifyCI();
                            }else{
                              return;
                            }
                          },
                          child: const Text(
                            'Verificar',
                            
                          ),
                        );
                      },
                    ),
                  const SizedBox(width: 16.0), // Espacio entre los botones
                  ElevatedButton(
                    onPressed: () {
                      stepperController.dispose();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
      Step(
        state: stepperController.currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: stepperController.currentStep >= 1,
        title: const Text(''),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
                child: Text(
                  'Verificar Identidad Biometrica',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Center(
                child: isloading ? const CircularProgressIndicator() :
                  ElevatedButton.icon(
                    onPressed: ()=> _navigatorToCamera(),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('foto'),
                  ), // Espacio entre los botones
                  
              ), 
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 16.0), // Espacio entre los botones
                  ElevatedButton(
                    onPressed: () {
                      stepperController.dispose();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
          ],
        )
      ),
      Step(
        state: stepperController.currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: stepperController.currentStep >= 2,
        title: const Text(''), 
        content: ReactiveForm(
          formGroup: registerForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Center(
                  child: Text(
                    'Datos Personales',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                ReactiveTextField(
                  key: const ValueKey('nombre_register'),
                  formControlName: 'datos-personales.nombre',
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ), 
                ),
                const SizedBox(height: 40.0),
                ReactiveTextField(
                  key: const ValueKey('apellido_register'),
                  formControlName: 'datos-personales.apellido',
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ), 
                ),
                const SizedBox(height: 40.0),
                ReactiveTextField(
                  key: const ValueKey('ci_register'),
                  formControlName: 'datos-personales.ci',
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Carnet de Identidad',
                    prefixIcon: const Icon(Icons.card_membership),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ), 
                ),
                const SizedBox(height: 40.0),
                ReactiveTextField(
                  key: const ValueKey('direccion_register'),
                  formControlName: 'datos-personales.direccion',
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Direccion',
                    prefixIcon: const Icon(Icons.directions),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ), 
                  validationMessages: {
                  'required': (error) => 'El campo es obligatorio',
                  'minLength': (error) => 'La direccion debe tener al menos 10 caracteres',
                  'maxLength': (error) => 'El carnet de identidad debe tener como máximo 50 caracteres',
                },
                ),
                const SizedBox(height: 40.0),
                ReactiveTextField(
                  key: const ValueKey('telefono_register'),
                  formControlName: 'datos-personales.telefono',
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Telefono',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ), 
                  validationMessages: {
                  'required': (error) => 'El campo es obligatorio',
                  'minLength': (error) => 'El telefeno debe tener al menos 7 caracteres',
                  'maxLength': (error) => 'El telefono debe tener como máximo 8 caracteres',
                },
                ),
                const SizedBox(height: 40.0),

                ReactiveTextField(
                  key: const ValueKey('correo_register'),
                  formControlName: 'datos-personales.correo',
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Correo Electronico',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ), 
                  validationMessages: {
                  'required': (error) => 'El campo es obligatorio',
                  'email': (error) => 'El email ingresado no es valido',
                },
                ),
                const SizedBox(height: 40.0),
                ReactiveTextField(
                  key: const ValueKey('constrasenia_register'),
                  formControlName: 'datos-personales.contrasenia',
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ), 
                  validationMessages: {
                  'required': (error) => 'El campo es obligatorio',
                  'minLength': (error) => 'El telefeno debe tener al menos 8 caracteres',
                },
                ),

                const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return ElevatedButton(
                          onPressed: () {
                              register();
                           
                          },
                          child: const Text(
                            'Registrar',
                            
                          ),
                        );
                      },
                    ),
                  const SizedBox(width: 16.0), // Espacio entre los botones
                  ElevatedButton(
                    onPressed: () {
                      stepperController.dispose();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
              ]
            )
          )
        )
      ),
      Step(
        state: stepperController.currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: stepperController.currentStep >= 3,
        title: const Text(''),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Verificacion de Email',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 4; i++)
                  Container(
                    width: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: controllers[i],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
                      ),
                      focusNode: focusNodes[i],
                      onChanged: (value) {
                        _handleTextChanged(i, value);
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {         
                    var token = '';
                    for (int i = 0; i < 4; i++){
                      token = token + controllers[i].text;
                    }
                    final response = await authProvider.validateEmail(token);
                    if(response){
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El correo se verifico correctamente'),
                          duration: Duration(seconds: 2),
                        )
                      );
                      stepperController.dispose();
                      // ignore: use_build_context_synchronously
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    }else{
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El correo no se pudo verificar'),
                          duration: Duration(seconds: 2),
                        )
                      );
                    }
                  }, 
                  child: const Text('Confirmar')
                ),
                const SizedBox(width: 10.0), // Espacio entre los botones
                ElevatedButton(
                    onPressed: () {
                      stepperController.dispose();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Cancelar'),
                  ),

              ],
            ),
          ],

        )
      )
    ];
  }
  Future<void> verifyCI() async {
    final response = await biometricProvider.getUserByCi(registerForm.control('verificar-ci.ci').value.toString());
    if(response){
      registerForm.control('datos-personales').value = {
        'nombre': biometricProvider.getUserBiometric.getNombre,
        'apellido': biometricProvider.getUserBiometric.getApellido,
        'ci': biometricProvider.getUserBiometric.getCi,
        'direccion': biometricProvider.getUserBiometric.getDireccion,
        'telefono': biometricProvider.getUserBiometric.getTelefono,
        'correo': biometricProvider.getUserBiometric.getCorreo,
      };
      registerForm.control('datos-personales.nombre').markAsDisabled();
      registerForm.control('datos-personales.apellido').markAsDisabled();
      registerForm.control('datos-personales.ci').markAsDisabled();
      setState(() {
        stepperController.next();
      });
    }else{
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El carnet de identidad no esta registrado'),
          duration: Duration(seconds: 2),
        )
      );
    }

  }

  Future<void> register() async {
    final form = registerForm.control('datos-personales');
    UsuarioModel usuario = UsuarioModel(
      id: '',
      nombre: biometricProvider.getUserBiometric.getNombre,
      apellido: biometricProvider.getUserBiometric.getApellido,
      ci: biometricProvider.getUserBiometric.getCi,
      direccion: form.value['direccion'],
      telefono: form.value['telefono'],
      correo: form.value['correo'],
      contrasenia: form.value['contrasenia'],
      foto: biometricProvider.getUserBiometric.getFoto,
      token: '',
      activationToken: '',
      active: false
    );
    // ignore: unused_local_variable
    final response = await authProvider.register(usuario);
    if(response){
      // ignore: use_build_context_synchronously
      setState(() {
        stepperController.next();
      });

    }else{
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo registrar el usuario'),
          duration: Duration(seconds: 2),
        )
      );
    }
  }

  void _navigatorToCamera() async{
    
    String data = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const CameraScreen())
    );
    if(data.isNotEmpty){
      setState(() {
        isloading = true;
      });
      File imageFile = File(data);
      List<int> bytes = imageFile.readAsBytesSync();
      String base64Image = base64Encode(bytes);
      final verificar = await RappidApiService().compareFaces(biometricProvider.getUserBiometric.getFoto, base64Image);
      
     final res = verificar.succeeded.data['confidence'];
      if(res != "null"){
        if( double.parse(res) > 70.0){
          biometricProvider.stopFaceComparison();
          setState(() {
            stepperController.next();
          });
        }else{
          setState(() {
            isloading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo verificar la identidad'),
            duration: Duration(seconds: 2),
          )
        );
        } 
        
      } else {
        setState(() {
          isloading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo verificar la identidad'),
            duration: Duration(seconds: 2),
          )
        );
      } 
    }
  } 

  void _handleTextChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      // Cuando se ingresa un carácter y no es el último campo, pasa al siguiente
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
  }
}
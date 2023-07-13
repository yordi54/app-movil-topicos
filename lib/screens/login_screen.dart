import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sprint_1/providers/auth_provider.dart';
import 'package:sprint_1/screens/register_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formLogin = FormGroup({
    'email': FormControl<String>(validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(validators: [Validators.required, Validators.minLength(8), Validators.pattern(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),validationMessage: 'No es una contraseña valida' )]),
  });
  late AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(size: 100),
              const SizedBox(height: 20.0),
              Text(
                'Iniciar sesión',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20.0),
              ReactiveForm(
                formGroup: formLogin, 
                child: Column(
                  children: [
                    ReactiveTextField(
                      formControlName: 'email',
                      onChanged: (control) {
                        
                      },
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validationMessages: {
                        'required': (error) => 'Este campo es requerido',
                        'email': (error) => 'Correo electrónico inválido',
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ReactiveTextField(
                      formControlName: 'password',
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validationMessages: {
                        'required': (error) => 'Este campo es requerido',
                        'minLength': (error) => 'La contraseña debe tener al menos 8 caracteres',
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const Color.fromARGB(255, 6, 38, 222);
                                }
                                return Theme.of(context).colorScheme.primary;
                              },
                            ),
                          ),
                          onPressed: () {
                            if(form.valid){
                              login(context);
                            }else{
                              return ;
                            }
                          }, 
                          child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
                        );
                      },
                    ),  
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes una cuenta?'),
                        const SizedBox(width: 5.0),
                        TextButton(
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(builder: (context) => const RegisterScreen());
                            Navigator.pushReplacement(context, route);
                          },
                          child: const Text('Regístrate'),
                        ),
                      ],
                    ),
                  ],
                )
              )
            ]
          ),
        ),
      ),
    );
  }

  /* funciones auxiliares */
  login(BuildContext context) async {
    String email = formLogin.control('email').value;
    String password = formLogin.control('password').value;
    /* implementar */
    final result = await authProvider.login(email, password);

    if(result){
      //almacenar las localstorage
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }else {
      /* mostrar error */
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario o contraseña incorrectos'),
        ),
      );
    }
  }
}
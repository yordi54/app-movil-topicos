import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sprint_1/models/complaint_history_model.dart';
import 'package:sprint_1/models/images_complait_model.dart';
import 'package:sprint_1/providers/auth_provider.dart';
import 'package:sprint_1/providers/complaint_history_provider.dart';
import 'package:sprint_1/providers/type_complaint_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class RegisterComplaintScreen extends StatefulWidget {
  const RegisterComplaintScreen({Key? key}) : super(key: key);

  @override
  RegisterComplaintScreenState createState() => RegisterComplaintScreenState();
}

class RegisterComplaintScreenState extends State<RegisterComplaintScreen> {
  final formRegisterComplaint = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'descripcion': FormControl<String>(validators: [Validators.required, Validators.minLength(64), Validators.maxLength(512)]),
    'tipoDenuncia': FormControl<String>(validators: [Validators.required]),
    'images': FormControl<List<String>>(validators: [Validators.required]),
  });
  List<DropdownMenuItem> items = []; 
  List<String> imagePaths = [];
  late Position position;
  @override
  void initState() {
    super.initState();
    TypeComplaintProvider typeComplaintProvider = TypeComplaintProvider();
    typeComplaintProvider.getTypeComplaintList();
    typeComplaintProvider.addListener(() {
      setState(() {
        for (var item in typeComplaintProvider.typeComplaintList) {
          items.add(DropdownMenuItem(
            value: item.getId.toString(),
            child: Text(item.getName),
          ));
        }
      });
    });
    getCurrentLocation();
  }

  Future<void> pickImages() async {
  ImagePicker picker = ImagePicker();
  List<XFile> pickedFiles = await picker.pickMultiImage(
    imageQuality: 20, // Ajusta la calidad de las imágenes seleccionadas
  );

  if (pickedFiles.isNotEmpty) {
    setState(() {
      imagePaths.addAll(pickedFiles.map((pickedFile) => pickedFile.path));
    });
  }
}


  void removeImage(int index) {
    setState(() {
      imagePaths.removeAt(index);
    });
  }
    Future<Position> _determinePosition() async {
    bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
        return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
      } 
      
    return await Geolocator.getCurrentPosition();
  }
  
  void getCurrentLocation() async {
    try {
      position = await _determinePosition();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void convertImagestoBase64(){
    List<String> base64Images = [];
    for (var imagePath in imagePaths) {
      File file = File(imagePath);
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      base64Images.add(base64Image);
    }
    formRegisterComplaint.patchValue({'images': base64Images});
  }

  List<ImagesComplaintModel> convertImageModel(){
    List<String> array = formRegisterComplaint.control('images').value;
    if(array.isEmpty) return [];
    List<ImagesComplaintModel> imagesComplaintModel = [];
    for (var item in array) {
      imagesComplaintModel.add(ImagesComplaintModel(
        id: 0,
        url: item
      ));
    }
    return imagesComplaintModel;
  }

  void registerComplaint() async {
    ComplaintHistoryProvider complaintHistoryProvider = Provider.of<ComplaintHistoryProvider>(context, listen: false);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    ComplaintHistoryModel complaintHistoryModel = ComplaintHistoryModel.register(
      title: formRegisterComplaint.control('title').value,
      descripcion: formRegisterComplaint.control('descripcion').value,
      typeDenunciation: {
        "id": int.parse(formRegisterComplaint.control('tipoDenuncia').value)
      },
      neighbor: {
        "id": authProvider.usuario.getId
      },
      ubicacion: "${position.altitude}, ${position.longitude}",
      /* List<ImagesComplaintModel>*/
      fotos: convertImageModel(),
    );
    Map<String, dynamic> response = await complaintHistoryProvider.registerComplaintHistory(complaintHistoryModel);
    
    if (response['ok']){

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Denuncia registrada'),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    }else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar denuncia'),
        ),
      );
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Denuncia'),
        elevation: 0,
        backgroundColor: Colors.grey[50],
        actions: [
          IconButton(
            onPressed: () async{
            },
            icon: const Icon(Icons.location_on_outlined, color: Colors.black,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Registrar Denuncia',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20.0),
              ReactiveForm(
                formGroup: formRegisterComplaint, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReactiveTextField(
                      keyboardType: TextInputType.text,
                      formControlName: 'title',
                      onChanged: (control) {
                        
                      },
                      validationMessages: {
                        'required': (error) => 'Este campo es requerido',
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descripción',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ReactiveTextField(
                      keyboardType: TextInputType.text,
                      formControlName: 'descripcion',
                      maxLines: 4,
                      onChanged: (control) {
                        
                      },
                      validationMessages: {
                        'required': (error) => 'Este campo es requerido',
                        'minLength': (error) => 'La descripción debe tener al menos 64 caracteres',
                        'maxLength': (error) => 'La descripción debe tener menos de 512 caracteres',
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descripción',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ReactiveDropdownField(
                      formControlName: 'tipoDenuncia',
                      items: items,
                      validationMessages: {
                        'required': (error) => 'Este campo es requerido',
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tipo de denuncia',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            if( imagePaths.length < 2){
                              pickImages();
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Solo se pueden agregar 2 imagenes'),
                                ),
                              );
                              return;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0.0),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: SizedBox(
                            width: 80.0,
                            height: 80.0,
                            child: Image.asset(
                              'assets/images/addImage.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),

                        const SizedBox(width: 20.0),
                        
                      if(imagePaths.isNotEmpty)
                        Expanded(
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                // Lógica para el cambio de página
                              },
                              scrollDirection: Axis.horizontal,
                            ),
                            items: imagePaths.map((imagePath) {
                              return Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Image.file(
                                      File(imagePath),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () => removeImage(imagePaths.indexOf(imagePath)),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.clear,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ReactiveFormConsumer(
                        builder: (context, form, child) {
                          return ElevatedButton(
                            onPressed: (){
                              convertImagestoBase64();
                              //añadir imagenes convertir a base 64 los file de imagen
                              if(form.valid){
                                registerComplaint();
                              }
                            }, 
                            child: const Text('Registrar Denuncia')
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        )
    );
  }
}
  
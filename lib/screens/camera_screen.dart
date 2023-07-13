import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sprint_1/screens/image_preview_screen.dart';

List <CameraDescription> cameras = [];
class CameraScreen extends StatefulWidget{
  const CameraScreen({Key? key}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>{
  CameraController? _controller;

  @override
  void initState(){
    super.initState();
    _initiateCamera();
  }

  @override
  void dispose(){
    _controller!.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context){
    if(_controller == null || !_controller!.value.isInitialized){
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: CameraPreview(_controller!),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Boton de capturar
          FloatingActionButton(
            onPressed: _takePicture,
            heroTag: 'take_picture_button',// establecer una etiqueta única, para evitar errores            
            child: const Icon(Icons.camera_alt),
          )

          //Boton de cambiar camara
          ,FloatingActionButton(
            onPressed: _toogleCamera,
            heroTag: 'toggle_camera_button',
            child: const Icon(Icons.flip_camera_android),
          )
        ]
        ),
    );
  }

  /* Funciones */

  Future<void> _initiateCamera() async{
    // Aquí inicializamos las cámaras disponibles
    cameras = await availableCameras();
    if(cameras.isNotEmpty){
      setState(() {
        _controller = CameraController(cameras[0], ResolutionPreset.max, enableAudio: false,imageFormatGroup: ImageFormatGroup.jpeg);
        _controller!.initialize().then((_){
          if(!mounted){
            return;
          }
          setState(() {});
        });
      });
    }
  }

  Future <void> _toogleCamera() async{
    // Cambiamos la cámara actual
    final CameraDescription cameraDescription = (_controller?.description == cameras[0]) ? cameras[1] : cameras[0];
    if(_controller != null){
      await _controller!.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.ultraHigh, enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }


  void _takePicture() {
    // Tomamos una foto
    if(_controller != null && _controller!.value.isInitialized){
      _controller!.takePicture().then((XFile file) => {
        //
        Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePreviewScreen(imageFile: file.path))).then((value) =>{
          if(value != null){
            Navigator.pop(context, value)
          }
        })
      
      });
    }
  }

}
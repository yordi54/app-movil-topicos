import 'package:flutter/material.dart';
import 'package:sprint_1/models/complaint_history_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
class ViewComplaintScreen extends StatelessWidget {
  const ViewComplaintScreen({Key? key}) : super(key: key);
  
  List<Widget> images (ComplaintHistoryModel complaintHistoryModel){
    List<Widget> imagesWidgets = [];
    if(complaintHistoryModel.getFoto.isNotEmpty){
      for (var item in complaintHistoryModel.getFoto) {
        imagesWidgets.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(item.url),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
    } else {
      imagesWidgets.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: const DecorationImage(
              image: AssetImage('assets/images/noimage.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return imagesWidgets;
  }

  @override
  Widget build(BuildContext context) {
    ComplaintHistoryModel complaintHistoryModel = ModalRoute.of(context)?.settings.arguments as ComplaintHistoryModel;    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver denuncia'),
        elevation: 0,
        backgroundColor: Colors.grey[50],
      ),
      body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //realizar el carosuler con 2 images
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        pauseAutoPlayOnTouch: true,
                        aspectRatio: 2.0,
                        ),
                      items: images(complaintHistoryModel),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Fecha de la denuncia:', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold )),
                    Text(' ${complaintHistoryModel.convertFecha(complaintHistoryModel.getFecha)}'),
                    const SizedBox(height: 12.0),
                    const Text('Descripción: ', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold ),),
                    Text(' ${complaintHistoryModel.getDescripcion}'),
                    const SizedBox(height: 12.0),
                    const Text('Tipo de denuncia: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Text(' ${complaintHistoryModel.getTypeDenunciation['name']}'),
                    const SizedBox(height: 12.0),
                    const Text('Estado: ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Text(' ${complaintHistoryModel.getEstado}'),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),

    );
  }
}

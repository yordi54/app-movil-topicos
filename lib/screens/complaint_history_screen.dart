import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint_1/models/complaint_history_model.dart';
import 'package:sprint_1/models/type_complaint_model.dart';
import 'package:sprint_1/providers/auth_provider.dart';
import 'package:sprint_1/providers/complaint_history_provider.dart';
import 'package:sprint_1/providers/type_complaint_provider.dart';
import 'package:sprint_1/utils/constants.dart';

class ComplaintHistoryScreen extends StatefulWidget {
  const ComplaintHistoryScreen({Key? key}) : super(key: key);

  @override
  ComplaintHistoryScreenState createState() => ComplaintHistoryScreenState();
}

class ComplaintHistoryScreenState extends State<ComplaintHistoryScreen> {
  late ComplaintHistoryProvider complaintHistoryProvider;
  late AuthProvider authProvider;
  String selectedFilter = '';
  String filterComplaint = 'defecto';
  String filterOpciones = ''; 
  String selectedOpciones = '';
  List<ComplaintHistoryModel> data = [];
  late TypeComplaintProvider typeComplaintProvider;
  List<TypeComplaintModel> typeComplaintList = [];

  Future<void> initialComplait(AuthProvider authProvider) async{
    await complaintHistoryProvider.getComplaintHistoryList(authProvider.usuario.getId, filterComplaint, filterOpciones);
    setState(() {
      data = complaintHistoryProvider.complaintHistoryList;
    });
  }

  Future<void> initialTypeComplaint() async{
    await typeComplaintProvider.getTypeComplaintList();
    setState(() {
      typeComplaintList = typeComplaintProvider.typeComplaintList;
    });
  }

  @override
  void initState(){
    super.initState();
    complaintHistoryProvider = Provider.of<ComplaintHistoryProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    typeComplaintProvider = Provider.of<TypeComplaintProvider>(context, listen: false);
    initialComplait(authProvider);
    initialTypeComplaint();
    
  }

  ImageProvider imagesExist(index){
    if(data[index].getFoto.isNotEmpty ){
      return NetworkImage(data[index].getFoto[0].url);
    }
    return const AssetImage('assets/images/noimage.png');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      elevation: 0,
      actions: [
        IconButton(
          onPressed: (){
            showModalBottomSheet(
              context: context, 
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          const Center(child: Text('Filtrado', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))),
                          const SizedBox(height: 10.0),
                          const Divider(),
                          const SizedBox(height: 10.0),
                          DropdownButton(
                            isExpanded: true,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                            value: filterComplaint,
                            items: const [
                              DropdownMenuItem(
                                value: 'defecto',
                                child: Text('Defecto'),
                              ),
                              DropdownMenuItem(
                                value: 'tipo',
                                child:  Text('Tipo'),
                              ),
                              DropdownMenuItem(
                                value: 'estado',
                                child:  Text('Estado'),
                              ),
                            ], 
                            onChanged: (value){
                              setState(() {
                                filterComplaint = value.toString();
                              });
                            }
                          ),
                          if( filterComplaint == 'tipo')
                            //radio button
                            Column(
                              children: [
                                const SizedBox(height: 10.0),
                                const Text('Tipo', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10.0),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            for (var item in typeComplaintList)
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: item.getName, 
                                                    groupValue: filterOpciones, 
                                                    onChanged: (value){
                                                      setState(() {
                                                        filterOpciones = value.toString();
                                                      });
                                                    }
                                                  ),
                                                  Text(item.getName),
                                                  const SizedBox(width: 10.0,)
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                  
                              ],
                            ),
                          if( filterComplaint == 'estado')
                            Column(
                              children: [
                                const SizedBox(height: 10.0),
                                const Text('Estado', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10.0),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: StateComplaint.Pendiente.name, 
                                        groupValue: filterOpciones, 
                                        onChanged: (value){
                                          setState(() {
                                            filterOpciones = value.toString();
                                          });
                                        }
                                      ),
                                      Text(StateComplaint.Pendiente.name),
                                      Radio(
                                        value: StateComplaint.EnProgreso.name, 
                                        groupValue: filterOpciones, 
                                        onChanged: (value){
                                          setState(() {
                                            filterOpciones = value.toString();
                                          });
                                        }
                                      ),
                                      Text(StateComplaint.EnProgreso.name),
                                      Radio(
                                        value: StateComplaint.Aceptada.name, 
                                        groupValue: filterOpciones, 
                                        onChanged: (value){
                                          setState(() {
                                            filterOpciones = value.toString();
                                          });
                                        }
                                      ),
                                      Text(StateComplaint.Aceptada.name),
                                       Radio(
                                        value: StateComplaint.Rechazada.name, 
                                        groupValue: filterOpciones, 
                                        onChanged: (value){
                                          setState(() {
                                            filterOpciones = value.toString();
                                          });
                                        }
                                      ),
                                      Text(StateComplaint.Rechazada.name),
                                       Radio(
                                        value: StateComplaint.Finalizada.name, 
                                        groupValue: filterOpciones, 
                                        onChanged: (value){
                                          setState(() {
                                            filterOpciones = value.toString();
                                          });
                                        }
                                      ),
                                      Text(StateComplaint.Finalizada.name),
                                      const SizedBox(width: 10.0,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          
                            
                          const SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: ()async{
                                complaintHistoryProvider.setComplaintHistoryList = [];
                                await complaintHistoryProvider.getComplaintHistoryList(authProvider.usuario.getId, filterComplaint, filterOpciones);
                                setState(() {
                                  data = complaintHistoryProvider.complaintHistoryList;
                                  selectedFilter = filterComplaint;
                                  selectedOpciones = filterOpciones;
                                });
                                Navigator.pop(context);
                                
                              }, 
                              child: const Text('Aplicar')
                            ),
                          ),
                        ],
                      ),                      
                    );
                  } 
                );
              }
            ).then((value) => {
              //si cerro el modal
              if(value == null){
                setState(() {
                  filterComplaint = selectedFilter;
                  filterOpciones = selectedOpciones;
                })
              }
            
            });
          }, 
          icon: const Icon(Icons.filter_list_rounded, color: Colors.black,)
        )
      ],
      backgroundColor: Colors.grey[50], 
      title: const Text("Historial de Denuncias", style: TextStyle(color: Colors.black, fontSize: 25),),
    ),
    body:
    ListView.builder(
      itemBuilder: (context, index){
        //vista de una denuncia
        return Container(
          height: 200,
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 0.5,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150, // Ajusta el ancho de la imagen según tus necesidades
                    height: 150, // Ajusta la altura de la imagen según tus necesidades
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imagesExist(index),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Denuncia $index', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                        const SizedBox(height: 5.0),
                        Text('Tipo:${data[index].getTypeDenunciation['name']}'),
                        const SizedBox(height: 5.0),
                        Text('Fecha: ${data[index].convertFecha(data[index].getFecha)}'),
                        const SizedBox(height: 5.0),
                        Text('Estado: ${data[index].getEstado}'),
                        const SizedBox(height: 5.0),
                        /* acciones como eliminar editar y ver */
                        const Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                        Row (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           IconButton(
                            onPressed: (){
                              //ver imagen y mandar a otra pantalla
                              Navigator.pushNamed(context, '/view_complaint', arguments: data[index]);
                              
                            },
                             icon: Icon(Icons.remove_red_eye_outlined, color: Colors.green[400],),
                            ),
                            IconButton(
                              onPressed: (){},
                              icon:  Icon(Icons.edit_outlined, color: Colors.blue[400],),
                            ),
                            if(data[index].getEstado == 'Pendiente')
                              IconButton(
                              onPressed: (){
                                showDialog(
                                  context: context, 
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Eliminar Denuncia'),
                                      content: const Text('¿Está seguro de eliminar la denuncia?'),
                                      actions: [
                                        TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          }, 
                                          child: const Text('Cancelar')
                                        ),
                                        TextButton(
                                          onPressed: () async{
                                            await complaintHistoryProvider.deleteComplaintHistory(data[index].getId);
                                            complaintHistoryProvider.setComplaintHistoryList = [];
                                            await complaintHistoryProvider.getComplaintHistoryList(authProvider.usuario.getId, filterComplaint, filterOpciones);
                                            Navigator.pop(context);
                                            setState(() {
                                              data = complaintHistoryProvider.complaintHistoryList;
                                            });
                                          }, 
                                          child: const Text('Aceptar')
                                        ),
                                      ],
                                    );
                                  }
                                );
                              },
                              icon:  Icon(Icons.delete_outline, color: Colors.red[400],),
                            ),
                          ],
                        ),
                      ],
                    )
                  )
                ],
              ),
            ]
            ),

        );
      }, 
      itemCount: complaintHistoryProvider.complaintHistoryList.length),
    floatingActionButton: FloatingActionButton(
      onPressed: () async  {
        // Acción cuando se presiona el botón flotante
        final result = await Navigator.pushNamed(context, '/register_complaint');
        if(result == true){
          complaintHistoryProvider.setComplaintHistoryList = [];
          await complaintHistoryProvider.getComplaintHistoryList(authProvider.usuario.getId, filterComplaint, filterOpciones);
          setState(() {
            data = complaintHistoryProvider.complaintHistoryList;
          });
        }
      },
      backgroundColor: Colors.blue[200],
      foregroundColor: Colors.blue[900],
      child:  const Icon(Icons.add),
    ),
  );
  }

}

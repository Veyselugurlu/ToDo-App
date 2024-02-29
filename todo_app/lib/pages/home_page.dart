import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_storage_key.dart';
import 'package:todo_app/helper/translation_helper.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFrom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: const Text(
            "title",  //jsondan alicak basligi easy translation sayesinde 
          style: TextStyle(color: Colors.green),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed:() {
             _showSearchPage();
          },
           icon: const Icon(Icons.search,
           color: Colors.blueGrey,),
           ),
          IconButton(onPressed:() {
            _showAddTaskBottomSheet();
          },
           icon: const Icon(Icons.add),
           ),


        ],
      ),
      body:_allTasks.isNotEmpty ? 
      ListView.builder(
        itemBuilder: (context , index){
        var oAnkiListeElemani = _allTasks[index];
        return Dismissible(
          background: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Icon(
                Icons.delete,color: Colors.grey,
                ),
            const SizedBox(width: 5,),
            const Text(
                "remove_task").tr(),
            ],
          ),
          key: Key(oAnkiListeElemani.id),
          onDismissed: (direction) {
            _allTasks.removeAt(index);  //silme islemi

            //veritabanindan silme islemi
            _localStorage.deleteTask(task: oAnkiListeElemani);
            setState(() {
              
            }
            );
          },
          child: TaskItem(task: oAnkiListeElemani),
        );
      } ,
      itemCount: _allTasks.length,) 
      :
     Center( 
      child:const Text("empty_task_list").tr(),
    ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          padding: 
          EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child:  ListTile(
            title: TextField(
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "add_task".tr(),
                border: InputBorder.none
                ),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  DatePicker.showDatePicker(context,
                  locale: TranslationHelper.getDeviceLanguage(context), //dinamik olarak turkce ayarladık.
                  onConfirm: (time) async{
                    var yeniEklenenGorev = 
                    Task.create(name: value, createdAt: time);                 
                  
                  _allTasks.insert(0, yeniEklenenGorev);  //gorevleri ekleme ancak veritabanina ekleme olmuyor 
               
                  //veri tabanina ekleme
                 await _localStorage.addTask(task: yeniEklenenGorev);
                  setState(() {
                    
                    });
                     },);
                 
                },
            ),
          ),
        );
      });
  }
  
  void _getAllTaskFrom() async {    // yerel depodan tüm görevleri alır 
    _allTasks = await _localStorage.getAllTask();
    setState(() {
      
    });
  }
  
  void _showSearchPage() async {   // Bu işlev, showSearch yöntemi çağrısıyla bir arama diyaloğunu görüntüler
  await  showSearch(context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
    _getAllTaskFrom();
  }
}
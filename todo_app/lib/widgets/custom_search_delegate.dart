
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage_key.dart';
import 'package:todo_app/main.dart';

import '../models/task_model.dart';
import 'task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate{
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});


  @override
  List<Widget>? buildActions(BuildContext context) {  // arama kisminin sag tarafındaki iconları
   return [
    IconButton(onPressed: (){
      query.isEmpty ? null : query = '';
    }, 
    icon: const Icon(Icons.clear))
   
   ];
  }

  @override
  Widget? buildLeading(BuildContext context) {  //en bastaki iconlar
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(Icons.arrow_back_ios,
      color: Colors.black,
      ),
    );
    
  }

  @override
  Widget buildResults(BuildContext context) {  //cikicak olan sonuclar
  var filteredList = allTasks.where(  //butun gorevleri geziyoruz
    (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase())).toList();  //alanlrin hepsine bakilcak kucuk harfe cevrilcek ve bu iceriyora arama butonuna bastiginda aranan deger gozukcek.
    return filteredList.length>0 ?  ListView.builder(
        itemBuilder: (context , index){
        var oAnkiListeElemani = filteredList[index];
        return Dismissible(
          background: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           const   Icon(
                Icons.delete,color: Colors.grey,
                ),
              const SizedBox(width: 5,),
            const   Text(
                "remove_task").tr(),
            ],
          ),
          key: Key(oAnkiListeElemani.id),
          onDismissed: (direction) async {
            filteredList.removeAt(index);  //silme islemi

            //veritabanindan silme islemi
            // hem localden hemde listeden silme islemi yapıyoruz bu sayede . 
           await locator<LocalStorage>().deleteTask(task: oAnkiListeElemani);
        
          },
          child: TaskItem(task: oAnkiListeElemani),
        );
      } ,
      itemCount: filteredList.length,):
        Center(
        child: 
        const Text('search_not_found').tr(),
      ) ;
  }

  @override
  Widget buildSuggestions(BuildContext context) {  //gorunmesini istedigmiz sonuclar
    return Container();
  }

}
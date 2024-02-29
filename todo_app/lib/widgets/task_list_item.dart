// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/local_storage_key.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
   Task task;
   TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {

  TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();

  }
  @override
  Widget build(BuildContext context) {

     _taskNameController.text = widget.task.name; // bir'den fazla kez calisarak guncelleme islemini saglamak icin widgetin altına aldik.

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,

          ),
        ]
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: (){
            widget.task.isComleted = !widget.task.isComleted;
          _localStorage.updateTask(task: widget.task);
            setState(() {
              
            });
          },
          child: Container(
            child: const Icon(
              Icons.check_box ,
              color: Colors.white,
              ),
            decoration: BoxDecoration(

              color: widget.task.isComleted ? Colors.green : Colors.white,
              border: Border.all(color: Colors.grey, width: 0.8),
              shape: BoxShape.circle ),
          ),
        ),
       title: widget.task.isComleted 
       ? Text(
     widget.task.name,
      style: const TextStyle(
        decoration: TextDecoration.lineThrough,
        color: Colors.grey,),
       )
       : TextField(
         controller: _taskNameController,
         minLines: 1,
         maxLines: null,
         textInputAction: TextInputAction.done,
         decoration: const InputDecoration(border: InputBorder.none),
         onSubmitted: (yeniDeger) {
           widget.task.name=yeniDeger; //guncelleme islemi 
           //veritabanindan guncelleme islemi
           _localStorage.updateTask(task: widget.task);
         },
       ),
       trailing: Text(
        DateFormat('hh:nn a').format(widget.task.createdAt),
        style: const TextStyle(fontSize: 14,color: Colors.grey),
       ),
       
        ),
    );
  }
}
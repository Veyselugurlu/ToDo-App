import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';
@HiveType(typeId:1)
class Task extends  HiveObject{
  
 @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  bool isComleted;

  Task({required this.id,required this.name,required this.createdAt,required this.isComleted});


  factory Task.create({required String name, required DateTime createdAt}){
return Task(id: const Uuid().v1(), name: name, createdAt: createdAt, isComleted: false);
  }
  

}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/data/local_storage_key.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/home_page.dart';
  final locator= GetIt.instance;
void setup(){  
  //veri tabani degisirse tek yapmamiz gerekeken HiveLocalStorage ywrine başka bir veri yazmk olur .
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}
Future <void> setupHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    var taskBox = await Hive.openBox<Task>('tasks');   //veriler hafizada yer tutuyor artik.
    //bir gunluk veri tutuca hafizada bu yuzden geri kalan verileri silicez.
    for (var task in taskBox.values) {
      if (task.createdAt.day != DateTime.now().day) {   //gun degerleri farklı ise sil.
        taskBox.delete(task.id);
      }
    }

}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    await setupHive();

    setup();
runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations', //burddan gelcek diller
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale, //cihazin dili ile baslatma.
    
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        appBarTheme:const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.blue)
        ),
      
    
      ),
      home: const HomePage(),
    );
  }
}

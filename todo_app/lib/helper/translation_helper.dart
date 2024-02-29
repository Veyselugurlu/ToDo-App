import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationHelper{
  TranslationHelper._();

  static getDeviceLanguage(BuildContext context)
  {
    var _deviceLanguage = context.deviceLocale.countryCode!.toLowerCase();
    print(_deviceLanguage);
    switch(_deviceLanguage){
      case 'tr':
      return LocaleType.tr;
      case 'en':
      return LocaleType.en;
    }  }
}
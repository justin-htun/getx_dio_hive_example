import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'app/modules/user_list/models/user_model.dart';
import 'app/routes/app_pages.dart';
import 'constants/app_constants.dart';

void main() async {
  await Hive.initFlutter();
  var dir = await getApplicationDocumentsDirectory();
 // Hive.init(dir.path);
  Hive.init(dir.path);
   var listBox = await Hive.openBox(AppConstants.user_list_box);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorObservers: [ChuckerFlutter.navigatorObserver],
    ),
  );
}

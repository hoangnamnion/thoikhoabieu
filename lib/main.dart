import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/schedule_provider.dart';
import 'theme/doraemon_theme.dart';
import 'views/home_screen.dart';

import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Khởi tạo dịch vụ thông báo
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Lỗi khởi tạo thông báo: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: const ThoiKhoaBieuApp(),
    ),
  );
}

class ThoiKhoaBieuApp extends StatelessWidget {
  const ThoiKhoaBieuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thời Khóa Biểu Doraemon',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: DoraemonTheme.lightTheme,
      darkTheme: DoraemonTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_content_recommendation_application/auth/screens/login.dart';
import 'package:smart_content_recommendation_application/auth/services/authService.dart';
import 'package:smart_content_recommendation_application/content/screens/home_screen.dart';
import 'package:smart_content_recommendation_application/providers/articleProvider.dart';
import 'package:smart_content_recommendation_application/providers/homeProvider.dart';
import 'package:smart_content_recommendation_application/providers/imageProvider.dart';
import 'package:smart_content_recommendation_application/providers/queryProvider.dart';
import 'package:smart_content_recommendation_application/providers/userProvider.dart';
import 'package:smart_content_recommendation_application/providers/videoProivder.dart';
import 'package:smart_content_recommendation_application/routes.dart';
import 'package:smart_content_recommendation_application/splash_screen.dart';
var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Permission.storage.request();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dotenv.load(); 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => QueryProvider()),
        ChangeNotifierProvider(create: (_) => ArticleProvider()),
        ChangeNotifierProvider(create: (_) => ImagesProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserProvider>(context).user.id);
    bool isUserLoggedIn =
        Provider.of<UserProvider>(context).user.token.isNotEmpty;
    print(isUserLoggedIn);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: isUserLoggedIn
          ? SplashScreen()
          :  LoginScreen(), 
      //  home: LoginScreen(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
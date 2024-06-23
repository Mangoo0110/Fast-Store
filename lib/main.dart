
import 'package:easypos/data/datasources/firebase/firebase_auth_repo_impl.dart';
import 'package:easypos/firebase_options.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/models/delivery_info_model.dart';
import 'package:easypos/models/payment_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/appdrawer/controller/appdrawer_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/user_auth/screens/signin.dart';
import 'package:easypos/pages/user_dashboard/controller/user_data_controller.dart';
import 'package:easypos/pages/user_dashboard/screens/user_dashboard.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final docDir = await getApplicationDocumentsDirectory();
  Hive.init(docDir.path);
  Hive.registerAdapter(DeliveryPhaseAdapter());
  Hive.registerAdapter(PaymentMethodAdapter());
  Hive.registerAdapter(BillingMethodAdapter());
  Hive.registerAdapter(BillTypeAdapter());
  Hive.registerAdapter(OnlineStatusAdapter());
  Hive.registerAdapter(BillingStatusAdapter());

  Hive.registerAdapter(BillModelAdapter());
  Hive.registerAdapter(DeliveryInfoModelAdapter());
  Hive.registerAdapter(BillingProductAdapter());
  Hive.registerAdapter(PaymentModelAdapter());

  Animate.restartOnHotReload = true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppdrawerProviderController>(create: (context)=> AppdrawerProviderController(), ),
        ChangeNotifierProvider<StoreDataController>(create: (context)=> StoreDataController()),
        ChangeNotifierProvider<BillingDataController>(create: (context)=> BillingDataController(), ),
        ChangeNotifierProvider<UserDataController>(create: (context)=> UserDataController())
      ],
      child: (const MyApp()),
    ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  // variables :::
  bool darkTheme = false;

  late Stream<User?> firebaseUser;

  // functions :::
  // Future<void> getLocalUserTheme()async{
  //   darkTheme = await LocalUserThemeModeStorage().userThemeDarkOrNot();
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    getAuthenticatedUser();
    super.initState();
  }

 

  getAuthenticatedUser() {
    firebaseUser = FirebaseAuthRepoImpl(authInstance: null).user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      //home: const UserDashboard(),
      home: StreamBuilder(
        stream: firebaseUser,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            dekhao("waiting");
            return const Center(
              child: CircularProgressIndicator());
          }
          // if() {
          //   dekhao("active");
          // }
          if(snapshot.connectionState == ConnectionState.active) {
            dekhao("active");
            var user = snapshot.data ;
            
            if(user == null) {
              return const SignInView();
            } else {
              dekhao(user.toString());
              return const UserDashboard();
            }
          }
          return const Center(
            child: CircularProgressIndicator());
        },
        
      ),
      // routes: {
      //   signupRoute :(context) => const SignUpView()
      // },
    );
  }
}

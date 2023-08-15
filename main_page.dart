import 'package:angkutan_sayur_user/component/custom_icons_icons.dart';
import 'package:angkutan_sayur_user/data/constants/color_constant.dart';
import 'package:angkutan_sayur_user/presentation/pages/main/history_page.dart';
import 'package:angkutan_sayur_user/presentation/pages/home/home_page.dart';
import 'package:angkutan_sayur_user/presentation/pages/main/notification_page.dart';
import 'package:angkutan_sayur_user/presentation/pages/main/profile_page.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/home/home_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/main/main_bloc.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/main/main_event.dart';
import 'package:angkutan_sayur_user/presentation/statemanagement/bloc/service/current_location_bloc.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController pageController = PageController(initialPage: 0);
  late MainBloc _mainBloc;

  @override
  void initState() {
    // _mainBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(create:(_)=> MainBloc()),
        BlocProvider<HomeBloc>(create:(_)=> HomeBloc()),
        BlocProvider<CurrentLocationBloc>(create:(_)=> CurrentLocationBloc()),
        // ChangeNotifierProvider(create: (_)=>CurrentLocationNotifer()),
      ],
      child: Scaffold(
          body: PageView(
            controller: pageController,
            children: const [
              HomePage(),
              HistoryPage(),
              NotificationPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: Card(
            margin: const EdgeInsets.all(8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: BlocConsumer<MainBloc, int>(
                listener: (context, state) {
                  pageController.jumpToPage(state);
                },
                builder: (context, state) {
                  return BottomNavyBar(
                    selectedIndex: state,
                    itemCornerRadius: 16,
                    showElevation:
                        false, // use this to remove appBar's elevation
                    onItemSelected: (index){
                      print('test $state');
                      BlocProvider.of<MainBloc>(context)
                          .add(BottomNavOnTap(index));
                    },
                    items: [
                      BottomNavyBarItem(
                        icon: const Icon(Icons.home_outlined),
                        title: const Text('Home'),
                        activeColor: ColorsConstant.green,
                      ),
                      BottomNavyBarItem(
                        icon: Icon(CustomIcons.history),
                        title: const Text('History'),
                        activeColor: ColorsConstant.green,
                      ),
                      BottomNavyBarItem(
                          icon: const Icon(Icons.notifications_none),
                          title: const Text('Noti'),
                          activeColor: ColorsConstant.green),
                      BottomNavyBarItem(
                          icon: Icon(CustomIcons.profile),
                          title: const Text('Profile'),
                          activeColor: ColorsConstant.green),
                    ],
                  );
                },
              ),
            ),
          )),
    );
  }
}

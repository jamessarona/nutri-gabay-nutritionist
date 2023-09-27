import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/ui/appointment_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/profile_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/patient_list_page.dart';
import 'package:universal_html/html.dart' as html;

class MainPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const MainPage({super.key, required this.auth, required this.onSignOut});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  bool isHideNavBar = false;

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            showToggle: false,
            style: SideMenuStyle(
              backgroundColor: Colors.white,
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: customColor,
              selectedHoverColor: customColor,
              selectedColor: customColor,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
            ),
            title: Column(
              children: [
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 100,
                    maxWidth: 150,
                  ),
                  child: Image.asset(
                    'assets/images/logo-name.png',
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            alwaysShowFooter: true,
            footer: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SideMenuItem(
                  title: 'Settings',
                  onTap: (index, _) {},
                  icon: const Icon(Icons.settings),
                ),
                SideMenuItem(
                  title: 'Exit',
                  icon: const Icon(Icons.exit_to_app),
                  onTap: (index, _) {
                    FireBaseAuth()
                        .signOut()
                        .then((value) async => html.window.location.reload());
                  },
                ),
              ],
            ),
            items: [
              SideMenuItem(
                title: 'My Profile',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(FontAwesomeIcons.user),
              ),
              SideMenuItem(
                title: 'Patients',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(FontAwesomeIcons.clipboard),
              ),
              SideMenuItem(
                title: 'Appointment Request',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(FontAwesomeIcons.calendarDays),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                ProfilePage(),
                PatientListPage(),
                AppointmentPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

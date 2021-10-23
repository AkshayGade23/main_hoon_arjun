// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/screens/homepage_screen.dart';

import './about_screen.dart';
import '../screens/desired_shlok_screen.dart';
import '../screens/language_preference_screen.dart';
import '../screens/signout_splash_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.network(
                      "https://pbs.twimg.com/profile_images/843401950448111617/M_vs7v5C_400x400.jpg",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'Vijay Jha',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 50,
          ),
          choice(context, 'About'),
          choice(context, 'Language'),
          const SizedBox(
            height: 50,
          ),
          const Divider(),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Sign Out"),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                  content: Text("Do you really want to Sign out?"),
                  actions: [
                    OutlinedButton(
                        onPressed: () async {
                          await Future.delayed(Duration(milliseconds: 200));
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel")),
                    OutlinedButton(
                        onPressed: () async {
                          await Future.delayed(Duration(milliseconds: 200));
                          // Navigator.pushNamed(
                          //     context, HomepageScreen.routeName);
                          Navigator.pushNamed(
                              context, SignOutSplashScreen.routeName);
                        },
                        child: Text("Sign Out")),
                  ],
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          )
        ],
      ),
    );
  }

  InkWell choice(BuildContext ctx, String choice) {
    return InkWell(
      onTap: () {
        if (choice == "About") {
          Navigator.pushNamed(ctx, AboutScreen.routeName);
        } else {
          Navigator.pushNamed(ctx, LanguagePreferenceScreen.routeName);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey.shade300),
          border: Border(
            bottom: choice == "Language"
                ? BorderSide(width: 1, color: Colors.grey.shade300)
                : BorderSide.none,
            top: BorderSide(
              width: 1,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              choice,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

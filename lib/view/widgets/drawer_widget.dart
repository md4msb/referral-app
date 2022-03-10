import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:referral/repositories/user_repository.dart';
import 'package:share_plus/share_plus.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserRepository.instance.currentUserNotifier.value;
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        color: const Color(0xFF0e1e4f),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 6, 37, 121),
                  maxRadius: 30,
                  child: Icon(
                    Icons.account_circle,
                    size: 46,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  user.name.toUpperCase(),
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 65,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      final url = user.referLink;
                      await Share.share(url);
                    },
                    leading: const Icon(
                      Icons.share,
                      color: Color.fromARGB(255, 128, 151, 163),
                    ),
                    title: Text(
                      "share refferal link",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFd5dcf3),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await UserRepository.instance.logOutUser();
                    },
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Color.fromARGB(255, 128, 151, 163),
                    ),
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFd5dcf3),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

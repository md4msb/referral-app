import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:referral/repositories/user_repository.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserRepository.instance.currentUserNotifier.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 25,
            bottom: 25,
          ),
          child: Text(
            "REFERRAL DASHBOARD",
            style: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 153, 153, 153)),
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              categoryCard(context,
                  title: "Total reward earned", value: user.reward),
              categoryCard(context,
                  title: "Total Number of referee", value: user.reward ~/ 100),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        )
      ],
    );
  }

  Padding categoryCard(BuildContext context,
      {required String title, required int value}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 5),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width / 2,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                color: const Color(0xFFCACACA),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              value.toString(),
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

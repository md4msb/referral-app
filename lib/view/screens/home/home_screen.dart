import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:referral/model/referee_model.dart';
import 'package:referral/view/widgets/drawer_widget.dart';
import '../../widgets/dashboard.dart';
import 'home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomeState>(context);
    final userState = state.userRepo.currentUserNotifier.value;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 252, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Image.asset("assets/images/appbarleading.png"),
          );
        }),
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                "What's up, ${userState.name}!",
                style: GoogleFonts.roboto(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Dashboard(),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 20),
              child: Text(
                "REFERRALS",
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 153, 153, 153)),
              ),
            ),
            StreamBuilder(
              stream: state.userRepo.getRefereeDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("something went wrong! ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  List<RefereeModel> referees =
                      snapshot.data as List<RefereeModel>;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: referees.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 25, left: 20, right: 20),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color:
                                      const Color(0xFF979797).withOpacity(0.25),
                                  blurRadius: 35,
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () {},
                              leading: const CircleAvatar(
                                child: Icon(Icons.account_circle_rounded),
                              ),
                              title: Text(referees[index].name),
                            ),
                          ),
                        );
                      });
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                      ),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = HomeState();
    return ChangeNotifierProvider.value(
      value: state,
      child: const HomeScreen(),
    );
  }
}

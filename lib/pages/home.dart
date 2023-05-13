import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waste_time/widgets/resuable_card.dart';
import 'package:waste_time/widgets/reusable_card_content.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 90,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))),
          title: Text(
            '${_auth.currentUser!.displayName}, Welcome to Waste Time',
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            cardChild: const ReusableCardContent(
                              imageLink: "assets/images/schedule.png",
                              label: 'Schedule Service',
                            ),
                            action: () {
                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             CommodityPricesScreen(
                              //               commodityItems: commodityItems,
                              //             )),
                              //     (route) => true);
                            },
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            cardChild: const ReusableCardContent(
                              imageLink: "assets/images/chat.png",
                              label: 'Chat with us',
                            ),
                            action: () {
                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //         builder: (context) => const DistrictsPage(
                              //               screen: 'home',
                              //             )),
                              //     (route) => true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            cardChild: const ReusableCardContent(
                              imageLink: "assets/images/recents.png",
                              label: 'Recent Schedules',
                            ),
                            action: () async {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //       builder: (BuildContext context) =>
                              //           const GroupIndex()),
                              // );
                            },
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            cardChild: const ReusableCardContent(
                              imageLink: "assets/images/account.png",
                              label: 'Account',
                            ),
                            action: () async {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //       builder: (BuildContext context) =>
                              //           const FarmerGrpMembers()),
                              // );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waste_time/models/company_info.dart';

import '../../../controllers/schedule_controller.dart';

class CompanySelection extends StatefulWidget {
  final List<CompanyInfor> companies;
  const CompanySelection({super.key, required this.companies});

  @override
  State<CompanySelection> createState() => _CompanySelectionState();
}

class _CompanySelectionState extends State<CompanySelection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(
      init: ScheduleController(),
      builder: (companiesAdmin) {
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text(
              "Please select Waste Company",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          body: ListView(
            children: List.generate(widget.companies.length, (index) {
              final results = widget.companies[index];
              return InkWell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[200],
                      child: Text(results.name,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 16.5,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
                onTap: () async {
                  await companiesAdmin.updateSelectedWasteCompany(results.name);
                  await companiesAdmin.updateCompanyId(results.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              );
            }),
          ),
        );
      },
    );
  }
}
